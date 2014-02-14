module Viewer
  extend ActiveSupport::Concern
  
  included do |base|
    attr_accessor :viewer_longitude
    attr_accessor :viewer_latitude
    attr_accessor :viewer_roles
    attr_accessor :viewer_user
  end
end
