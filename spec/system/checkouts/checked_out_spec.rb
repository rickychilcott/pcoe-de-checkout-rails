require "rails_helper"

RSpec.describe "Checked Out", type: :system do
  it "shows checked out (include past)" do
    travel_to 5.days.ago

    group = create(:group)
    admin_user = create(:admin_user)
    admin_user.groups << group
    admin_user.save!

    customer_1 = create(:customer)
    checked_out_due_now = create(:item, group:)

    Process::Item::Checkout.run!(item: checked_out_due_now, customer: customer_1, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)

    customer_2 = create(:customer)
    checked_in = create(:item, group:)
    checkout = Process::Item::Checkout.run!(item: checked_in, customer: customer_2, expected_return_on: 3.days.from_now.to_date, checked_out_by: admin_user)
    Process::Item::Checkin.run!(item: checked_in, checkout:, returned_by: admin_user)

    customer_3 = create(:customer)
    checked_out_due_later = create(:item, group:)
    Process::Item::Checkout.run!(item: checked_out_due_later, customer: customer_3, expected_return_on: 1.month.from_now.to_date, checked_out_by: admin_user)

    travel_back

    sign_in admin_user

    visit avo.resources_items_path
    click_on "Checkouts"
    expect(page).to have_content "Checkouts"

    open_resource_filters
    select_filter_option("Checkout status", "current")
    expect_applied_filters_count(1)

    expect(page).to have_content checked_out_due_now.name
    expect(page).to have_content customer_1.name

    expect(page).not_to have_content checked_in.name
    expect(page).not_to have_content customer_2.name

    expect(page).to have_content checked_out_due_later.name
    expect(page).to have_content customer_3.name

    open_resource_filters
    select_filter_option("Checkout status", "past_due")
    expect_applied_filters_count(1)
    expect(page).to have_content checked_out_due_now.name
    expect(page).to have_content customer_1.name

    expect(page).not_to have_content checked_in.name
    expect(page).not_to have_content customer_2.name

    expect(page).not_to have_content checked_out_due_later.name
    expect(page).not_to have_content customer_3.name

    open_resource_filters
    select_filter_option("Checkout status", "completed")
    expect_applied_filters_count(1)
    expect(page).not_to have_content checked_out_due_now.name
    expect(page).not_to have_content customer_1.name

    expect(page).to have_content checked_in.name
    expect(page).to have_content customer_2.name

    expect(page).not_to have_content checked_out_due_later.name
    expect(page).not_to have_content customer_3.name
  end
end
