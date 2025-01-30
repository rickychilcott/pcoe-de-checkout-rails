class Process::Item::Checkin < ApplicationInteraction
  run_in_transaction!

  object :checkout, class: Checkout
  object :returned_by, class: AdminUser
  date_time :returned_at, default: -> { DateTime.now }

  def execute
    checkout.update!(
      returned_at:,
      returned_by:
    )

    item.record_activity!(
      :item_returned,
      actor: checkout.customer,
      facilitator: returned_by
    )

    checkout
  end

  private

  delegate :item, to: :checkout
end
