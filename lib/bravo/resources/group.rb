class Bravo::Resources::Group < Bravo::BaseResource
  self.includes = [:rich_text_description]

  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: q,
          m: "or"
        )
        .result(distinct: false)
    end
  }

  def fields
    field :name, as: :text, link_to_record: true, sortable: true
    field :description, as: :trix
    field :item_count, as: :number, readonly: true
    field :items, as: :has_many

    field :admin_users, as: :has_many
  end
end
