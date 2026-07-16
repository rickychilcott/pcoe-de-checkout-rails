class Checkout::ReturnableListComponent < ApplicationComponent
  prop :id, _String?, reader: :private
  prop :customer, Customer, reader: :private
  prop :checkouts, _Enumerable(Checkout), reader: :private
  prop :fallback, String, reader: :private

  include Phlex::Rails::Helpers::FormWith

  def view_template
    turbo_frame_tag("#{id}-returnable-checkouts") do
      form_with(url: customer_returns_url(customer), data: {turbo_confirm: "Are you sure you want to return these item(s)?"}) do
        input(type: :hidden, name: "customer_id", value: customer.id)

        form_row do
          render ::ListComponent.new(id:, items: checkouts, fallback:) do |checkout|
            render CheckoutComponent.new(checkout:)
          end
        end

        if checkouts.any?
          button(class: "rounded-md bg-primary-600 text-white px-4 py-2 text-sm font-semibold hover:bg-primary-700 cursor-pointer") do
            plain "Return Items!"
          end
        end
      end
    end
  end

  private

  def form_row(&)
    div(class: "mb-3", &)
  end
end
