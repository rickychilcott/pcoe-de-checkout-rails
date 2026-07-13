require "rails_helper"

RSpec.describe "Customer Returns", type: :request do
  describe "POST /customers/:customer_id/returns" do
    it "returns checked out items" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      sign_in admin_user

      customer = create(:customer)
      item = create(:item, group:)
      checkout = create(:checkout, customer:, item:)

      post customer_returns_path(customer), params: {checkout_ids: [checkout.id]}

      expect(response).to redirect_to(customer_path(customer))
      expect(response).to have_http_status(:see_other)
      expect(flash[:notice]).to eq("1 Item returned for #{customer.name}")
      expect(checkout.reload.returned_at).to be_present
    end

    it "is not routable when signed out" do
      customer = create(:customer)
      checkout = create(:checkout, customer:)

      post customer_returns_path(customer), params: {checkout_ids: [checkout.id]}

      expect(response).to have_http_status(:not_found)
      expect(checkout.reload.returned_at).to be_nil
    end
  end
end
