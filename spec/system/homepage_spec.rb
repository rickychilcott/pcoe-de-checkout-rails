require "rails_helper"

RSpec.describe "Homepage", type: :system do
  it "passes" do
    visit root_path

    expect(page).to have_content "Items Available"
    expect(page).to be_wcag2_accessible
  end
end
