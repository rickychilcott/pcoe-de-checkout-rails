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
        inline_label(for: "expected_return_on", class: "pe-2") do
          plain "Expected Return"
        end

        inline_input(
          type: :date,
          id: "expected_return_on",
          name: "expected_return_on",
          min: 1.day.from_now.to_date.to_s,
          max: 5.year.from_now.to_date.to_s,
          required: true
        )
      end

      button(class: "btn btn-primary px-4") do
        plain "Check Out Items!"
      end
    end
  end

  private

  def form_row(**, &)
    div(**mix(**, class: "row mb-2"), &)
  end

  def inline_label(**, &)
    label(**mix(**, class: "col-form-label col-sm-4"), &)
  end

  def inline_input(**)
    div(class: "col-sm-8") do
      input(**mix(**, class: "form-control"))
    end
  end
end
