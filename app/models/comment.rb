class Comment < ActiveRecord::Base
  include Location
  include Voting

  attr_accessible :content, :latitude, :longitude, :user_key, :post, :parent
  attr_accessor :user_hash
  belongs_to :parent, :class_name => 'Comment', :foreign_key => :parent_comment_id
  has_many :replies, :class_name => 'Comment', :foreign_key => :parent_comment_id
  belongs_to :post, :foreign_key => :original_post_id

  validates_presence_of :timestamp
  validates_presence_of :thread_user_hash, :original_post_id
  validates_length_of :thread_user_hash, :minimum => 64, :maximum => 64
  #validates :longitude, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  #validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :timestamp, :numericality => true

  before_validation :before_validation_cb
  def before_validation_cb
    if timestamp.nil?
      self.timestamp = Time.new.to_i
      set_thread_user_hash
    end
  end

  def content=(new_content)
    super(LinkHighlighter.new(HtmlSanitizer.new(new_content)).to_s)
  end

  def set_thread_user_hash
    self.thread_user_hash = compute_thread_user_hash if user_key.present?
  end

  def compute_thread_user_hash(_user_key=user_key)
    Encryption.sha(_user_key.to_s + original_post_id.to_s)
  end

  def user_key=(key)
    @temp_user_key = key
  end

  def user_key #hack to prevent reading from write-only attribute
    @temp_user_key
  end

  def belongs_to?(user)
    user = user.key if user.is_a? User
    thread_user_hash == Encryption.sha(user.to_s + original_post_id.to_s)
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
