class UsersController < ApplicationController
  include Authentication
  
  def create
    User.create(params[:user].merge(:key, decrypt(params[:user][:key])))
  end
  
  def new
    respond_to do |format|
      format.json { { :public_key => public_key } }
    end
  end
end