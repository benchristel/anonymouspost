class SwitchLongLatToDecimal < ActiveRecord::Migration
  def up
    change_column :posts, :longitude, :decimal, :precision => 16, :scale => 13
    change_column :posts, :latitude, :decimal, :precision => 16, :scale => 13
  end

  def down
    change_column :posts, :longitude, :float
    change_column :posts, :latitude, :float
  end
end
