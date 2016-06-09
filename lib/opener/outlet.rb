require 'securerandom'
require 'stringio'

require 'active_record'
require 'nokogiri'
require 'opener/kaf_to_json'

require_relative 'outlet/output'
require_relative 'outlet/version'
require_relative 'outlet/server'
require_relative 'outlet/visualizer'

require_relative '../../config/database'

module Opener
  class Outlet
    attr_reader :uuid

    def initialize(options = {})
      @uuid = options[:request_id] || SecureRandom.hex
    end

    def run(input)
      output = Output.new(:uuid=>uuid, :text=>input)

      output.save!

      return input
    end
  end
end
