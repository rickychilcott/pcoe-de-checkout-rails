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
  self.includes = [:items, :rich_text_description]

  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: q,
          m: "or"
        )
        .result(distinct: false)
    end,
    item: -> do
      {
        title: record.title,
        description: record.description.to_plain_text.truncate(130)
      }
    end
  }

  def fields
    field :name, as: :text, link_to_record: true
    field :description, as: :trix, always_show: true
    field :item_count, as: :number, readonly: true
    field :items, as: :has_many

    field :admin_users, as: :has_many
  end
end
