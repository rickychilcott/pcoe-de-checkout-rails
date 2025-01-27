class CheckoutComponent < ApplicationComponent
  include Phlex::Rails::Helpers::CheckBoxTag
  prop :checkout, Checkout, reader: :private

  def view_template
    checkbox
    link
  end

  private

  def checkbox
    check_box_tag("checkout_ids[]", checkout.id, false, id: dom_id(checkout, :id))
  end

  def link
    link_to(new_checkout_return_path(checkout), id: dom_id(checkout, :return), data: {turbo_frame: "_top"}) do
      plain "#{item_name} [#{customer_name}] due #{expected_return_on_phrase}"
    end
  end

  def item_name
    checkout.item.name
  end

  def customer_name
    checkout.customer.name
  end

  def expected_return_on_phrase
    if checkout.past_due?
      "#{expected_return_on} ago"
    else
      "in #{expected_return_on}"
    end
  end

  def expected_return_on
    time_ago_in_words(checkout.expected_return_on)
  end
end
