class Odin
  include Encryption
  
  def self.sign_in(user_key)
    User.find_or_create_by_key_hash(sha(user_key))
  end
  
  def self.post(options={})
    if user = User.find_by_key(options[:user_key])
      Post.create!(options)
    end
  end
  
  def self.delete(post_id, user_key)
    post = Post.find post_id
    if post.belongs_to?(user_key)
      post.destroy
    end
  end
end
