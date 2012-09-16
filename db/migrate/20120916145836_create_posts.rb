class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.string :hash
      t.integer :timestamp
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
