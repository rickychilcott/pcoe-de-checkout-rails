require "rails_helper"

RSpec.describe "Admin Sign In", type: :system do
  it "can log in and out" do
    admin_user = create(:admin_user, password: "abcd1234")
    visit new_admin_user_session_path

    expect(page).to have_content "Log in"
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "abcd1234"
    click_button "Log in"

    find("#bravo-link").click

    expect(page).to have_content "Documentation"
    expect(page).to be_wcag2_accessible

    click_on "Sign out"

    expect(page).to have_content "Log in"
  end

  it "fails to log in" do
    password = "abcd1234"
    admin_user = create(:admin_user, password:)
    visit new_admin_user_session_path

    expect(page).to have_content "Log in"
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: password.reverse
    click_button "Log in"

    expect(page).not_to have_content "Documentation"
  end
end
