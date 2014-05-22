class Odin
  include Viewer
  delegate :viewer_roles,
           :viewer_user,
  :to => :user
  require 'iconv'

  attr_accessor :user

  def self.sign_in(user_key)
    user = User.find_by_key(user_key.to_s)
    self.new(:user => user)
  end

  def self.sign_up(user_key)
    user = User.create_by_key(user_key.to_s) unless User.find_by_key(user_key.to_s)
    self.new(:user => user)
  end

  def initialize(options={})
    self.user = options[:user]
    self.viewer_longitude = options[:longitude]
    self.viewer_latitude  = options[:latitude]
  end

  public
  def list_posts_near(longitude, latitude)
    get_posts_from_twitter(longitude, latitude)
    Post.most_relevant(100, near = longitude, latitude)
  end

  public
  def post(options={})
    options = options.reverse_merge(
      :user_key  => user.key
    )
    post = Post.create!(options)
    tag  = Tag.find_or_create({:text => "hash"})
    args = {
      :post_id => post.id,
      :tag_id => tag.id
    }
    PostsTag.create!(args)
    post
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
  def comment(options)
    options = options.reverse_merge(
      :user_key  => user.key
    )
    options[:parent] = options.delete(:comment) if options[:comment]
    options[:post] = options[:parent].post if options[:parent]
    Comment.create!(options)
  end

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

  def existing_vote(post)
    return 0 if user == nil
    Vote.find_by_hash_components(user.key, post).try(:value) || 0
  end

  def can_edit?(post)
    post.editable_by?(user)
  end

  private
  def vote(post_id, direction)
    ActiveRecord::Base.transaction do
      Post.find(post_id).tap do |post|
        delta = Vote.vote!(user.key, post.referendum, direction)
      end
    end
  end

  private
  def get_posts_from_twitter(long, lat)
    TwitterApi.new.local_tweets(lat, long, 2000).each do |twitter_post|
      post_lat = twitter_post.geo.coordinates[0]
      post_long = twitter_post.geo.coordinates[1]
      post = Post.find_or_create_by_tweet_id(twitter_post.id, :latitude => post_lat, :longitude => post_long, :user_key => SecureRandom.uuid, :content => Iconv.conv("UTF8", "LATIN1", twitter_post.text));
      post.update_column(:created_at, twitter_post.created_at)
      post.save!
    end
  end
end
