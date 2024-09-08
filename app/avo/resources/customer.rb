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
  self.includes = [:rich_text_notes, :current_checkouts]
  # self.attachments = []

  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: params[:q],
          ohio_id_cont: params[:q],
          m: "or"
        )
        .result(distinct: false)
    end,
    item: -> do
            {
              title: "#{record.name} [#{record.ohio_id}]",
              description: record.notes.to_plain_text.truncate(130)
              # image_url: main_app.url_for(record.cover_photo),
              # image_format: :rounded
            }
          end
  }

  def fields
    field :name, as: :text
    field :ohio_id, as: :text

    field :checked_out_item_count, as: :number, readonly: true
    field :past_due_item_count, as: :number, readonly: true

    field :notes, as: :trix, always_show: true
  end
end
