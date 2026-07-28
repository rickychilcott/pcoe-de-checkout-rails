class Bravo::Resources::AdminUser < Bravo::BaseResource
  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: q,
          email_cont: q,
          m: "or"
        )
        .result(distinct: false)
    end
  }

  def fields
    field :name, as: :text, link_to_record: true, sortable: true, required: true
    field :email, as: :text, sortable: true, required: true
    field :super_admin, as: :boolean,
      visible: ->(view) { view.in?([:index, :show]) || current_admin_user.super_admin? }

    field :password, as: :password
    field :password_confirmation, as: :password

    field :group_ids, as: :checkboxes, name: "Groups",
      options: -> { Group.order(:name).pluck(:name, :id) },
      visible: -> { current_admin_user.super_admin? },
      description: "The groups this admin can add, checkout items, and manage."

    field :sign_in_count, as: :number, readonly: true, hide_on: [:index]
    field :current_sign_in_at, as: :date_time, readonly: true, hide_on: [:index]
    field :last_sign_in_at, as: :date_time, readonly: true, hide_on: [:index]
    field :current_sign_in_ip, as: :text, readonly: true, hide_on: [:index]
    field :last_sign_in_ip, as: :text, readonly: true, hide_on: [:index]

    field :groups, as: :has_many, description: "The groups this admin can add, checkout items, and manage."
    field :all_activities, as: :has_many, description: "The activities this admin has facilitated.", use_resource: Bravo::Resources::Activity
  end

  # Devise: leave the password alone unless one was typed
  def prepare_params(attrs)
    return attrs if attrs[:password].present?

    attrs.except(:password, :password_confirmation)
  end
end
