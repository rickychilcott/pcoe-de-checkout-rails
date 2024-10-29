class CheckoutComponent < ApplicationComponent
  prop :checkout, Checkout, reader: :private

  def view_template
    link_to(new_checkout_return_path(checkout), id: dom_id(checkout, :return), data: {turbo_frame: "_top"}) do
      plain "#{item_name} [#{customer_name}] due #{expected_return_on} ago"
    end
  end

  private

  def item_name
    checkout.item.name
  end

  def customer_name
    checkout.customer.name
  end

  def expected_return_on
    time_ago_in_words(checkout.expected_return_on)
  end
end
