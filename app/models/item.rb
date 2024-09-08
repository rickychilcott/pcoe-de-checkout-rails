# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  ancestry           :string
#  name               :string           not null
#  qr_code_identifier :string
#  serial_number      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  group_id           :integer          not null
#  location_id        :integer
#  parent_item_id     :integer
#
# Indexes
#
#  index_items_on_ancestry        (ancestry)
#  index_items_on_group_id        (group_id)
#  index_items_on_location_id     (location_id)
#  index_items_on_parent_item_id  (parent_item_id)
#
# Foreign Keys
#
#  group_id        (group_id => groups.id)
#  location_id     (location_id => locations.id)
#  parent_item_id  (parent_item_id => items.id)
#

module InsertBefore
  refine Array do
    def insert_before(item, *args)
      index = index(item)
      dup.insert(index, *args)
    end
  end
end

using InsertBefore
class Item < ApplicationRecord
  has_ancestry

  include ActivityLoggable

  belongs_to :location
  belongs_to :group
  has_many :checkouts
  has_many :current_checkouts, -> { where(returned_at: nil) }, class_name: "::Checkout"
  has_one :current_checkout, -> { where(returned_at: nil) }, class_name: "::Checkout"

  has_many_attached :images
  has_rich_text :description

  def self.importable_column_names
    column_names
      .insert_before("group_id", "group_name")
      .insert_before("location_id", "location_name")
      .without("group_id", "location_id")
      .without("created_at", "updated_at", "ancestry")
  end

  def qr_code_as_svg
    RQRCode::QRCode
      .new(qr_code_identifier)
      .as_svg(
        offset: 5,
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 4
      )
  end

  def search_description
    description.to_plain_text.truncate(130)
  end

  def available?
    !current_checkout.present?
  end
end
