# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
# Indexes
#
#  index_customers_on_ohio_id  (ohio_id) UNIQUE
#
class Customer < ApplicationRecord
  include ActivityLoggable

  validates :name, presence: true
  validates :ohio_id, presence: true, uniqueness: true
  has_many :checkouts
  has_many :current_checkouts, -> { checked_out }, class_name: "Checkout"

  has_rich_text :notes

  def self.ransackable_attributes(auth_object = nil)
    super + %w[name ohio_id]
  end

  def checked_out_item_count
    current_checkouts.count(&:checked_out?)
  end

  def past_due_item_count
    current_checkouts.count(&:past_due?)
  end

  def email = "#{ohio_id}@ohio.edu"

  def self.as_tags
    order(name: :asc).map { |customer| {value: customer.id, label: customer.name} }
  end
end
