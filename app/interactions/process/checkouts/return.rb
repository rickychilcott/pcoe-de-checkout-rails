class Process::Checkouts::Return < ApplicationInteraction
  run_in_transaction!

  object :customer, class: Customer
  array :checkouts do
    object class: Checkout
  end
  object :returned_by, class: AdminUser
  date_time :returned_at, default: -> { DateTime.now }

  def execute
    record_activity!(
      :checkouts_returned,
      records: checkouts,
      actor: customer,
      facilitator: returned_by
    )

    checkouts.map do |checkout|
      Process::Item::Checkin.run!(
        customer:,
        checkout:,
        returned_by:,
        returned_at:
      )
    end
  end
end
