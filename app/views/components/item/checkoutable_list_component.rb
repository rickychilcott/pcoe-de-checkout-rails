class Item::CheckoutableListComponent < ApplicationComponent
  prop :id, _String?, reader: :private
  prop :customer, Customer, reader: :private
  prop :items, _Enumerable(Item), reader: :private
  prop :fallback, String, reader: :private

  include Phlex::Rails::Helpers::FormWith

  def view_template
    turbo_frame_tag("checkoutable-items") do
      form_with(url: customer_checkouts_url(customer)) do
        input(type: :hidden, name: "customer_id", value: customer.id)

        form_row do
          render ::ListComponent.new(id:, items:, fallback:) do |item|
            render ItemComponent.new(item:)
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
            max: 1.year.from_now.to_date.to_s,
            required: true
          )
        end

        form_row do
          button(class: "btn btn-primary") do
            plain "Check Out Items!"
          end
        end
      end
    end
  end

  private

  def form_row(&)
    div(class: "row mb-3", &)
  end

  def inline_label(**kwargs, &)
    label(**mix(kwargs, class: "col-form-label col-sm-4"), &)
  end

  def inline_input(**kwargs)
    div(class: "col-sm-8") do
      input(**mix(kwargs, class: "form-control"))
    end
  end
end
