require 'safe_attributes/base'

module Opener
  class Outlet
    class Output < ActiveRecord::Base
      include SafeAttributes::Base
      validates_uniqueness_of :uuid
    end
  end
end
