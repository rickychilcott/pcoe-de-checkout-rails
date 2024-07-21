class Avo::Resources::Customer < Avo::BaseResource
  self.includes = [:rich_text_notes]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id

    field :name, as: :text
    field :ohio_id, as: :text

    field :notes, as: :trix, always_show: true
  end
end
