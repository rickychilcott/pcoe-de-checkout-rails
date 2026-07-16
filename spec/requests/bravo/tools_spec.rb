require "rails_helper"

RSpec.describe "Bravo Tools", type: :request do
  describe "GET /admin/import_customers_download_template" do
    it "downloads the customer import template" do
      sign_in create(:admin_user, :super_admin)

      get bravo_import_customers_download_template_path(format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")
      expect(response.body).to eq(Process::Customer::BulkImport.csv_template)
    end
  end

  describe "GET /admin/import_items_download_template" do
    it "downloads the item import template" do
      sign_in create(:admin_user, :super_admin)

      get bravo_import_items_download_template_path(format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")
      expect(response.body).to eq(Process::Item::BulkImport.csv_template)
    end
  end
end
