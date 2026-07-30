class Item::CheckoutableListComponent < ApplicationComponent
  prop :id, _String?, reader: :private
  prop :customer, Customer, reader: :private
  prop :items, _Enumerable(Item), reader: :private
  prop :fallback, String, reader: :private

  include Phlex::Rails::Helpers::FormWith

  def view_template
    form_with(url: customer_checkouts_url(customer)) do
      input(type: :hidden, name: "customer_id", value: customer.id)

      form_row do
        render ::ListComponent.new(id:, items:, fallback:) do |item|
          render RemovableItemComponent.new(item:)
        end
      end

      form_row do
        div(class: "flex items-center gap-3") do
          label(for: "expected_return_on", class: "text-sm font-medium text-gray-700 whitespace-nowrap") do
            plain "Expected Return"
          end

          input(
            type: :date,
            id: "expected_return_on",
            name: "expected_return_on",
            min: 1.day.from_now.to_date.to_s,
            max: 5.year.from_now.to_date.to_s,
            required: true,
            class: "flex-1 rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:border-primary-400 focus:outline-none"
          )
        end
      end

      button(class: "rounded-md bg-primary-600 text-white px-4 py-2 text-sm font-semibold hover:bg-primary-700 cursor-pointer") do
        plain "Check Out Items!"
      end
    end
  end

  private

  def form_row(**, &)
    div(**mix(**, class: "mb-3"), &)
  end
end
