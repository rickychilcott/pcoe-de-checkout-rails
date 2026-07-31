require "rails_helper"

RSpec.describe "Bravo Item creation with images", type: :system do
  it "uploads images through the new item form" do
    sign_in create(:admin_user, :super_admin)
    location = create(:location)
    group = create(:group)

    visit "/admin/resources/items/new"

    find("input[name='item[name]']").fill_in with: "Camcorder"
    find("select[name='item[location_id]'] option[value='#{location.id}']").select_option
    find("select[name='item[group_id]'] option[value='#{group.id}']").select_option
    find("input[type='file']").attach_file(Rails.root.join("spec/fixtures/files/image.jpeg"))

    click_on "Save"

    expect(page).to have_content "Camcorder"
    expect(Item.find_by!(name: "Camcorder").images.count).to eq(1)
  end
end
