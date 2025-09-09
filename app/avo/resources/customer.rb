# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  pid        :string
#  role       :string           default("student"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
# Indexes
#
#  index_customers_on_ohio_id  (ohio_id) UNIQUE
#  index_customers_on_pid      (pid) UNIQUE
#
class Avo::Resources::Customer < Avo::BaseResource
  self.includes = [:rich_text_notes, :current_checkouts]

  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: q,
          ohio_id_cont: q,
          m: "or"
        )
        .result(distinct: false)
    end,
    item: -> do
      {
        title: record.title,
        description: record.notes.to_plain_text.truncate(130)
        # image_url: main_app.url_for(record.cover_photo),
        # image_format: :rounded
      }
    end
  }

  def actions
    action Avo::Actions::ImportCustomers
  end

  def fields
    field :name, as: :text, link_to_record: true, sortable: true
    field :role, as: :select,
      options: Customer.role.options,
      default: Customer.role.default_value,
      required: true,
      placeholder: "Select a role",
      sortable: true

    field :ohio_id, as: :text, copyable: true, sortable: true
    field :email, as: :text, copyable: true, as_html: true do
      link_to record.email, "mailto:#{record.email}"
    end
    field :pid, as: :text, placeholder: "P123456789", copyable: true, visible: -> { authorize current_admin_user, Customer, :show_pid?, raise_exception: false }, sortable: true
    field :checked_out_item_count, as: :number, readonly: true
    field :past_due_item_count, as: :number, readonly: true

    field :notes, as: :trix, always_show: true

    field :checkouts, as: :has_many

    field :all_activities, as: :has_many, use_resource: Avo::Resources::Activity
  end
end
