require "rails_helper"

RSpec.describe "Checkout Equipment", type: :system do
  it "via customer" do
    admin_user = create(:admin_user, password: "abcd1234")
    customer = create(:customer, name: "Sally Smith")
    location = create(:location, name: "Main Library")
    group = create(:group, name: "Adults")

    laptop = create(:item, name: "Laptop", location: location, group: group)
    camera = create(:item, name: "Camera", location: location, group: group)

    Process::Item::Checkout.run!(
      item: laptop,
      customer:,
      checked_out_by: admin_user,
      expected_return_on: 1.week.from_now.to_date
    )

    Process::Item::Checkout.run!(
      item: camera,
      customer:,
      checked_out_by: admin_user,
      checked_out_at: 1.week.ago.to_s,
      expected_return_on: 1.day.ago.to_date
    )

    expect(customer.checked_out_item_count).to eq(2)

    sign_in admin_user
    visit root_path

    within "#search-for-customer" do
      input = find("input")
      input.fill_in with: customer.name

      find(css_id(customer)).click
    end

    expect(page).to have_current_path(customer_path(customer))
    expect(page).to have_content customer.name
  end

  it "sends a reminder" do
    expect(AdminUser.count).to eq(0)
    expect(Customer.count).to eq(0)
    expect(Location.count).to eq(0)
    expect(Group.count).to eq(0)
    expect(Item.count).to eq(0)
    admin_user = create(:admin_user)
    customer = create(:customer, name: "Sally Smith")
    location = create(:location, name: "Main Library")
    group = create(:group, name: "Adults")

    laptop = create(:item, name: "Laptop", location: location, group: group)

    Process::Item::Checkout.run!(
      item: laptop,
      customer:,
      checked_out_by: admin_user,
      expected_return_on: 1.week.ago.to_date
    )

    sign_in admin_user
    visit root_path

    expect(page).to have_content("Search for Customer")
    find(css_id(customer, :remind)).click
    click_on "Send Reminder"

    expect(page).to have_content("Reminder was sent to #{customer.name}.")
  end

  it "allows an admin to add a customer" do
    admin_user = create(:admin_user)

    sign_in admin_user
    visit new_customer_path

    customer = build(:customer, name: "Sally Smith", role: :student)
    fill_in "Name", with: customer.name
    fill_in "Ohio ID", with: customer.ohio_id
    fill_in "PID", with: customer.pid
    click_on "Create Customer"

    expect(page).to have_content(customer.name)
    expect(page).to have_content(customer.ohio_id)
    expect(page).to have_content(customer.role_text)
    expect(page).not_to have_content(customer.pid)

    expect(Customer.count).to eq(1)
    expect(Customer.first.name).to eq(customer.name)
    expect(Customer.first.ohio_id).to eq(customer.ohio_id)
    expect(Customer.first.pid).to eq(customer.pid)
    expect(Customer.first.role).to eq(customer.role)
  end
end
