require 'sinatra'
require 'nokogiri'

module Opener
  class Outlet
    class Server < Sinatra::Base
      
      post '/' do
        output            = Output.new
        output.uuid         = params[:request_id]
        output.text       = params[:input]
        output.save
      end

      get '/:request_id' do
        unless params[:request_id] == 'favicon.ico'
          begin
            output = Output.find_by_uuid(params[:request_id])
            # doc = Nokogiri::XML(output.text)
            # xslt = Nokogiri::XSLT(File.read('vu_opinion_template.xsl'))
            # xslt.transform(doc).to_s
            content_type(:xml)
            output.text
          rescue => error
            error_callback = params[:error_callback]
            submit_error(error_callback, error.message) if error_callback
            halt(500, error.message)      
          end
        end
      end

      def submit_error(url, message)
        HTTPClient.post(url, :body => {:error => message})
      end
      
    end
  end
end