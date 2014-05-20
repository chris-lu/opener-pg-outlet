require 'active_record'

module Opener
  class Outlet
    class Output < ActiveRecord::Base       
       validates_uniqueness_of :uuid
    end
  end
end