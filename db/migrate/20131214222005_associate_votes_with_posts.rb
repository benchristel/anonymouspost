class AssociateVotesWithPosts < ActiveRecord::Migration
  def up
    add_column :votes, :post_id, :integer
    add_column :votes, :value, :integer
  end

  def down
    remove_column :votes, :post_id
    remove_column :votes, :value
  end
end
