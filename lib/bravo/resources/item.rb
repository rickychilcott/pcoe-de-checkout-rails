class Bravo::Resources::Item < Bravo::BaseResource
  self.includes = [:rich_text_description, :location, :group]

  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: q,
          serial_number_cont: q,
          qr_code_identifier_cont: q,
          m: "or"
        )
        .result(distinct: false)
    end,
    help: "search by name, serial number, or QR code"
  }

  def fields
    field :name, as: :text, link_to_record: true, sortable: true
    field :description, as: :trix

    field :location, as: :belongs_to, sortable: true
    field :group, as: :belongs_to, sortable: true
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
    field :qr_code_identifier, as: :text, html: {
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
    field :qr_code, as: :external_image, link_to_record: true do
      next unless record.qr_code_identifier.present?

      png = record.qr_code_as_png.to_blob
      base64_encoded = Base64.strict_encode64(png)

      "data:image/png;base64,#{base64_encoded}"
    end

    field :child_items, as: :number, hide_on: [:new, :edit] do
      record.children.count
    end

    field :images, as: :files, accept: "image/*"

    field :all_activities, as: :has_many, use_resource: Bravo::Resources::Activity
    field :checkouts, as: :has_many
  end

  def actions
    action Bravo::Actions::ImportItems
  end

  def filters
    filter Bravo::Filters::ItemStatusFilter
  end
end
