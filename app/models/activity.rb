# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  action         :string           not null
#  extra          :json             not null
#  occurred_at    :datetime         not null
#  record_gids    :json             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  actor_id       :integer
#  facilitator_id :integer          not null
#
# Indexes
#
#  index_activities_on_action          (action)
#  index_activities_on_actor_id        (actor_id)
#  index_activities_on_facilitator_id  (facilitator_id)
#  index_activities_on_record_gids     (record_gids)
#
# Foreign Keys
#
#  actor_id        (actor_id => customers.id)
#  facilitator_id  (facilitator_id => admin_users.id)
#
class Activity < ApplicationRecord
  belongs_to :actor, class_name: "Customer", optional: true
  belongs_to :facilitator, class_name: "AdminUser"

  SUPPORTED_ACTIONS = %w[
    item_added
    item_deleted
    item_viewed
    item_bulk_import
    item_checked_out
    item_checked_in

    item_group_checked_out

    customer_bulk_import
    customer_reminder_sent
  ].freeze

  def self.supported_actions = SUPPORTED_ACTIONS

  validates :action, inclusion: {
    in: supported_actions,
    message: "%{value} is not a valid action. Must be one of: #{supported_actions.join(", ")}"
  }
  validates :record_gids, length: {minimum: 1}
  validates :occurred_at, presence: true

  def records
    GlobalID::Locator
      .locate_many(record_gids)
      .compact
  end

  def records=(records)
    self.record_gids =
      records
        .map { _1.to_global_id.to_s }
  end

  def record
    records.first
  end

  def record=(value)
    self.records = [value]
  end
end
