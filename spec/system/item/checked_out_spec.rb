require "rails_helper"

RSpec.describe "Checked Out", type: :system do
  it "shows checked out (include past)" do
    travel_to 5.days.ago

    group = FactoryBot.create(:group)
    admin_user = FactoryBot.create(:admin_user)
    admin_user.groups << group
    admin_user.save!

    customer_1 = FactoryBot.create(:customer)
    checked_out_due_now = FactoryBot.create(:item, group:)

    Item::Checkout.run!(item: checked_out_due_now, customer: customer_1, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)

    customer_2 = FactoryBot.create(:customer)
    checked_in = FactoryBot.create(:item, group:)
    checkout = Item::Checkout.run!(item: checked_in, customer: customer_2, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)
    Item::Checkin.run!(item: checked_in, checkout:, returned_by: admin_user)

    customer_3 = FactoryBot.create(:customer)
    checked_out_due_later = FactoryBot.create(:item, group:)
    Item::Checkout.run!(item: checked_out_due_later, customer: customer_3, expected_return_on: 1.month.from_now.to_date, checked_out_by: admin_user)

    travel_back

    sign_in admin_user

    visit avo.resources_items_path
    click_on "Current Checkouts"

    expect(page).to have_content "Current Checkouts"

    expect(page).to have_content checked_out_due_now.name
    expect(page).to have_content customer_1.name

    expect(page).not_to have_content checked_in.name
    expect(page).not_to have_content customer_2.name

    expect(page).to have_content checked_out_due_later.name
    expect(page).to have_content customer_3.name
  end
end
