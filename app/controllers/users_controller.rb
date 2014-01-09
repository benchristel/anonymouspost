class UsersController < ApplicationController
  include Authentication
  
  def sign_in
    @user = Odin.sign_in(params[:key].to_s)
    respond_to do |format|
      if @user
        format.html # show.html.erb
        format.json { render json: @user }
      else
        format.json { render json: :error, status: 404 }
      end
    end
  end

  # POST /posts
  # POST /posts.json
  #
  def create
    @old = Odin.sign_in(params[:key].to_s)
    puts @old.inspect
    if !@old
      @user = Odin.sign_up(params[:key].to_s)
    else
      puts "HE/SHE EXISTED, WHOO"
    end
    respond_to do |format|
      if @user
        format.json { render json: @user, status: :created, location: @user }
      else
        format.json { render json: :error, status: :unprocessable_entity }
      end
    end
  end
  
  #def create
  #  User.create(params[:user].merge(:key, decrypt(params[:user][:key])))
  #end
  
  def new
    respond_to do |format|
      format.json { { :public_key => public_key } }
    end
  end
end