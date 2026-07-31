require "rails_helper"

RSpec.describe "Bravo Items", type: :request do
  it "creates an item with uploaded images" do
    sign_in create(:admin_user, :super_admin)

    expect {
      post bravo_resources_path("items"), params: {
        item: {
          name: "Camcorder",
          location_id: create(:location).id,
          group_id: create(:group).id,
          images: [fixture_file_upload("image.jpeg", "image/jpeg")]
        }
      }
    }.to change(Item, :count).by(1)

    item = Item.find_by!(name: "Camcorder")
    expect(response).to redirect_to(bravo_resource_path("items", item))
    expect(item.images.count).to eq(1)
  end

  it "appends uploaded images instead of replacing existing ones" do
    sign_in create(:admin_user, :super_admin)
    item = create(:item)
    item.images.attach(
      io: Rails.root.join("spec/fixtures/files/image.jpeg").open,
      filename: "existing.jpeg",
      content_type: "image/jpeg"
    )

    patch bravo_resource_path("items", item), params: {
      item: {name: item.name, images: [fixture_file_upload("image.jpeg", "image/jpeg")]}
    }

    expect(response).to redirect_to(bravo_resource_path("items", item))
    expect(item.reload.images.count).to eq(2)
  end

  describe "GET /admin/resources/items" do
    # Only the results table -- other filters (e.g. "Parent Item") render a
    # <select> listing every item's name, which would falsely match here.
    def results_table_text
      Nokogiri::HTML(response.body).at_css("tbody").text
    end

    it "filters by status, including past due" do
      sign_in create(:admin_user, :super_admin)

      past_due_item = create(:item, name: "Past Due Projector")
      create(:checkout, item: past_due_item, expected_return_on: 3.days.ago.to_date)

      available_item = create(:item, name: "Available Microphone")

      get bravo_resources_path("items", filters: {item_status_filter: "past_due"})

      expect(results_table_text).to include(past_due_item.name)
      expect(results_table_text).not_to include(available_item.name)
    end

    it "filters by available and checked out status" do
      sign_in create(:admin_user, :super_admin)

      checked_out_item = create(:item, name: "Checked Out Camera")
      create(:checkout, item: checked_out_item)
      available_item = create(:item, name: "Available Tripod")

      get bravo_resources_path("items", filters: {item_status_filter: "available"})
      expect(results_table_text).to include(available_item.name)
      expect(results_table_text).not_to include(checked_out_item.name)

      get bravo_resources_path("items", filters: {item_status_filter: "checked_out"})
      expect(results_table_text).to include(checked_out_item.name)
      expect(results_table_text).not_to include(available_item.name)
    end

    it "filters by group, location, and parent item" do
      sign_in create(:admin_user, :super_admin)

      group = create(:group)
      location = create(:location)
      parent = create(:item)
      child = create(:item, group:, location:, parent:)
      create(:item)

      get bravo_resources_path("items", filters: {
        item_group_filter: group.id,
        item_location_filter: location.id,
        item_parent_filter: parent.id
      })

      expect(results_table_text).to include(child.name)
    end

    it "filters by name and qr code identifier" do
      sign_in create(:admin_user, :super_admin)

      match = create(:item, name: "Xbox Controller", qr_code_identifier: "abc123")
      other = create(:item, name: "Something Else", qr_code_identifier: "zzz999")

      get bravo_resources_path("items", filters: {name: "Xbox"})
      expect(results_table_text).to include(match.name)
      expect(results_table_text).not_to include(other.name)

      get bravo_resources_path("items", filters: {qr_code_identifier: "abc123"})
      expect(results_table_text).to include(match.name)
      expect(results_table_text).not_to include(other.name)
    end
  end
end
