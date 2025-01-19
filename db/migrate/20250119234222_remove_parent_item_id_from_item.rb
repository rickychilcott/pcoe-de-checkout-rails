class RemoveParentItemIdFromItem < ActiveRecord::Migration[7.2]
  def change
    remove_column :items, :parent_item_id, :integer
  end
end
