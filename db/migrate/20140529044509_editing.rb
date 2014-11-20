class Editing < ActiveRecord::Migration
def change
  create_table :editables do |t|
    t.timestamps
  end
  add_column :posts, :editable_id, :integer
  add_column :comments, :editable_id, :integer

  create_table :edits do |t|
    t.text  :content, :null => false
    t.integer :editable_id
    t.timestamps
  end
end
end
