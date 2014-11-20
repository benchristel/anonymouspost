class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Location
  include Caches
  # include Voting

  field :content, type: String
  field :user_hash, type: String
  field :timestamp, type: Integer
  field :longitude, type: Rational
  field :latitude, type: Rational
  field :created_at, type: Time
  field :tweet_id, type: Integer
  field :referendum_id, type: Integer
  field :editable_id, type: Integer

  has_many :tags

  def comments
    []
  end

  def vote_total
    0
  end

  #
  # attr_accessible :content, :latitude, :longitude, :user_key, :tweet_id

  # has_many  :comments, :foreign_key => :original_post_id

  # has_and_belongs_to_many :tags
  # validates_presence_of :timestamp
  # validates_presence_of :user_hash
  # validates_length_of :user_hash, :minimum => 64, :maximum => 64
  # validates :longitude, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  # validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  # validates :timestamp, :numericality => true

  # editable stuff
  # belongs_to :editable
  # has_many  :edits, :through => :editable
  # after_initialize :initialize_editable
  # def initialize_editable
  #   self.editable ||= Editable.new
  # end
  # before_create :save_editable
  # def save_editable
  #   editable.save
  # end

  # before_validation :before_validation_cb
  # def before_validation_cb
  #   if new_record?
  #     self.timestamp = Time.new.to_i
  #     set_user_hash
  #   end
  # end

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
    joins(:referendum).
    order(<<-SQL)
      (if(referendums.vote_total < 0,
           POW(#{Math::E}, referendums.vote_total * 0.25),
           referendums.vote_total * 0.25 + 1
         ) -- vote multiplier
      ) /
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
    user_hash == Encryption.sha(user.to_s + timestamp.to_s)
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

  def direction(long, lat)
    vector = [
      longitude - long.to_f,
      latitude  - lat.to_f,
    ]

    return :HERE if Math.abs(vector[0]) < 0.001 && Math.abs(vector[1]) < 0.001

    { :N  => [ 0.0,    1.0  ],
      :NE => [ 0.707,  0.707],
      :E  => [ 1.0,    0.0  ],
      :SE => [ 0.707, -0.707],
      :S  => [ 0.0,   -1.0  ],
      :SW => [-0.707, -0.707],
      :W  => [-1.0,    0.0  ],
      :NW => [-0.707,  0.707],
      # CATSBY: Where do balloons go, Twisp?
      # TWISP: *Away*.
    }.inject([:AWAY, 1_000_000]) do |closest, k, v|
      dist_squared = (vector[0] - v[0])**2 + (vector[1] - v[1])**2
      if dist_squared < closest[1]
        [k, dist_squared]
      else
        closest
      end
    end[0]
  end
end
