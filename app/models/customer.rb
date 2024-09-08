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
class Customer < ApplicationRecord
  validates :name, presence: true
  validates :ohio_id, presence: true
  has_many :checkouts
  has_many :current_checkouts, -> { checked_out }, class_name: "Checkout"

  has_rich_text :notes

  def checked_out_item_count
    current_checkouts.count(&:checked_out?)
  end

  def past_due_item_count
    current_checkouts.count(&:past_due?)
  end

  def email = "#{ohio_id}@ohio.edu"
end
