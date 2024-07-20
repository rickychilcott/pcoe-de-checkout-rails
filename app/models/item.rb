class Item < ApplicationRecord
  belongs_to :parent_item, optional: true, class_name: "Item"
  belongs_to :location
  belongs_to :group

  has_many_attached :images
  has_rich_text :description
end
