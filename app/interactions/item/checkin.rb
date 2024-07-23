class Item::Checkin < ApplicationInteraction
  run_in_transaction!

  object :item, class: Item
  object :checkout, class: Checkout
  object :returned_by, class: AdminUser
  date_time :returned_at, default: -> { DateTime.now }

  def execute
    checkout.update!(
      returned_at:,
      returned_by:
    )

    item.record_activity!(
      :item_checked_in,
      actor: checkout.customer,
      facilitator: returned_by
    )

    checkout
  end
end
