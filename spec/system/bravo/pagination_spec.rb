require "rails_helper"

RSpec.describe "Bravo pagination", type: :system do
  let(:per_page) { Bravo::ResourcesController::PER_PAGE }
  let(:total) { per_page + 6 }

  # The index defaults to name descending, so "Location 29" leads and
  # "Location 00" lands on the last page.
  before do
    sign_in create(:admin_user, :super_admin, password: "abcd1234")
    total.times { |i| create(:location, name: "Location #{i.to_s.rjust(2, "0")}") }
  end

  it "paginates the index and links to the next page" do
    visit "/admin/resources/locations"

    expect(page).to have_content "Showing 1–#{per_page} of #{total}"
    expect(page).to have_content "Location #{total - 1}"
    expect(page).to have_no_content "Location 00"

    click_on "2"

    expect(page).to have_content "Showing #{per_page + 1}–#{total} of #{total}"
    expect(page).to have_content "Location 00"
    expect(page).to have_no_content "Location #{total - 1}"
  end

  it "hides the pagination bar when everything fits on one page" do
    Location.where.not(name: "Location 00").destroy_all

    visit "/admin/resources/locations"

    expect(page).to have_content "Location 00"
    expect(page).to have_no_content "Showing 1–"
  end
end
