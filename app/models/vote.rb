class Vote < ActiveRecord::Base
  
  include Encryption
  
  attr_accessible :xash, :value, :post
  
  belongs_to :post
  after_save    :save_post
  after_destroy :save_post
  
  # returns the amount by which the vote total was adjusted
  def self.vote!(user_key, post, direction)
    vote_delta = 0
    
    return 0 unless User.find_by_key user_key
    direction = 1 if direction > 0
    direction = -1 if direction < 0
    
    vote_to_undo   = find_by_hash_components(user_key, post)
    
    if vote_to_undo
      vote_delta -= vote_to_undo.value
      vote_to_undo.destroy
    end
    
    if direction != 0
      new_vote = create_by_hash_components_and_value(user_key, post, direction)
      vote_delta += direction
    end
    vote_delta
  end
  
  def self.find_by_hash_components(user_key, post)
    Vote.find_by_xash(Vote.generate_hash(user_key, post))
  end
  
  def self.create_by_hash_components_and_value(user_key, post, value)
    Vote.create(:xash => Vote.generate_hash(user_key, post), :value => value, :post => post)
  end
  
  def +(other)
    value + other.value
  end
  
  private
  def save_post
    post.save!
  end
  
  private
  def self.generate_hash(user_key, post)
    sha(user_key.to_s + post.id.to_s)
  end
  
end
