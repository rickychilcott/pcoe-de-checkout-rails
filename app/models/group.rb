# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Group < ApplicationRecord
  has_many :items
  has_many :admin_user_groups, dependent: :destroy
  has_many :admin_users, through: :admin_user_groups

  has_rich_text :description
end
