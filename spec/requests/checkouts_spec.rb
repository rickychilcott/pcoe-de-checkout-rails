require "rails_helper"

RSpec.describe "Checkouts", type: :request do
  describe "GET /checkouts" do
    it "lists checked out items, and only past due ones when asked" do
      sign_in create(:admin_user, :super_admin)

      past_due = create(:checkout, expected_return_on: 3.days.ago.to_date)
      on_time = create(:checkout, expected_return_on: 3.days.from_now.to_date)

      get checkouts_path
      expect(response.body).to include(past_due.item.name, on_time.item.name)

      get checkouts_path(only_past_due: "1")
      expect(response.body).to include(past_due.item.name)
      expect(response.body).not_to include(on_time.item.name)
    end
  end

  describe "GET /checkouts/:id" do
    it "redirects to the checked out item" do
      sign_in create(:admin_user, :super_admin)
      checkout = create(:checkout)

      get checkout_path(checkout)

      expect(response).to redirect_to(item_path(checkout.item))
    end

    it "404s for a checkout outside the admin's groups" do
      sign_in create(:admin_user)
      checkout = create(:checkout)

      get checkout_path(checkout)

      expect(response).to have_http_status(:not_found)
    end
  end
end
