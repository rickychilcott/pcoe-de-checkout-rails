require "rails_helper"

RSpec.describe "Return Equipment", type: :system do
  it "via customer" do
    customer = create(:customer, name: "Sally Smith")
    location = create(:location, name: "Main Library")
    group = create(:group, name: "Adults")
    admin_user = create(:admin_user, password: "abcd1234", groups: [group])

    laptop = create(:item, name: "Laptop", location:, group:)
    camera = create(:item, name: "Camera", location:, group:)

    Process::ItemGroup::Checkout.run!(
      items: [laptop, camera],
      customer:,
      checked_out_by: admin_user,
      expected_return_on: 2.day.ago.to_date
    )

    expect(customer.checked_out_item_count).to eq(2)
    expect(laptop).not_to be_available
    expect(camera).not_to be_available

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

    within "#past-due-items-list-returnable-checkouts" do
      check_item(/Laptop/)

      accept_confirm do
        click_on "Return Items!"
      end
    end

    expect(customer.reload.checked_out_item_count).to eq(1)
    expect(laptop.reload).to be_available
    expect(camera.reload).not_to be_available

    expect(page).to have_content "1 Item returned for #{customer.name}"
    expect(page).to have_content "Camera"
    expect(page).to have_content "Laptop"
  end

  it "via item" do
    group = create(:group, name: "Adults")
    location = create(:location, name: "Main Library")
    customer = create(:customer, name: "Sally Smith")
    admin_user = create(:admin_user, groups: [group])

    laptop = create(:item, name: "Laptop", location:, group:)
    _camera = create(:item, name: "Camera", location:, group:)

    Process::ItemGroup::Checkout.run!(
      items: [laptop],
      customer:,
      checked_out_by: admin_user,
      expected_return_on: 2.day.ago.to_date
    )

    sign_in admin_user
    visit root_path

    within "#search-for-item" do
      input = find("input")
      input.fill_in with: laptop.qr_code_identifier

      find(css_id(laptop, :return)).click
    end

    expect(page).to have_current_path(item_path(laptop))
    expect(page).to have_content laptop.name
    expect(page).to have_content "Item is checked out"

    expect(page).to have_content "Return Item!"

    accept_confirm do
      click_on "Return Item!"
    end

    expect(page).to have_content "1 Item returned for #{customer.name}"
    # expect(laptop.reload).to be_available
  end

  private

  def check_item(name)
    find("li.list-group-item", text: name)
      .find("input[type='checkbox']")
      .set(true)
  end
end
