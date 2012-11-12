class User < ActiveRecord::Base
  include Encryption
  
  attr_accessible :key
  
  validates_presence_of :key_hash
  validates_length_of :key_hash, :minimum => 64, :maximum => 64
  
  def key=(key)
    self.key_hash = User.sha(key)
  end
  
  def has_key?(key)
    key_hash == User.sha(key)
  end
  
  def can_post?
    Time.new.to_i > posting_allowed_after
  end
  
  def post!(post)
    self.posting_allowed_after = Time.new.to_i + post.content.length / 6
  end
  
  def can_vote_on_post?(key, post, direction)
    Vote.find_by_hash_components(key, post, direction).nil?
  end
  
  def self.owns_post?(key, post)
    Post.hash == sha(key + Post.timestamp.to_s)
  end
  
  def self.exists_with_key?(key)
    !User.find_by_key_hash(sha(key)).nil?
  end
  
  def self.find_by_key(key, *args, &block)
    User.find_by_key_hash(sha(key), *args, &block)
  end
  
  def self.find_all_by_key(key, *args, &block)
    User.find_all_by_key_hash(sha(key), *args, &block)
  end
  
end