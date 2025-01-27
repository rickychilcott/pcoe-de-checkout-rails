require "rails_helper"

RSpec.describe Customers::CheckoutsController, type: :controller do
  context "when signed in" do
    describe "POST /create" do
      it "checks out equipment" do
        group = create(:group)
        admin_user = create(:admin_user, groups: [group])
        sign_in admin_user

        item = create(:item, group:)
        customer = create(:customer)
        expected_return_on = 1.day.from_now.to_date

        post :create, params: {customer_id: customer.id, expected_return_on:, item_ids: [item.id]}
        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq("1 Item checked out to #{customer.name}")
        expect(response).to redirect_to(customer)
      end
    end
  end

  context "when not signed in" do
    describe "POST /create" do
      it "checks out equipment" do
        group = create(:group)
        item = create(:item, group:)
        customer = create(:customer)
        expected_return_on = 1.day.from_now.to_date

        post :create, params: {customer_id: customer.id, expected_return_on:, item_ids: [item.id]}

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end
  end
end
