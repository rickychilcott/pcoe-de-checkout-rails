class Group < ApplicationRecord
  has_many :items
  has_many :admin_user_groups, dependent: :destroy
  has_many :admin_users, through: :admin_user_groups

  has_rich_text :description
end
