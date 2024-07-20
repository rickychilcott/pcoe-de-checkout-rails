class Avo::Resources::Location < Avo::BaseResource
  self.includes = [:rich_text_description]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :idlo

    field :name, as: :text
    field :description, as: :trix, always_show: true

    field :items, as: :has_many
  end
end
