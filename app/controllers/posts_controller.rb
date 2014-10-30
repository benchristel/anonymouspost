class PostsController < ApplicationController
  def index
    render json: {posts: Post.all}
  end

  def create
    puts "---------------"
    puts request.content_type
    Post.create_from params
    head :created
  end
end
