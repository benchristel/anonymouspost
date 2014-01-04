class Tags < ActiveRecord::Migration
  def change
    rename_column :posts, :xash, :user_hash
    create_table 'tags' do |t|
      t.string 'text'
    end
      
    create_table "posts_tags"  do |t|
      t.integer 'post_id'
      t.integer 'tag_id'
    end
  end

  
  
end
