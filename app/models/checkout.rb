# == Schema Information
#
# Table name: checkouts
#
#  id                 :integer          not null, primary key
#  checked_out_at     :datetime
#  expected_return_on :date
#  returned_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  checked_out_by_id  :integer          not null
#  customer_id        :integer          not null
#  item_id            :integer          not null
#  returned_by_id     :integer
#
# Indexes
#
#  index_checkouts_on_checked_out_by_id  (checked_out_by_id)
#  index_checkouts_on_customer_id        (customer_id)
#  index_checkouts_on_item_id            (item_id)
#  index_checkouts_on_returned_by_id     (returned_by_id)
#
# Foreign Keys
#
#  checked_out_by_id  (checked_out_by_id => admin_users.id)
#  customer_id        (customer_id => customers.id)
#  item_id            (item_id => items.id)
#  returned_by_id     (returned_by_id => admin_users.id)
#
class Checkout < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :item
  belongs_to :customer

  belongs_to :checked_out_by, class_name: "AdminUser"
  belongs_to :returned_by, class_name: "AdminUser", optional: true

  validates :checked_out_at, presence: true
  validates :expected_return_on, presence: true
  validates :returned_at, presence: {if: :checked_in?}
  validates :returned_by, presence: {if: :checked_in?}

  default_scope -> { order(expected_return_on: :asc) }
  scope :past_due, -> { checked_out.where(expected_return_on: ...Date.today) }
  scope :due_today, -> { checked_out.where(expected_return_on: Date.today) }
  scope :checked_out, -> { where(returned_at: nil) }
  scope :checked_in, -> { where.not(returned_at: nil) }

  def name
    "#{customer.name} checked out #{item.name}"
  end

  def past_due?
    checked_out? && expected_return_on < Date.today
  end

  def checked_out?
    returned_at.nil?
  end

  def checked_in?
    !checked_out?
  end

  def due_soon?
    checked_out? && (1.day.ago..Time.now).cover?(expected_return_on)
  end

  def expected_return_on_text
    words = time_ago_in_words(expected_return_on)

    if past_due?
      "#{words} ago"
    elsif due_soon?
      "today"
    else
      "in #{words}"
    end
  end
end
