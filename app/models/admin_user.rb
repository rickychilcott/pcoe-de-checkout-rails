class AdminUser < ApplicationRecord
  devise(
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :validatable,
    :trackable,
    :timeoutable
  )

  has_many :admin_user_groups, dependent: :destroy
  has_many :groups, through: :admin_user_groups
end
