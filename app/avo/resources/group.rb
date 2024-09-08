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
  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: params[:q],
          m: "or"
        )
        .result(distinct: false)
    end,
    item: -> do
      {
        title: record.name,
        description: record.description.to_plain_text.truncate(130)
      }
    end
  }

  def fields
    field :name, as: :text
    field :description, as: :trix, always_show: true
    field :items, as: :has_many

    field :admin_users, as: :has_many
  end
end
