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
require "rails_helper"

RSpec.describe Checkout, type: :model do
  it "has a valid factory" do
    expect(build(:checkout)).to be_valid
  end

  it "is past due if it is checked out and the expected return date is in the past" do
    travel_to DateTime.now.middle_of_day do
      checkout = create(:checkout, checked_out_at: 2.days.ago, expected_return_on: 1.day.ago)

      expect(checkout).to be_past_due
      expect(checkout).to be_checked_out
      expect(Checkout.past_due).to include(checkout)
      expect(Checkout.checked_out).to include(checkout)
    end
  end

  it "is not past due if it is checked out and the expected return date is today" do
    checkout = create(:checkout, checked_out_at: 2.days.ago, expected_return_on: Date.today)

    expect(checkout).not_to be_past_due
    expect(checkout).to be_checked_out
    expect(Checkout.past_due).not_to include(checkout)
    expect(Checkout.checked_out).to include(checkout)
  end
end
