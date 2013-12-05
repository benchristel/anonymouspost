class Vote < ActiveRecord::Base
  
  include Encryption
  
  attr_accessible :xash
  
  # returns the amount by which the vote total was adjusted
  def self.vote!(user_key, post, direction)
    vote_delta = 0
    
    return 0 unless User.find_by_key user_key
    direction = 1 if direction > 0
    direction = -1 if direction < 0
    
    upvote_to_undo   = find_by_hash_components(user_key, post, 1)
    downvote_to_undo = find_by_hash_components(user_key, post, -1)
    
    if upvote_to_undo
      vote_delta -= 1
      upvote_to_undo.destroy
    end
    
    if downvote_to_undo
      vote_delta += 1
      downvote_to_undo.destroy
    end
    
    if direction != 0
      new_vote = create_by_hash_components(user_key, post, direction)
      vote_delta += direction
    end
    vote_delta
  end
  
  def self.find_by_hash_components(user_key, post, direction)
    Vote.find_by_xash(Vote.generate_hash(user_key, post, direction))
  end
  
  def self.create_by_hash_components(user_key, post, direction)
    Vote.create(:xash => Vote.generate_hash(user_key, post, direction))
  end
  
  private
  
  def self.generate_hash(user_key, post, direction)
    sha(user_key.to_s + post.id.to_s + direction.to_s)
  end
  
end
