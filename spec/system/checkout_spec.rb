require "rails_helper"

RSpec.describe "Checkout Equipment", type: :system do
  it "via customer", retry: 0 do
    customer = create(:customer, name: "Sally Smith")
    location = create(:location, name: "Main Library")
    group = create(:group, name: "Adults")
    admin_user = create(:admin_user, password: "abcd1234", groups: [group])

    laptop = create(:item, name: "Laptop", location:, group:)
    camera = create(:item, name: "Camera", location:, group:)

    sign_in admin_user
    visit root_path

    within "#search-for-customer" do
      input = find("input")
      input.fill_in with: customer.name

      find(css_id(customer)).click
    end

    expect(page).to have_current_path(customer_path(customer))
    expect(page).to have_content customer.name
    expect(page).to have_content customer.ohio_id
    expect(page).to have_content customer.email

    check("Laptop")
    check("Camera")
    fill_in "Expected Return", with: 3.days.from_now.strftime("%Y-%m-%d")
    click_on "Check Out Items!"

    expect(page).to have_content "2 Items checked out to #{customer.name}"

    expect(customer.checked_out_item_count).to eq(2)
    expect(laptop.reload).not_to be_available
    expect(camera.reload).not_to be_available

    expect(page).to have_content "Laptop"
    expect(page).to have_content "Camera"
    expect(page).to have_content "No Items Available"
  end

  it "via item" do
    _customer = create(:customer, name: "Sally Smith")
    location = create(:location, name: "Main Library")
    group = create(:group, name: "Adults")
    admin_user = create(:admin_user, groups: [group], password: "abcd1234")

    laptop = create(:item, name: "Laptop", location: location, group: group)
    _camera = create(:item, name: "Camera", location: location, group: group)

    sign_in admin_user
    visit root_path

    within "#search-for-item" do
      input = find("input")
      input.fill_in with: laptop.qr_code_identifier

      find(css_id(laptop, :checkout)).click
    end

    expect(page).to have_current_path(new_item_checkout_path(laptop))
    expect(page).to have_content laptop.name

    # TODO - fill in the rest of the test
    # expect(customer.checked_out_item_count).to eq(2)
    # expect(laptop.reload).not_to be_available
    # expect(camera.reload).not_to be_available
  end
end
