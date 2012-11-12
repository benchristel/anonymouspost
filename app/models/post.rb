class Post < ActiveRecord::Base
  include Location
  include Encryption
  
  attr_accessible :content, :latitude, :longitude, :user_key
  
  validates_presence_of :timestamp
  validates_presence_of :xash
  validates_length_of :xash, :minimum => 64, :maximum => 64
  validates :longitude, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :timestamp, :numericality => true
  validate :user_key_valid
  
  def user_key_valid
    errors.add(:user_key, "User key not valid") unless @temp_user_key && User.exists_with_key?(@temp_user_key)
  end
  
  before_save :update_user_post_time
  def update_user_post_time
    User.find_by_key(@temp_user_key).post!(self) if @temp_user_key
  end
  
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
    raise NoMethodError
  end
  
  def vote!(delta)
    v = vote_total + delta
    c = 0.25
    if v < 0
      multiplier = Math.exp(v*c)
    else
      multiplier = (v*c)+1
    end
    self.vote_total = v
    self.vote_multiplier = multiplier
    save!
  end
  
  def self.find_by_location_and_time(long, lat, time)
    time = time.to_i
    max_dist = degrees_from_meters 100
    max_days_ago = 7
    results = []
    while results.length < 100 && queries < 5
      results = Post.all.where(["longitude > ? and longitude < ? and latitude > ? and latitude < ? and timestamp > ? and timestamp < ?",
                                long - max_dist,   long + max_dist,  lat - max_dist,  lat + max_dist,  time - max_days_ago*3600*24, time
                              ])
      queries += 1
    end
    results.sort_by do |post|
      time_multiplier = 2 ** (-1/(3600*24*7)/(time-post.timestamp))
      dsqr = (long - post.longitude) ** 2 + (lat - post.latitude) ** 2
      distance_multiplier = 1 / (1+0.0001*dsqr)
      post.vote_multiplier * time_multiplier * distance_multiplier 
    end
  end
  
  def self.location=(xy)
    self.longitude = xy[0]
    self.latitude = xy[1]
  end
  
  def self.location
    [self.longitude, self.latitude]
  end
  
  
  
end
