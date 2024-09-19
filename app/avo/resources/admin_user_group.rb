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
class Avo::Resources::AdminUserGroup < Avo::BaseResource
  # self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.visible_on_sidebar = false

  def fields
    field :admin_user, as: :belongs_to
    field :group, as: :belongs_to
  end
end
