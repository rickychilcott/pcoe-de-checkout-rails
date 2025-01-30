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
          form_row do
            button(class: "btn btn-primary") do
              plain "Return Items!"
            end
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
