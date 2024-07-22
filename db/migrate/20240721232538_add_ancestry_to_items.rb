class AddAncestryToItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :items, :parent_id, :integer
    add_column :items, :ancestry, :string
    add_index :items, :ancestry
  end
end
