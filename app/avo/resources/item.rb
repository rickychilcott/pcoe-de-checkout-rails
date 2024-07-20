class Avo::Resources::Item < Avo::BaseResource
  self.includes = [:parent_item, :rich_text_description]
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
    field :parent_item, as: :belongs_to

    field :serial_number, as: :text
    field :qr_code_identifier, as: :text, show_on: [:new, :edit]
    field :qr_code, as: :external_image, link_to_record: true, hide_on: [:new, :edit] do
      svg = record.qr_code_as_svg
      "data:image/svg+xml;base64,#{Base64.strict_encode64(svg)}"
    rescue
      nil
    end

    field :images, as: :files
  end
end
