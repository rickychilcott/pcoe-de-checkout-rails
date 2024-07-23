# == Schema Information
#
# Table name: checkouts
#
#  id                 :integer          not null, primary key
#  checked_out_at     :datetime
#  expected_return_on :date
#  returned_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  checked_out_by_id  :integer          not null
#  customer_id        :integer          not null
#  item_id            :integer          not null
#  returned_by_id     :integer
#
# Indexes
#
#  index_checkouts_on_checked_out_by_id  (checked_out_by_id)
#  index_checkouts_on_customer_id        (customer_id)
#  index_checkouts_on_item_id            (item_id)
#  index_checkouts_on_returned_by_id     (returned_by_id)
#
# Foreign Keys
#
#  checked_out_by_id  (checked_out_by_id => admin_users.id)
#  customer_id        (customer_id => customers.id)
#  item_id            (item_id => items.id)
#  returned_by_id     (returned_by_id => admin_users.id)
#
class Avo::Resources::Checkout < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :checked_out_at, as: :datetime, readonly: true
    field :checked_out_by, as: :belongs_to, readonly: true

    field :returned_at, as: :datetime, readonly: true
    field :returned_by, as: :belongs_to, readonly: true

    field :expected_return_on, as: :date, readonly: true
    field :customer, as: :belongs_to, readonly: true
    field :item, as: :belongs_to, readonly: true
  end
end
