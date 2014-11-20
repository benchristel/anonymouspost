class ThreadUserHashSize < ActiveRecord::Migration
  def up
    change_column "comments", "thread_user_hash", "string", :limit =>64
  end

  def down
    change_column "comments", "thread_user_hash", "string", :limit =>10
  end
end
