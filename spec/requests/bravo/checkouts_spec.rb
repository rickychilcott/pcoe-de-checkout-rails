require "rails_helper"

RSpec.describe "Bravo Checkouts", type: :request do
  describe "GET /admin/resources/checkouts.csv" do
    it "exports the filtered checkouts, including group and location columns" do
      sign_in create(:admin_user, :super_admin)

      matching_group = create(:group, name: "Robotics")
      other_group = create(:group, name: "Woodshop")
      matching_item = create(:item, group: matching_group, location: create(:location, name: "Library"))
      other_item = create(:item, group: other_group)
      matching_checkout = create(:checkout, item: matching_item, customer: create(:customer, name: "Ada Lovelace"))
      create(:checkout, item: other_item)

      get bravo_resources_path("checkouts", format: :csv, filters: {checkout_group_filter: matching_group.id})

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")

      rows = CSV.parse(response.body, headers: true)
      expect(rows.headers).to include("Group", "Location")
      expect(rows.size).to eq(1)
      expect(rows.first["Group"]).to eq("Robotics")
      expect(rows.first["Location"]).to eq("Library")
      expect(rows.first["Customer"]).to eq(matching_checkout.customer.title)
    end
  end

  describe "GET /admin/resources/checkouts" do
    it "filters by group, location, and customer" do
      sign_in create(:admin_user, :super_admin)

      group = create(:group)
      location = create(:location)
      customer = create(:customer)
      item = create(:item, group:, location:)
      keep = create(:checkout, item:, customer:)
      create(:checkout)

      get bravo_resources_path("checkouts", filters: {
        checkout_group_filter: group.id,
        checkout_location_filter: location.id,
        checkout_customer_filter: customer.id
      })

      expect(Nokogiri::HTML(response.body).text).to include(keep.item.name)
    end

    it "filters by a checked-out date range" do
      sign_in create(:admin_user, :super_admin)

      in_range = create(:checkout, checked_out_at: 5.days.ago)
      out_of_range = create(:checkout, checked_out_at: 20.days.ago)

      get bravo_resources_path("checkouts", filters: {
        checked_out_date_range_filter_from: 10.days.ago.to_date,
        checked_out_date_range_filter_to: Date.today
      })

      page_text = Nokogiri::HTML(response.body).text
      expect(page_text).to include(in_range.item.name)
      expect(page_text).not_to include(out_of_range.item.name)
    end
  end
end
