class Vote < ActiveRecord::Base
  
  include Encryption
  
  attr_accessible :xash
  
  def self.vote!(user_key, post, direction)
    return false unless User.find_by_key user_key
    direction = 1 if direction > 0
    direction = -1 if direction < 0
    
    
    xash = Vote.generate_hash(user_key, post, direction)
    
    if Vote.find_by_xash(xash).nil?
      #user can vote on this post
      if direction != 0
        reverse_vote_hash = Vote.generate_hash(user_key, post, -direction)
        v = Vote.create(:xash => xash)
        post.vote! direction * (1 + Vote.delete_all(:xash => reverse_vote_hash))
      else
        # set vote back to neutral
        post.vote!(1) if Vote.delete_all(:xash => Vote.generate_hash(user_key, post, -1)) > 0
        post.vote!(-1) if Vote.delete_all(:xash => Vote.generate_hash(user_key, post, 1)) > 0
      end
      true
    else
      #user already voted this post in this direction
      false
    end
  end
  
  def find_by_hash_components(user_key, post, direction)
    Vote.find_by_xash(Vote.generate_hash(user_key, post, direction))
  end
  
  private
  
  def self.generate_hash(user_key, post, direction)
    sha(user_key.to_s + post.id.to_s + direction.to_s)
  end
  
end
