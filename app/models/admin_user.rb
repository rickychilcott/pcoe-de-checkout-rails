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
class AdminUser < ApplicationRecord
  devise(
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :validatable,
    :trackable,
    :timeoutable
  )

  has_many :admin_groups, dependent: :destroy, class_name: "AdminUserGroup"
  has_many :groups, through: :admin_groups
  has_many :facilitated_activities, foreign_key: :facilitator_id, dependent: :nullify, class_name: "Activity"

  def title = "#{record.name} [#{record.email}]"

  # override Devise's password_required? method
  def password_required? = new_record? || changing_password?

  def changing_password? = password.present? || password_confirmation.present?

  def all_activities
    facilitated_activities
  end
end
