class Post < ActiveRecord::Base
  include Location
  include Encryption
  
  attr_accessible :content, :latitude, :longitude, :user_key
  
  has_many :votes, :dependent => :delete_all
  
  after_initialize :set_vote_total
  before_save      :set_vote_total
  
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
  
  DISTANCE_FALLOFF_RATE = 10000.0 # chosen arbitrarily for now
  POST_HALFLIFE_SECONDS = 3600 * 24.0
  scope :by_relevance, lambda { |longitude, latitude, time=Time.now|
    order(<<-SQL)
      posts.vote_multiplier /
      (
        (1 + #{DISTANCE_FALLOFF_RATE} * (POW(posts.longitude - #{longitude.to_f},2) + POW(posts.latitude - #{latitude.to_f},2))) -- distance falloff
        * POW(2, -#{POST_HALFLIFE_SECONDS} * (#{time.to_f} - posts.timestamp)) -- decay over time
      )
      DESC
    SQL
  }
  
  METERS_PER_DEGREE = 111000.0 # rough approximation
  scope :within, lambda { |meters, longitude, latitude|
    max_degrees_away = meters / METERS_PER_DEGREE
    where "posts.longitude > ? and posts.longitude < ? and posts.latitude > ? and posts.latitude < ?",
        longitude - max_degrees_away,
        longitude + max_degrees_away,
        latitude - max_degrees_away,
        latitude + max_degrees_away
  }
  
  def self.most_relevant(desired_number_of_posts, longitude, latitude, time=Time.now, page=1, per_page=desired_number_of_posts)
    meters_away_to_look = 100
    while Post.within(meters_away_to_look, of=longitude, latitude).count < desired_number_of_posts &&
          meters_away_to_look < 10_000
      meters_away_to_look *= 2
    end
    
    scoped = Post.within(meters_away_to_look, of=longitude, latitude).by_relevance(longitude, latitude, time).limit(per_page).offset(per_page * (page - 1))
    puts scoped.to_sql
    scoped
  end
  
  
  
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
  
  VOTE_MULTIPLIER_CONSTANT = 0.25
  private
  def set_vote_total
    puts "set vote total: #{votes.count} votes"
    self.vote_total = votes.sum(:value)
    self.vote_multiplier = vote_total < 0 ?
        Math::E**(vote_total*VOTE_MULTIPLIER_CONSTANT) :
        (vote_total*VOTE_MULTIPLIER_CONSTANT)+1
  end
end
