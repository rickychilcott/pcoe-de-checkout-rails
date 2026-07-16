require "rails_helper"

RSpec.describe "Bravo Location CRUD", type: :system do
  it "creates and edits a location through the admin UI" do
    admin_user = create(:admin_user, :super_admin, password: "abcd1234")
    sign_in admin_user

    visit "/admin/resources/locations/new"

    find("input[name='location[name]']").fill_in with: "Media Annex"
    click_on "Save"

    expect(page).to have_content "Media Annex"
    location = Location.find_by!(name: "Media Annex")

    visit "/admin/resources/locations/#{location.id}/edit"
    find("input[name='location[name]']").fill_in with: "Media Annex Renamed"
    click_on "Save"

    expect(page).to have_content "Media Annex Renamed"
    expect(location.reload.name).to eq("Media Annex Renamed")
  end
end
