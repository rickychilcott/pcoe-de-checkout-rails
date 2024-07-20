class Item < ApplicationRecord
  belongs_to :parent_item, optional: true, class_name: "Item"
  belongs_to :location
  belongs_to :group

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
end
