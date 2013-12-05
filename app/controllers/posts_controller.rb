class PostsController < ApplicationController
  include Authentication
  
  before_filter :decrypt_user_key!
  before_filter :authenticate!
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    user = User.find_by_key(params[:id])
    @post = Post.find(params[:id])
    respond_to do |format|
      format.json {
        unless User.owns_post?(@post)
          render(:status => 401)
        else
          render(:json => @post)
        end
      }
    end
    
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Odin.sign_in(params[:user_key]).post(:content => params[:content])
  
    respond_to do |format|
      if @post
        format.json { render json: @post, status: :created, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def upvote
    @vote = Odin.sign_in(params[:user_key]).upvote(params[:id])
    @post = Post.find_by_id(params[:id])
    respond_to do |format|
      if @post
        format.html { redirect_to @post, notice: 'Vote was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def downvote
    @vote = Odin.sign_in(params[:user_key]).downvote(params[:id])
    @post = Post.find_by_id(params[:id])
    respond_to do |format|
      if @post
        format.html { redirect_to @post, notice: 'Vote was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def unvote
    @vote = Odin.sign_in(params[:user_key]).unvote(params[:id])
    @post = Post.find_by_id(params[:id])
    respond_to do |format|
      if @post
        format.html { redirect_to @post, notice: 'Vote was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.json { head :no_content }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
