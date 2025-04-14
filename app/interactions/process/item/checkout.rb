class Process::Item::Checkout < ApplicationInteraction
  run_in_transaction!

  object :item, class: Item
  object :customer, class: Customer
  object :checked_out_by, class: AdminUser
  date_time :checked_out_at, default: -> { DateTime.now }
  date :expected_return_on

  def execute
    created = false

    checkout =
      Checkout
        .find_or_create_by!(
          item:,
          customer:
        ) do |checkout|
          created = true
          checkout.checked_out_by = checked_out_by
          checkout.checked_out_at = checked_out_at
          checkout.expected_return_on = expected_return_on
        end

    if created
      item.record_activity!(
        :item_checked_out,
        actor: customer,
        facilitator: checked_out_by
      )
    end

    checkout
  end
end
