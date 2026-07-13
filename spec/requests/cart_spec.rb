require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "GET /cart/add_items" do
    it "appends the item to the cart via turbo stream" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      sign_in admin_user

      item = create(:item, name: "Laptop", group:)

      get cart_add_items_path,
        params: {item_ids: [item.id], replacement_target: "cart-items"},
        headers: {"Accept" => "text/vnd.turbo-stream.html"}

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include('<turbo-stream action="append" target="cart-items">')
      expect(response.body).to include(item.name)
    end
  end

  describe "DELETE /cart/remove_items" do
    it "removes the target via turbo stream" do
      group = create(:group)
      admin_user = create(:admin_user, groups: [group])
      sign_in admin_user

      item = create(:item, name: "Laptop", group:)

      delete cart_remove_items_path,
        params: {item_ids: [item.id], replacement_target: "cart-items"},
        headers: {"Accept" => "text/vnd.turbo-stream.html"}

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<turbo-stream action="remove" target="cart-items">')
    end
  end

  it "is not routable when signed out" do
    get cart_add_items_path, params: {item_ids: []}

    expect(response).to have_http_status(:not_found)
  end
end
