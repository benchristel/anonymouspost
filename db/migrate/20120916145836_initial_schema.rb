class InitialSchema < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content, :limit=>720
      t.string :xash, :limit=>64, :null => false
      t.integer :timestamp, :null => false
      t.float :longitude, :null => false
      t.float :latitude, :null => false
      t.integer :vote_total, :default => 0, :null => false
      t.float :vote_multiplier, :default => 1, :null => false
      t.timestamps
    end
    
    create_table :votes do |t|
      t.string :xash, :limit=>64, :null => false
      t.timestamps
    end
    
    create_table :users do |t|
      t.string :key_hash, :limit=>64, :null => false
      t.integer :posting_allowed_after
    end
  end
end
