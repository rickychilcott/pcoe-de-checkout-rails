# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  action         :string           not null
#  extra          :json             not null
#  occurred_at    :datetime         not null
#  record_type    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  actor_id       :integer
#  facilitator_id :integer          not null
#  record_id      :integer
#
# Indexes
#
#  index_activities_on_action          (action)
#  index_activities_on_actor_id        (actor_id)
#  index_activities_on_facilitator_id  (facilitator_id)
#  index_activities_on_record          (record_type,record_id)
#
# Foreign Keys
#
#  actor_id        (actor_id => customers.id)
#  facilitator_id  (facilitator_id => admin_users.id)
#
class Activity < ApplicationRecord
  belongs_to :actor, class_name: "Customer", optional: true
  belongs_to :facilitator, class_name: "AdminUser"
  belongs_to :record, polymorphic: true

  SUPPORTED_ACTIONS = %w[
    item_added
    item_deleted
    item_viewed
    item_bulk_import
    item_checked_out
    item_checked_in
  ].freeze

  validates :action, inclusion: {
    in: SUPPORTED_ACTIONS,
    message: "%{value} is not a valid action"
  }
end
