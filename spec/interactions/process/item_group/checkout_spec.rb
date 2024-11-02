require "rails_helper"

RSpec.describe Process::ItemGroup::Checkout, type: :model do
  fit "can checkout" do
    group = create(:group)
    admin_user = create(:admin_user)
    admin_user.groups << group
    admin_user.save!

    customer = create(:customer)
    item = create(:item, group:)
    item2 = create(:item, group:)

    checkouts = described_class.run!(items: [item, item2], customer:, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)

    # Checkouts
    expect(Checkout.count).to eq(2)
    expect(checkouts.size).to eq(2)
    checkouts.each do |checkout|
      expect(checkout).to be_checked_out
      expect(checkout.customer).to eq(customer)
      expect(checkout.expected_return_on).to eq(3.days.from_now.to_date)
    end
    checkout_items = checkouts.map(&:item)
    expect(checkout_items).to match_array([item, item2])

    # item_checked_out activities
    expect(Activity.count).to eq(3)
    activities = Activity.where(action: "item_checked_out")
    activities.each do |activity|
      expect(activity.actor).to eq(customer)
      expect(activity.facilitator).to eq(admin_user)
    end

    records = activities.flat_map(&:records)
    expect(records.size).to eq(2)
    expect(records).to match_array([item, item2])

    # item_group_checked_out activity
    group_activity = Activity.find_by(action: "item_group_checked_out")
    expect(group_activity.actor).to eq(customer)
    expect(group_activity.facilitator).to eq(admin_user)
    expect(group_activity.records).to match_array([item, item2])
  end
end
