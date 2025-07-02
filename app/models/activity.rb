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

  default_scope -> { order(occurred_at: :desc) }

  scope :matching_record_gid, ->(gid) {
    activities_table = Activity.arel_table

    Activity.where(
      Arel::Nodes::NamedFunction.new(
        "json_extract",
        [
          activities_table[:record_gids],
          Arel.sql("'$'")
        ]
      ).matches("%#{gid}%")
    )
  }

  SUPPORTED_ACTIONS_WITH_LABELS = {
    "item_added" => "Item Added",
    "item_deleted" => "Item Deleted",
    "item_viewed" => "Item Viewed",
    "item_bulk_import" => "Item Bulk Imported",
    "item_checked_out" => "Item Checked Out",
    "item_returned" => "Item Returned",

    "item_group_checked_out" => "Items Checked Out",
    "checkouts_returned" => "Items Returned",

    "customer_bulk_import" => "Customer Bulk Imported",
    "customer_reminder_sent" => "Customer Reminder Sent"
  }.freeze

  SUPPORTED_ACTIONS = SUPPORTED_ACTIONS_WITH_LABELS.keys.freeze

  def self.label_for_action(action)
    SUPPORTED_ACTIONS_WITH_LABELS[action.to_sym] || action.to_s.humanize
  end

  def self.supported_actions = SUPPORTED_ACTIONS

  validates :action, inclusion: {
    in: supported_actions,
    message: "%{value} is not a valid action. Must be one of: #{supported_actions.to_sentence(two_words_connector: " or ", last_word_connector: " or ")}"
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

  def occurred_on
    occurred_at.to_date
  end
end
