class Comments < ActiveRecord::Migration
  def change
    create_table "comments", :force => true do |t|
      t.integer "original_post_id",                                :null => false
      t.integer "parent_comment_id"
      t.string   "content",         :limit => 720
      t.string   "thread_user_hash",       :limit => 10,                   :null => false
      t.integer  "timestamp",                                       :null => false
      t.decimal    "longitude"
      t.decimal    "latitude"
      t.integer  "vote_total",                     :default => 0,   :null => false
      t.float    "vote_multiplier",                :default => 1.0, :null => false
      t.datetime "created_at",                                      :null => false
      t.datetime "updated_at",                                      :null => false
    end
  end

end
