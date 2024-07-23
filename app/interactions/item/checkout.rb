class Item::Checkout < ApplicationInteraction
  run_in_transaction!

  object :item, class: Item
  object :customer, class: Customer
  object :checked_out_by, class: AdminUser
  date_time :checked_out_at, default: -> { DateTime.now }
  date :expected_return_on

  def execute
    checkout =
      Checkout
        .create!(
          item:,
          customer:,
          checked_out_by:,
          checked_out_at:,
          expected_return_on:
        )

    item.record_activity!(
      :item_bulk_import,
      actor: customer,
      facilitator: checked_out_by
    )

    checkout
  end
end
