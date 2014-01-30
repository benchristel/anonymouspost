class User < ActiveRecord::Base
  include Encryption

  attr_accessible :key
  attr_accessor :key

  validates_presence_of :key_hash
  validates_length_of :key_hash, :minimum => 64, :maximum => 64
  
  def self.find_or_create_by_key(key)
    find_or_create_by_key_hash(sha(key)).tap do |user|
      user.key = key
    end
  end
  
  def key=(key)
    @key = key
    self.key_hash = User.sha(key)
  end
  
  def self.exists_with_key?(key)
    !User.find_by_key_hash(sha(key)).nil?
  end
  
  def self.find_by_key(key, *args, &block)
    User.find_by_key_hash(sha(key), *args, &block)
  end
  
  def self.find_all_by_key(key, *args, &block)
    User.find_all_by_key_hash(sha(key), *args, &block)
  end
  
end