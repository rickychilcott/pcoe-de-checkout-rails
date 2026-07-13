require "rails_helper"

RSpec.describe "Customer Reminders", type: :request do
  describe "POST /customers/:customer_id/reminders" do
    it "sends a reminder email" do
      admin_user = create(:admin_user)
      sign_in admin_user

      customer = create(:customer)

      expect {
        post customer_reminders_path(customer), params: {reminder: {body: "Please return your items"}}
      }.to have_enqueued_mail(CustomerMailer, :reminder_email)

      expect(response).to redirect_to(customer_path(customer))
      expect(flash[:notice]).to eq("Reminder was sent to #{customer.name}.")
    end

    it "is not routable when signed out" do
      customer = create(:customer)

      expect {
        post customer_reminders_path(customer), params: {reminder: {body: "hi"}}
      }.not_to have_enqueued_mail(CustomerMailer, :reminder_email)

      expect(response).to have_http_status(:not_found)
    end
  end
end
