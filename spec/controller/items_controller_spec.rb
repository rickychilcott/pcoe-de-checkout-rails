require "rails_helper"

RSpec.describe ItemsController, type: :controller do
  describe "GET /index" do
    it "as super_admin" do
      sign_in create(:admin_user, :super_admin)

      findable_items = [
        create(:item, name: "Item 1"),
        create(:item, name: "Item 2")
      ]
      not_findable_items = [
        create(:item, name: "Microphone 1"),
        create(:item, name: "Microphone 2")
      ]

      get :index, params: {q: "Item"}

      expect(response).to have_http_status(:ok)

      expect(parsed_results).to match_array(
        findable_items.map do |item|
          /#{item.name} - #{item.serial_number}/
        end
      )
      expect(parsed_results).not_to match_array(
        not_findable_items.map do |item|
          /#{item.name} - #{item.serial_number}/
        end
      )
    end

    it "as non-super_admin" do
      group = create(:group)

      sign_in create(:admin_user, groups: [group])

      group_items = [
        create(:item, name: "Item 1", group:),
        create(:item, name: "Item 2", group:)
      ]
      non_group_items = [
        create(:item, name: "Item 3"),
        create(:item, name: "Item 4")
      ]

      get :index, params: {q: "Item"}

      expect(response).to have_http_status(:ok)
      expect(parsed_results).to match_array(
        group_items.map do |item|
          /#{item.name} - #{item.serial_number}/
        end
      )
      expect(parsed_results).not_to match_array(
        non_group_items.map do |item|
          /#{item.name} - #{item.serial_number}/
        end
      )
    end
  end
end
