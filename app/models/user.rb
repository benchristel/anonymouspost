class User < ActiveRecord::Base
  include Viewer

  attr_accessible :key, :key_hash
  attr_accessor :key

  validates_presence_of :key_hash
  validates_length_of :key_hash, :minimum => 64, :maximum => 64

  def self.create_by_key(key)
    User.create(:key_hash  => Encryption.sha(key)).tap do |user|
      user.key = key
    end
  end

  def self.find_or_create_by_key(key)
    find_or_create_by_key_hash(Encryption.sha(key)).tap do |user|
      user.key = key
    end
  end

  def self.exists_with_key?(key)
    !User.find_by_key_hash(Encryption.sha(key)).nil?
  end

  def self.find_by_key(key, *args, &block)
    User.find_by_key_hash(Encryption.sha(key), *args, &block).tap do |user|
      if user
        user.key = key
      end
    end
  end

  def self.find_all_by_key(key, *args, &block)
    User.find_all_by_key_hash(Encryption.sha(key), *args, &block)
  end

  def key=(key)
    @key = key
    self.key_hash = Encryption.sha(key)
  end

  def viewer_user
    self
  end
end
