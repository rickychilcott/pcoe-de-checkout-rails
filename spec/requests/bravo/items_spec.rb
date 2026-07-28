require "rails_helper"

RSpec.describe "Bravo Items", type: :request do
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
end
