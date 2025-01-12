# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  super_admin            :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class Avo::Resources::AdminUser < Avo::BaseResource
  # self.includes = []
  self.search = {
    query: -> do
      query
        .ransack(
          name_cont: params[:q],
          email_cont: params[:q],
          m: "or"
        )
        .result(distinct: false)
    end,
    item: -> do
            {
              title: "#{record.name} [#{record.email}]"
              # description: ActionView::Base.full_sanitizer.sanitize(record.body).truncate(130),
              # image_url: main_app.url_for(record.cover_photo),
              # image_format: :rounded
            }
          end
  }

  def fields
    field :name, as: :text, link_to_record: true
    field :email, as: :text
    field :super_admin, as: :boolean, visibility: {edit: -> { context[:user].super_admin? }}

    field :password, as: :password, required: false

    field :sign_in_count, as: :number, readonly: true
    field :current_sign_in_at, as: :date_time, readonly: true
    field :last_sign_in_at, as: :date_time, readonly: true
    field :current_sign_in_ip, as: :text, readonly: true
    field :last_sign_in_ip, as: :text, readonly: true

    field :admin_groups, as: :has_many, description: "The groups this admin can add, checkout items, and manage."
  end
end
