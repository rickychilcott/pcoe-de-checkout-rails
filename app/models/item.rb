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
#
# Indexes
#
#  index_items_on_ancestry     (ancestry)
#  index_items_on_group_id     (group_id)
#  index_items_on_location_id  (location_id)
#
# Foreign Keys
#
#  group_id     (group_id => groups.id)
#  location_id  (location_id => locations.id)
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
  has_many :current_checkouts, -> { checked_out }, class_name: "Checkout"
  has_one :current_checkout, -> { checked_out }, class_name: "Checkout"

  scope :not_checked_out, -> { where.not(id: Checkout.checked_out.select(:item_id)) }
  scope :checked_out, -> { where(id: Checkout.checked_out.select(:item_id)) }

  has_many_attached :images
  has_rich_text :description

  def all_activities
    activities
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[name serial_number qr_code_identifier]
  end

  def self.importable_column_names
    column_names
      .insert_before("group_id", "group_name")
      .insert_before("location_id", "location_name")
      .insert_before("ancestry", "parent_item_id")
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

  def name_with_identifiers
    qr_code_identifier_text = "(#{qr_code_identifier})" if qr_code_identifier.present?
    serial_number_text = "[#{serial_number}]" if serial_number.present?

    [name, qr_code_identifier_text, serial_number_text].compact.join(" ".freeze)
  end

  def status
    return :available unless current_checkout.present?
    return :past_due if current_checkout.past_due?

    :checked_out
  end

  def search_description
    description.to_plain_text.truncate(130)
  end

  def available?
    !current_checkout.present?
  end

  def self.available_as_tags
    Item.with_attached_images.not_checked_out.map do |item|
      {
        value: item.id,
        label: item.name_with_identifiers,
        avatar: item.images.first&.url
      }
    end
  end

  def self.not_available_as_tags
    Item.with_attached_images.checked_out.map do |item|
      {
        value: item.id,
        label: item.name_with_identifiers,
        avatar: item.images.first&.url
      }
    end
  end
end
