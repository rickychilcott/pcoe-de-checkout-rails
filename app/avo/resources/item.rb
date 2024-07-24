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
class Avo::Resources::Item < Avo::BaseResource
  self.includes = [:rich_text_description]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :trix, always_show: true

    field :location, as: :belongs_to
    field :group, as: :belongs_to

    field :parent_id,
      as: :select,
      hide_on: [:show, :index],
      options: -> { Item.pluck(:name, :id) },
      name: "Parent",
      include_blank: true

    field :parent, as: :text, hide_on: [:new, :edit] do
      record.parent&.name
    end

    field :serial_number, as: :text
    field :qr_code_identifier, as: :text, show_on: [:new, :edit]
    field :qr_code, as: :external_image, link_to_record: true, hide_on: [:new, :edit] do
      svg = record.qr_code_as_svg
      "data:image/svg+xml;base64,#{Base64.strict_encode64(svg)}"
    rescue
      nil
    end

    field :child_items, as: :number, hide_on: [:new, :edit] do
      record.children.count
    end

    field :images, as: :files

    field :activities, as: :has_many
  end

  def actions
    action Avo::Actions::ImportItems
  end
end
