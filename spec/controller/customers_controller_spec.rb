require "rails_helper"

RSpec.describe CustomersController, type: :controller do
  describe "GET /index" do
    it "as super_admin" do
      sign_in create(:admin_user)

      findable_customers = [
        create(:customer, name: "Jim"),
        create(:customer, name: "Jimmy")
      ]
      not_findable_customers = [
        create(:customer, name: "Sal"),
        create(:customer, name: "Sally")
      ]

      get :index, params: {q: "Jim"}

      expect(response).to have_http_status(:ok)

      findable_customers.each do |customer|
        expect(parsed_results).to include(
          /#{customer.name}/
        )
      end

      expect(parsed_results).to include(
        /New Customer/
      )

      not_findable_customers.each do |customer|
        expect(parsed_results).not_to match(
          /#{customer.name}/
        )
      end
    end
  end
end
