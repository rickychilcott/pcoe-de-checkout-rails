# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  pid        :string
#  role       :string           default("student"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
# Indexes
#
#  index_customers_on_ohio_id  (ohio_id) UNIQUE
#  index_customers_on_pid      (pid) UNIQUE
#
class Customer < ApplicationRecord
  extend Enumerize
  include ActivityLoggable

  PID_REGEX = /\AP\d{9}\z/
  def self.pid_regex = PID_REGEX

  validates :name, presence: true
  validates :ohio_id, presence: true, uniqueness: true
  validates :pid, presence: {if: :student?}, uniqueness: {if: :pid?}, format: {with: PID_REGEX, if: :pid?, message: "must be a valid PID (i.e. P123456789)"}

  has_many :reservations
  has_many :checkouts
  has_many :current_checkouts, -> { checked_out }, class_name: "Checkout"
  has_many :acted_activities, foreign_key: :actor_id, dependent: :nullify, class_name: "Activity"
  normalizes :pid, with: ->(value) { value.presence&.upcase&.strip }

  has_rich_text :notes

  enumerize :role, in: [:student, :faculty_staff], default: :student, predicates: true

  def all_activities
    acted_activities.or(activities)
  end

  def self.importable_column_names
    column_names.without("id", "created_at", "updated_at")
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[name ohio_id]
  end

  def checked_out_item_count
    current_checkouts.count(&:checked_out?)
  end

  def past_due_item_count
    current_checkouts.count(&:past_due?)
  end

  def title
    "#{name} (#{ohio_id})"
  end

  def email = "#{ohio_id}@ohio.edu"

  def pid? = pid.present?

  def self.as_tags
    order(name: :asc).map { |customer| {value: customer.id, label: customer.name} }
  end
end
