require 'sinatra'
require 'nokogiri'
require 'stringio'
require_relative './visualizer'

require File.expand_path('../../../../config/database', __FILE__)

module Opener
  class Outlet
    class Server < Sinatra::Base

      post '/' do
        output            = Output.new
        output.uuid       = params[:request_id]
        output.text       = params[:input]
        output.save
      end

      get '/' do
        if params[:request_id]
          redirect "#{url("/")}#{params[:request_id]}"
        else
          erb :index
        end
      end
      
      get '/:request_id.json' do
        unless params[:request_id] == 'favicon.ico'
          begin
            output = Output.find_by_uuid(params[:request_id])
            if output
              content_type('text/json')
              kj = Opener::KafToJson.new
              json = kj.run(output.text) rescue output.text
              body(json)
            else
              halt(404, "No record found for ID #{params[:request_id]}")
            end
          rescue => error
            error_callback = params[:error_callback]

            submit_error(error_callback, error.message) if error_callback

            raise(error)
          end
        end
      end

      get '/:request_id' do
        unless params[:request_id] == 'favicon.ico'
          begin
            output = Output.find_by_uuid(params[:request_id])
            if output
              content_type(:xml)
              body(output.text)
            else
              halt(404, "No record found for ID #{params[:request_id]}")
            end
          rescue => error
            error_callback = params[:error_callback]

            submit_error(error_callback, error.message) if error_callback

            raise(error)
          end
        end
      end

      get '/html/:request_id' do
        unless params[:request_id] == 'favicon.ico'
          begin
            output = Output.find_by_uuid(params[:request_id])
            if output
              output = StringIO.new(output.text)
              parser = Opener::Kaf::Visualizer::Parser.new(output)
              doc = parser.parse
              html = Opener::Kaf::Visualizer::HTMLTextPresenter.new(doc)
              @parsed = html.to_html
              erb :show
            else
              halt(404, "No record found for ID #{params[:request_id]}")
            end
          rescue => error
            error_callback = params[:error_callback]

            submit_error(error_callback, error.message) if error_callback

            raise(error)
          end
        end
      end

      private

      def submit_error(url, message)
        HTTPClient.post(url, :body => {:error => message})
      end
    end # Server
  end # Outlet
end # Opener
