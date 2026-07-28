class Bravo::Resources::Customer < Bravo::BaseResource
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
    end
  }

  def actions
    action Bravo::Actions::ImportCustomers
  end

  def fields
    field :name, as: :text, link_to_record: true, sortable: true
    field :role, as: :select,
      options: Customer.role_options,
      default: "student",
      required: true,
      placeholder: "Select a role",
      sortable: true

    field :ohio_id, as: :text, copyable: true, sortable: true
    field :email, as: :text, copyable: true do
      link_to record.email, "mailto:#{record.email}"
    end
    field :pid, as: :text, placeholder: "P123456789", copyable: true, sortable: true,
      visible: -> { policy(Customer).show_pid? }
    field :checked_out_item_count, as: :number, readonly: true
    field :past_due_item_count, as: :number, readonly: true

    field :notes, as: :trix

    field :checkouts, as: :has_many

    field :all_activities, as: :has_many, use_resource: Bravo::Resources::Activity
  end
end
