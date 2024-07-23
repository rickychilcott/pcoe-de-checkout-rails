# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Avo::Resources::Group < Avo::BaseResource
  self.includes = [:rich_text_description]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :trix, always_show: true
    field :items, as: :has_many

    field :admin_users, as: :has_many
  end
end
