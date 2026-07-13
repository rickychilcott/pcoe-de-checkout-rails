require "rails_helper"

RSpec.describe "Customers", type: :request do
  describe "POST /customers" do
    it "creates a customer and redirects" do
      sign_in create(:admin_user)

      expect {
        post customers_path, params: {customer: attributes_for(:customer)}
      }.to change(Customer, :count).by(1)

      expect(response).to redirect_to(customer_path(Customer.last))
    end

    it "re-renders the form with 422 for invalid input" do
      sign_in create(:admin_user)

      expect {
        post customers_path, params: {customer: {name: "", ohio_id: ""}}
      }.not_to change(Customer, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "is not routable when signed out" do
      post customers_path, params: {customer: attributes_for(:customer)}

      expect(response).to have_http_status(:not_found)
    end
  end
end
