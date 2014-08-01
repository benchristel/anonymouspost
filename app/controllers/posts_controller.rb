class PostsController < ApplicationController
  before_filter :sign_in

  # GET /posts
  # GET /posts/near/:longitude/:latitude
  # GET /posts.json
  def index
    if params[:longitude] && params[:latitude]
      @posts = Odin.new.list_posts_near(params[:longitude].sub(/,/,'.').to_f, params[:latitude].sub(/,/,'.').to_f)
    else
      @posts = Post.last(30)
    end
    @post = Post.new

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        presenters = @posts.map do |post|
          PostsPresenter.new(post, @me)
        end

        puts presenters.as_json

        render :json => {posts: presenters}
      end
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
    user = User.find_by_key(params[:user_key])
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
  #
  def create
    @post = @me.post(params[:post])
    respond_to do |format|
      if @post
        format.json do
          render json: PostsPresenter.new(
            @post,
            @me
          ), status: :created, location: @post
        end
        #format.js�� {}
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def upvote
    puts "BITCH< I BE TRYIN TO VOTE"
    @vote = @me.upvote(params[:id])
    @post = Post.find_by_id(params[:id])
    respond_to do |format|
      if @post
        format.html { redirect_to @post, notice: 'Vote was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
        #format.js�� {}
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def downvote
    @vote = @me.downvote(params[:id])
    @post = Post.find_by_id(params[:id])
    respond_to do |format|
      if @post
        format.html { redirect_to @post, notice: 'Vote was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
        #format.js�� {}
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
    puts "UPDATE BITCH"
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
    @me.delete_post(params[:id])
    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
