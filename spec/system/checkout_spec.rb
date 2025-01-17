require "rails_helper"

RSpec.describe "Checkout Equipment", type: :system do
  xit "via customer" do
    admin_user = create(:admin_user, password: "abcd1234")
    customer = create(:customer, name: "Sally Smith")
    location = create(:location, name: "Main Library")
    group = create(:group, name: "Adults")

    laptop = create(:item, name: "Laptop", location: location, group: group)
    camera = create(:item, name: "Camera", location: location, group: group)

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

    check "Laptop"
    check "Camera"
    fill_in "Expected Return", with: 3.days.from_now.strftime("%m/%d/%Y")

    accept_confirm do
      click_on "Check Out Items!"
    end

    expect(customer.checked_out_item_count).to eq(2)
    expect(laptop.reload).not_to be_available
    expect(camera.reload).not_to be_available
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
