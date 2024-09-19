require "rails_helper"

RSpec.describe Item::Process::Checkout, type: :model do
  it "can checkout" do
    group = FactoryBot.create(:group)
    admin_user = FactoryBot.create(:admin_user)
    admin_user.groups << group
    admin_user.save!

    customer = FactoryBot.create(:customer)
    item = FactoryBot.create(:item, group:)

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
    expect(activity.record).to eq(item)
  end
end
