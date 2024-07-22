class Checkout < ApplicationRecord
  belongs_to :item
  belongs_to :customer

  belongs_to :checked_out_by, class_name: "AdminUser"
  belongs_to :returned_by, class_name: "AdminUser"
end
