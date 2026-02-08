require "rails_helper"

RSpec.describe "Item Import", type: :system do
  describe "importing" do
    it "successfully" do
      create(:customer, name: "Customer With Ohio ID", ohio_id: "aa111111")
      admin_user = create(:admin_user, super_admin: true)
      sign_in admin_user

      visit avo.resources_customers_path
      click_on "Actions"
      click_on "Import Customers"

      expect(page).to have_content "CSV Template"

      within "turbo-frame#modal_frame" do
        within "form" do
          attach_file "fields_csv_file", Rails.root.join("spec/fixtures/files/customers.csv")
          click_button "Import"
        end
      end

      expect(page).to have_content "5 customers imported successfully"
      expect(Customer.count).to eq 5
      expect(Activity.count).to eq 5
      import_identifiers = Activity.pluck(:extra).map { it["import_identifier"] }.compact_blank
      expect(import_identifiers.size).to eq 5
      expect(import_identifiers.uniq.size).to eq 1
    end

    it "handles errors" do
      admin_user = create(:admin_user, super_admin: true)
      sign_in admin_user

      visit avo.resources_customers_path
      click_on "Actions"
      click_on "Import Customers"

      expect(page).to have_content "CSV Template"

      within "turbo-frame#modal_frame" do
        within "form" do
          attach_file "fields_csv_file", Rails.root.join("spec/fixtures/files/bad_customers.csv")
          click_button "Import"
        end
      end

      expect(page).to have_content "Error:"
      expect(Customer.count).to eq 0
    end
  end

  it "can download template" do
    admin_user = create(:admin_user, super_admin: true)
    sign_in admin_user

    visit avo.resources_customers_path
    click_on "Actions"
    click_on "Import Customers"

    expect(page).to have_content "CSV Template"

    click_link "CSV Template"

    wait_for_download
    expect(downloads).to include(/customer-import-template.csv/)
  end
end
