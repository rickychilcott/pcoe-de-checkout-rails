require "rails_helper"

RSpec.describe "Admin Sign In", type: :system do
  it "passes" do
    admin_user = FactoryBot.create(:admin_user, password: "abcd1234")
    visit new_admin_user_session_path

    expect(page).to have_content "Log in"
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "abcd1234"
    click_button "Log in"

    expect(page).to have_content "Avo"
  end
end
