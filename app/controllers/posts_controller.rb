class PostsController < ApplicationController
  def index
    render json: {posts: Post.all}
  end

  def create
    Post.create_from params
    head :created
  end
end
