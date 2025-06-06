require "rails_helper"

RSpec.describe Process::Item::Checkout, type: :model do
  it "can checkout" do
    group = create(:group)
    admin_user = create(:admin_user)
    admin_user.groups << group
    admin_user.save!

    customer = create(:customer)
    item = create(:item, group:)

    checkout = described_class.run!(item:, customer:, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)

    expect(Checkout.count).to eq(1)
    expect(checkout).to be_checked_out
    expect(checkout.item).to eq(item)
    expect(checkout.customer).to eq(customer)
    expect(checkout.expected_return_on).to eq(3.days.from_now.to_date)

    expect(Activity.count).to eq(1)
    activity = Activity.first
    expect(activity.actor).to eq(customer)
    expect(activity.facilitator).to eq(admin_user)
    expect(activity.action).to eq("item_checked_out")
    expect(activity.records).to include(item)
  end

  it "returns the existing checkout if it exists" do
    group = create(:group)
    admin_user = create(:admin_user)
    admin_user.groups << group
    admin_user.save!

    customer = create(:customer)
    item = create(:item, group:)

    new_checkout = described_class.run!(item:, customer:, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)
    expect(Activity.count).to eq(1)

    existing_checkout = described_class.run!(item:, customer:, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)

    expect(existing_checkout).to eq(new_checkout)
    expect(Activity.count).to eq(1)
  end
end
