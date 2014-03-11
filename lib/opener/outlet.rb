require_relative 'outlet/output'
require_relative 'outlet/version'
require_relative 'outlet/server'

module Opener
  class Outlet
    def run(input, uuid)
      output = Output.new(:uuid=>uuid, :text=>input)
      output.save

      return input
    end
  end
end
