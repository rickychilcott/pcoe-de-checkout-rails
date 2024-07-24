require "rails_helper"

RSpec.describe "Admin Sign In", type: :system do
  it "can log in and out" do
    admin_user = FactoryBot.create(:admin_user, password: "abcd1234")
    visit new_admin_user_session_path

    expect(page).to have_content "Log in"
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "abcd1234"
    click_button "Log in"

    expect(page).to have_content "Avo"
    expect(page).to be_wcag2_accessible

    accept_prompt do
      find('a[data-control="profile-dots"]').click
      click_on "Sign out"
    end

    expect(page).to have_content "Log In"
    expect(page).to have_content "Items Available"
  end

  it "fails to log in" do
    password = "abcd1234"
    admin_user = FactoryBot.create(:admin_user, password:)
    visit new_admin_user_session_path

    expect(page).to have_content "Log in"
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: password.reverse
    click_button "Log in"

    expect(page).not_to have_content "Avo"
  end
end
