class RenamingXash < ActiveRecord::Migration
  def change
    rename_column :votes, "xash", :uid
  end

end
