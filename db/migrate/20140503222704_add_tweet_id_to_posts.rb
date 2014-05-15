class AddTweetIdToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :tweet_id, :string
    add_index :posts, :tweet_id
  end
  
  def down
    remove_column :posts, :tweet_id, :string
  end
end
