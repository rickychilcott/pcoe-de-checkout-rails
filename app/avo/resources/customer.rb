# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
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
