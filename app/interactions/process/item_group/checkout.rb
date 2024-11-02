class Process::ItemGroup::Checkout < ApplicationInteraction
  run_in_transaction!

  object :customer, class: Customer
  array :items do
    object class: Item
  end
  date :expected_return_on

  object :checked_out_by, class: AdminUser
  date_time :checked_out_at, default: -> { DateTime.now }

  def execute
    record_activity!(
      :item_group_checked_out,
      records: items,
      actor: customer,
      facilitator: checked_out_by
    )

    items.map do |item|
      Process::Item::Checkout.run!(
        customer:,
        item:,
        expected_return_on:,
        checked_out_by:,
        checked_out_at:
      )
    end
  end
end
