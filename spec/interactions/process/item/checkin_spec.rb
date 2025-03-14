require "rails_helper"

RSpec.describe Process::Item::Checkin, type: :model do
  it "can checkin" do
    group = create(:group)
    customer = create(:customer)
    item = create(:item, group:)
    admin_user = create(:admin_user, groups: [group])

    checkout = Process::Item::Checkout.run!(item:, customer:, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)
    described_class.run!(checkout:, returned_by: admin_user)

    expect(Checkout.count).to eq(1)
    expect(checkout).to be_checked_in
    expect(checkout.item).to eq(item)
    expect(checkout.customer).to eq(customer)
    expect(checkout.expected_return_on).to eq(3.days.from_now.to_date)

    expect(Activity.count).to eq(2)
    expect(Activity.exists?(action: "item_checked_out")).to be_truthy

    activity = Activity.find_by(action: "item_returned")
    expect(activity.actor).to eq(customer)
    expect(activity.facilitator).to eq(admin_user)
    expect(activity.records).to include(item)
  end
end
