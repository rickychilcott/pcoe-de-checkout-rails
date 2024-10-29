require "rails_helper"

RSpec.describe "Checkout Equipment", type: :system do
  it "via customer" do
    admin_user = FactoryBot.create(:admin_user, password: "abcd1234")
    customer = FactoryBot.create(:customer, name: "Sally Smith")
    location = FactoryBot.create(:location, name: "Main Library")
    group = FactoryBot.create(:group, name: "Adults")

    laptop = FactoryBot.create(:item, name: "Laptop", location: location, group: group)
    camera = FactoryBot.create(:item, name: "Camera", location: location, group: group)

    sign_in admin_user
    visit root_path

    within "#search-for-customer" do
      input = find("input")
      input.fill_in with: customer.name

      find(css_id(customer)).click
    end

    expect(page).to have_current_path(customer_path(customer))
    expect(page).to have_content customer.name

    expect(customer.checked_out_item_count).to eq(2)
    expect(laptop.reload).not_to be_available
    expect(camera.reload).not_to be_available
  end

  it "via item" do
    admin_user = FactoryBot.create(:admin_user, password: "abcd1234")
    customer = FactoryBot.create(:customer, name: "Sally Smith")
    location = FactoryBot.create(:location, name: "Main Library")
    group = FactoryBot.create(:group, name: "Adults")

    laptop = FactoryBot.create(:item, name: "Laptop", location: location, group: group)
    camera = FactoryBot.create(:item, name: "Camera", location: location, group: group)

    sign_in admin_user
    visit root_path

    within "#search-for-item" do
      input = find("input")
      input.fill_in with: laptop.qr_code_identifier

      find(css_id(laptop)).click
    end

    expect(page).to have_current_path(item_path(laptop))
    expect(page).to have_content laptop.name

    expect(customer.checked_out_item_count).to eq(2)
    expect(laptop.reload).not_to be_available
    expect(camera.reload).not_to be_available
  end
end
