class AddReferendums < ActiveRecord::Migration
  def up
    create_table :referendums do |t|
      t.integer :vote_total, :default => 0, :null => false
    end
    rename_column :votes, :post_id, :referendum_id
    add_column :posts, :referendum_id, :integer
    add_column :comments, :referendum_id, :integer
    remove_column :posts, :vote_total
    remove_column :posts, :vote_multiplier
  end

  def down
    add_column :posts, :vote_multiplier, :integer, :default => 1, :null => false
    add_column :posts, :vote_total, :integer, :default => 0, :null => false
    remove_column :comments, :referendum_id
    remove_column :posts, :referendum_id
    rename_column :votes, :referendum_id, :post_id
    drop_table :referendums
  end
end
