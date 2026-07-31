require "rails_helper"

RSpec.describe "Solid Errors", type: :request do
  it "records the admin who hit the error" do
    admin_user = create(:admin_user, :super_admin)
    sign_in admin_user

    allow_any_instance_of(ItemsController).to receive(:index).and_raise("boom")

    expect {
      get items_path
    }.to raise_error("boom")

    occurrence = SolidErrors::Occurrence.last
    expect(occurrence.error.message).to eq("boom")
    expect(occurrence.context["admin_user_id"]).to eq(admin_user.id)
    expect(occurrence.context["admin_user_email"]).to eq(admin_user.email)
  end

  it "serves the dashboard to a signed in admin" do
    sign_in create(:admin_user, :super_admin)

    get "/admin/errors"

    expect(response).to have_http_status(:ok)
  end
end
