class Item < ApplicationRecord
  has_ancestry

  belongs_to :location
  belongs_to :group
  has_many :checkouts
  has_many :current_checkouts, -> { where(returned_at: nil) }, class_name: "Checkout"
  has_one :current_checkout, -> { where(returned_at: nil) }, class_name: "Checkout"

  has_many_attached :images
  has_rich_text :description

  def qr_code_as_svg
    RQRCode::QRCode
      .new(qr_code_identifier)
      .as_svg(
        offset: 5,
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 4
      )
  end

  def available?
    !current_checkout.present?
  end
end
