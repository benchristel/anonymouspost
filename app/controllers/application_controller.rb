class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def sign_in
    puts params.inspect
    @me = Odin.sign_in(params[:user_key])
    @me.viewer_longitude = params[:longitude].to_f
    @me.viewer_latitude  = params[:latitude].to_f
  end
end
