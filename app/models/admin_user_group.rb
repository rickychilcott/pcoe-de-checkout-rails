# == Schema Information
#
# Table name: admin_user_groups
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_user_id :integer          not null
#  group_id      :integer          not null
#
# Indexes
#
#  index_admin_user_groups_on_admin_user_id  (admin_user_id)
#  index_admin_user_groups_on_group_id       (group_id)
#
# Foreign Keys
#
#  admin_user_id  (admin_user_id => admin_users.id)
#  group_id       (group_id => groups.id)
#
class AdminUserGroup < ApplicationRecord
  belongs_to :admin_user
  belongs_to :group
end
