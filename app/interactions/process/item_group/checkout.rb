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
    # items.each do |item|
    #   Process::Item::Checkout.run!(
    #     customer: customer,
    #     item: item,
    #     expected_return_on: expected_return_on,
    #     checked_out_by: checked_out_by,
    #     checked_out_at: checked_out_at
    #   )
    # end
    items.each do |item|
      compose(
        Process::Item::Checkout,
        inputs.except(:items).merge(item: item)
      )
    end
  end
end
