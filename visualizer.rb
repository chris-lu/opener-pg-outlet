require 'nokogiri'

module Opener
  module Kaf
    module Visualizer
      class Parser
        attr_reader :doc
        attr_reader :words, :terms, :entities, :properties, :opinions, :document

        def initialize(input_file_handler)
          @doc = Nokogiri::XML(input_file_handler)
        end

        def parse
          @words      = parse_words
          @terms      = parse_terms
          @entities   = parse_entities
          @properties = parse_properties
          @opinions   = parse_opinions
          @document   = KAFDocument.new(
            :words => words,
            :terms => terms,
            :entities => entities,
            :properties => properties,
            :opinions => opinions
          )

          return document
        end

        def parse_words
          parse_elements("//wf", Word)
        end

        def parse_terms
          # Of course terms should be words here.
          # Dirty Hack, sufficient for now.
          parse_elements("//term", Term, :terms=>words)
        end

        def parse_entities
          parse_elements("//entity", Entity, :terms=>terms)
        end

        def parse_properties
          parse_elements("//property", Property, :terms=>terms)
        end

        def parse_opinions
          parse_elements("//opinion", Opinion, :terms=>terms)
        end

        def parse_elements(xpath, klass, opts={})
          elements = doc.xpath(xpath)
          lookup_table = Hash.new
          elements.each do |element|
            instance = klass.new(element, opts)
            lookup_table[instance.id] = instance
          end
          lookup_table
        end

      end

      class KAFNode
        attr_reader :content, :targets, :tag, :references

        def initialize(tag, references)
          @references = references
          @tag = tag

          set_instance_variables
          set_content
          set_targets
          process_subnodes
        end

        def set_content
          @content = tag.content
        end

        def set_instance_variables
          tag.keys.each do |key|
            if respond_to?("#{key}=".to_sym)
              send("#{key}=".to_sym, tag[key])
            else
              instance_variable_set("@#{key}", tag[key])
            end
          end
        end

        def set_targets
          @targets = []
          tag.css("span target").each do |target|
            id = target["id"]
            @targets << references[:terms][id]
          end
        end

        def process_subnodes
        end

        def has_target?(*ids)
          ids.flatten.each do |id|
            return true if target_ids.include?(id)
          end
          return false
        end

        def to_s
          if targets.size > 0
            return targets.map(&:to_s).join(" ")
          else
            return content
          end
        end

        def target_ids
          @targets.map(&:id)
        end

      end

      class Word < KAFNode
        attr_reader :wid, :sent, :para, :offset

        def id
          wid
        end

        def offset=(offset)
          @offset = offset.to_i
        end

        def length
          content.nil? ? 0 : content.length
        end

      end

      class Term < KAFNode
        attr_reader :tid, :type, :lemma, :pos, :morphofeat

        def id
          tid
        end
      end

      class Entity < KAFNode
        attr_reader :eid, :type

        def id
          eid
        end

        def to_s
          "#{type}: #{targets.map(&:to_s).join(", ")}"
        end
      end

      class Property < KAFNode
        attr_reader :pid, :lemma

        def id
          pid
        end

        def to_s
          "#{lemma}: #{targets.map(&:to_s).join(", ")}"
        end
      end

      class Opinion < KAFNode
        attr_reader :oid, :expression

        def id
          oid
        end

        def process_subnodes
          @expression = tag.xpath("//opinion_expression").first["polarity"].to_sym
        end

        def to_s
          "#{expression}: #{targets.map(&:to_s).join(", ")}"
        end

      end

      class KAFDocument
        attr_reader :words, :terms, :entities, :properties, :opinions

        def initialize(opts={})
          @words = opts.fetch(:words)
          @terms = opts.fetch(:terms)
          @entities = opts.fetch(:entities)
          @properties = opts.fetch(:properties)
          @opinions = opts.fetch(:opinions)
        end

      end

      class HTMLTextPresenter
        attr_reader :document
        def initialize(document)
          @document = document
        end

        def to_html
          offset = 0
          prev = Struct.new(:offset).new(0)

          builder = Nokogiri::HTML::Builder.new do |html|
            html.div(:class=>"opener") do
              html.p do
                document.words.values.sort_by(&:offset).each do |word|
                  if offset < word.offset
                    spacer = word.offset - offset
                    spacer = Array.new(spacer, " ").join
                    html.span(spacer)
                  end

                  terms      = targets_for(:terms, word.id)
                  entities   = targets_for(:entities, terms)
                  opinions   = opinions_for(terms)
                  properties = targets_for(:properties, terms)

                  generics = []
                  generics << "term"     if terms.size > 0
                  generics << "entity"   if entities.size > 0
                  generics << "opinion"  if opinions.size > 0
                  generics << "property" if properties.size > 0

                  classes = [terms, entities, opinions, properties, generics].flatten.uniq

                  word_annotations = classes.join(" ")

                  html.span(word.content, :class=>word_annotations, :id=>word.id)
                  offset = word.offset + word.length
                end
              end

              [:entities, :opinions, :properties].each do |sym|
                html.div(:class=>sym) do
                  document.public_send(sym).values.each do |entity|
                    html.div(entity.to_s, :id=>entity.id, :class=>entity.target_ids.join(" "))
                  end
                end
              end
            end
          end

          builder.to_html
        end

        def targets_for(variable, *ids)
          targets = document.public_send(variable.to_sym).values.select do |value|
            value.has_target?(ids.flatten)
          end

          targets.map(&:id)
        end

        def opinions_for(*ids)
          targets = document.opinions.values.select do |value|
            value.has_target?(ids.flatten)
          end

          ids = targets.map(&:id)
          sentiments = targets.map(&:expression)
          return ids.concat(sentiments).uniq
        end

      end
    end
  end
end

