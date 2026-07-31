require "rails_helper"

RSpec.describe "Bravo Attachments", type: :request do
  let(:item) { create(:item) }

  def attach_image
    item.images.attach(
      io: Rails.root.join("spec/fixtures/files/image.jpeg").open,
      filename: "existing.jpeg",
      content_type: "image/jpeg"
    )
    item.images.first
  end

  describe "DELETE /admin/resources/:resource_name/:id/attachments/:attachment_id" do
    it "purges the attachment" do
      sign_in create(:admin_user, :super_admin)
      attachment = attach_image

      expect {
        delete bravo_resource_attachment_path("items", item, attachment)
      }.to have_enqueued_job(ActiveStorage::PurgeJob)

      expect(response).to redirect_to(bravo_resource_path("items", item))
      expect(flash[:notice]).to eq("File removed.")
    end

    it "404s for an attachment belonging to another record" do
      sign_in create(:admin_user, :super_admin)
      attachment = attach_image
      other_item = create(:item)

      delete bravo_resource_attachment_path("items", other_item, attachment)

      expect(response).to have_http_status(:not_found)
      expect(ActiveStorage::Attachment.exists?(attachment.id)).to be(true)
    end

    it "rejects an admin who cannot update the record" do
      sign_in create(:admin_user)
      attachment = attach_image

      delete bravo_resource_attachment_path("items", item, attachment)

      expect(response).to redirect_to(bravo_root_path)
      expect(ActiveStorage::Attachment.exists?(attachment.id)).to be(true)
    end
  end
end
