require "rails_helper"

RSpec.describe "Customer Checkouts", type: :request do
  describe "POST /customers/:customer_id/checkouts" do
    it "checks out equipment" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      sign_in admin_user

      item = create(:item, group:)
      customer = create(:customer)
      expected_return_on = 1.day.from_now.to_date

      expect {
        post customer_checkouts_path(customer), params: {expected_return_on:, item_ids: [item.id]}
      }.to change(Checkout.checked_out, :count).by(1)

      expect(response).to redirect_to(customer_path(customer))
      expect(response).to have_http_status(:see_other)
      expect(flash[:notice]).to eq("1 Item checked out to #{customer.title}")
      expect(item.reload).not_to be_available
    end

    it "is not routable when signed out" do
      customer = create(:customer)

      expect {
        post customer_checkouts_path(customer), params: {item_ids: []}
      }.not_to change(Checkout, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
