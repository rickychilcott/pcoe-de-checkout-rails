require "rails_helper"

RSpec.describe "Item Import", type: :system do
  describe "importing" do
    it "succesfully" do
      group = create(:group, name: "Default")
      location = create(:location, name: "House")
      create(:item, id: 1, name: "Existing Item", group:, location:)
      admin_user = create(:admin_user, super_admin: true)
      sign_in admin_user

      visit avo.resources_items_path
      click_on "Actions"
      click_on "Import Items"

      expect(page).to have_content "CSV Template"

      within "turbo-frame#modal_frame" do
        within "form" do
          attach_file "fields_csv_file", Rails.root.join("spec", "fixtures", "files", "items.csv")
          click_button "Import"
        end
      end

      expect(page).to have_content "5 items imported successfully"
      expect(Item.count).to eq 5
      expect(Location.count).to eq 2
      expect(Group.count).to eq 1
      expect(Activity.count).to eq 5
      import_identifiers = Activity.pluck(:extra).map { _1["import_identifier"] }.compact_blank
      expect(import_identifiers.size).to eq 5
      expect(import_identifiers.uniq.size).to eq 1
    end

    it "handles errors" do
      admin_user = create(:admin_user, super_admin: true)
      sign_in admin_user

      visit avo.resources_items_path
      click_on "Actions"
      click_on "Import Items"

      expect(page).to have_content "CSV Template"

      within "turbo-frame#modal_frame" do
        within "form" do
          attach_file "fields_csv_file", Rails.root.join("spec", "fixtures", "files", "items.csv")
          click_button "Import"
        end
      end

      expect(page).to have_content "Error:"
      expect(Item.count).to eq 0
      expect(Location.count).to eq 0
      expect(Group.count).to eq 0
    end
  end

  it "can download template" do
    admin_user = create(:admin_user, super_admin: true)
    sign_in admin_user

    visit avo.resources_items_path
    click_on "Actions"
    click_on "Import Items"

    expect(page).to have_content "CSV Template"

    click_link "CSV Template"

    wait_for_download
    expect(downloads).to include(/item-import-template.csv/)
  end
end
