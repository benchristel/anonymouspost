class ApplicationController < ActionController::Base
  before_action { puts "setting content type"; request.env["CONTENT_TYPE"] = 'application/json' }
end
