class Vote < ActiveRecord::Base
  
  include Encryption
  
  def self.vote!(user_key, post, direction)
    raise ArgumentError if direction != -1 && direction != 0 && direction != 1
    
    hash = Vote.generate_hash(user_key, post, direction)
    
    if Vote.find_by_hash(hash).nil?
      #user can vote on this post
      if direction != 0
        reverse_vote_hash = Vote.generate_hash(user_key, post, -direction)
        v = Vote.create(:hash => hash)
        post.vote!(direction * (1 + Vote.delete_all(:hash => reverse_vote_hash)))
      else
        # set vote back to neutral
        post.vote(1) if Vote.delete_all(:hash => Vote.generate_hash(user_key, post, -1)) > 0
        post.vote(-1) if Vote.delete_all(:hash => Vote.generate_hash(user_key, post, 1)) > 0
      end
      true
    else
      #user already voted this post in this direction
      false
    end
  end
  
  def find_by_hash_components(user_key, post, direction)
    Vote.find_by_hash(Vote.generate_hash(user_key, post, direction))
  end
  
  private
  
  def self.create
    super
  end
  
  def self.new
    super
  end
  
  def save
    super
  end
  
  def self.generate_hash(user_key, post, direction)
    sha(user_key.to_s + post.id.to_s + direction.to_s)
  end
  
end
