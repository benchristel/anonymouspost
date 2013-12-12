class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def sign_in
    @me = Odin.sign_in(params[:user_key])
  end
end
