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
class Avo::Resources::Item < Avo::BaseResource
  self.includes = [:rich_text_description]

  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: params[:q],
          serial_number_cont: params[:q],
          qr_code_identifier_cont: params[:q],
          m: "or"
        )
        .result(distinct: false)
    end,
    help: -> { "- search by name, serial number, or QR code" },
    item: -> do
      {
        title: record.title,
        description: record.search_description
      }
    end
  }

  def fields
    field :name, as: :text, link_to_record: true
    field :description, as: :trix, always_show: true

    field :location, as: :belongs_to
    field :group, as: :belongs_to
    field :status, as: :badge, options: {success: [:available], danger: [:past_due], warning: [:checked_out]}

    field :parent_id,
      as: :select,
      hide_on: [:show, :index],
      options: -> { Item.pluck(:name, :id) },
      name: "Parent Item",
      include_blank: true

    field :parent, name: "Parent Item", as: :text, hide_on: [:new, :edit] do
      record.parent&.name
    end

    field :serial_number, as: :text
    field :qr_code_identifier, as: :text, show_on: [:new, :edit], html: {
      edit: {
        input: {
          data: {
            controller: "value-stripper",
            value_stripper_replacements_value: ValueStripper.all_replacements.to_json,
            action: "keyup->value-stripper#update paste->value-stripper#update change->value-stripper#update",
            value_stripper_target: "input"
          }
        }
      }
    }
    field :qr_code, as: :external_image, link_to_record: true, hide_on: [:new, :edit] do
      next unless record.qr_code_identifier.present?

      svg = record.qr_code_as_svg
      "data:image/svg+xml;base64,#{Base64.strict_encode64(svg)}"
    end

    field :child_items, as: :number, hide_on: [:new, :edit] do
      record.children.count
    end

    field :images, as: :files

    field :all_activities, as: :has_many, use_resource: Avo::Resources::Activity
    field :checkouts, as: :has_many
  end

  def actions
    action Avo::Actions::ImportItems
  end

  def filters
    filter Avo::Filters::ItemStatusFilter
  end
end
