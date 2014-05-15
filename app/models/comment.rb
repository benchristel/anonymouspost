class Comment < ActiveRecord::Base
  include Location
  include Caches
  include Voting

  attr_accessible :content, :latitude, :longitude, :user_key
  has_many :votes, :dependent => :delete_all

  before_save :set_vote_total

  validates_presence_of :timestamp
  validates_presence_of :user_hash
  validates_length_of :user_hash, :minimum => 64, :maximum => 64
  #validates :longitude, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  #validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :timestamp, :numericality => true

  before_validation :before_validation_cb
  def before_validation_cb
    if timestamp.nil?
      self.timestamp = Time.new.to_i
      set_user_hash
    end
  end

  def content=(new_content)
    super(LinkHighlighter.new(HtmlSanitizer.new(new_content)).to_s)
  end

  def set_user_hash
    self.user_hash = compute_user_hash if user_key.present?
  end

  def compute_user_hash(_user_key=user_key)
    Encryption.sha(_user_key.to_s + timestamp.to_s)
  end

  DISTANCE_FALLOFF_RATE = 10000.0 # chosen arbitrarily for now
  POST_HALFLIFE_SECONDS = 3600 * 24.0
  scope :by_relevance, lambda { |longitude, latitude, time=Time.now|
    includes(:votes).
    order(<<-SQL)
      posts.vote_multiplier /
      (1 + #{DISTANCE_FALLOFF_RATE} * (POW(posts.longitude - #{longitude.to_f},2) + POW(posts.latitude - #{latitude.to_f},2))) -- distance falloff
      * POW(2, -(#{time.to_f} - posts.timestamp) / #{POST_HALFLIFE_SECONDS}) -- decay over time
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
          meters_away_to_look < 5_000
      meters_away_to_look *= 2
    end

    Post.within(meters_away_to_look, of=longitude, latitude).by_relevance(longitude, latitude, time).limit(per_page).offset(per_page * (page - 1))
  end

  def user_key=(key)
    @temp_user_key = key
  end

  def user_key #hack to prevent reading from write-only attribute
    @temp_user_key
  end

  def belongs_to?(user)
    user = user.key if user.is_a? User
    user_hash == Encryption.sha(user.to_s + post_id.to_s)
  end

  def editable_by?(user)
    user = user.key if user.is_a? User
    belongs_to? user
  end

  def as_json(*args)
    { :net_upvotes => vote_total,
      :content     => content,
      :created_at  => created_at,
      :updated_at  => updated_at,
      :longitude   => longitude,
      :latitude    => latitude,
      :id          => id
    }
  end


end
