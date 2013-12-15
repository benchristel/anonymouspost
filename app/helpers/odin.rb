class Odin
  attr_accessor :user
  
  def self.sign_in(user_key)
    user = User.find_or_create_by_key(user_key)
    self.new(:user => user)
  end
  
  def initialize(options={})
    self.user      = options[:user]
  end
  
  public
  def list_posts_within(meters, longitude, latitude)
    Post.most_relevant(100, near = longitude, latitude)
  end
  
  public
  def post(options={})
    options = options.reverse_merge(
      :user_key  => user.key
    )  
    Post.create!(options)
  end
  
  public
  def delete(post_id)
    post = Post.find post_id
    if post.belongs_to?(user)
      post.destroy
    end
  end
  
  alias_method :delete_post, :delete
  
  public
  def upvote(post_id)
    vote post_id, 1
  end
  
  public
  def downvote(post_id)
    vote post_id, -1
  end
  
  public
  def unvote(post_id)
    vote post_id, 0
  end
  
  private
  def vote(post_id, direction)
    ActiveRecord::Base.transaction do
      Post.find(post_id).tap do |post|
        delta = Vote.vote!(user.key, post, direction)
        post.vote_total += delta
        post.save!
      end
    end
  end
end
