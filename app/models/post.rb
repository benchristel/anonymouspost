class Post < ActiveRecord::Base
  include Location
  include Encryption
  
  attr_accessible :content, :latitude, :longitude, :user_key
  
  validates_presence_of :timestamp
  validates_presence_of :xash
  validates_length_of :xash, :minimum => 64, :maximum => 64
  #validates :longitude, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  #validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :timestamp, :numericality => true
  
  before_validation :before_validation_cb
  def before_validation_cb
    self.timestamp = Time.new.to_i
    self.xash = Post.sha(@temp_user_key.to_s + self.timestamp.to_s)
  end
  
  #######################################
  # HERE ARE SOME METHODS YOU SHOULD CALL
  
  def user_key=(key)
    @temp_user_key = key
  end
  
  def user_key #hack to prevent reading from write-only attribute
    nil
  end
  
  def belongs_to?(user)
    user = user.key if user.is_a? User
    xash == Post.sha(user + timestamp.to_s)
  end
  
  def votes
    vote_total
  end
end
