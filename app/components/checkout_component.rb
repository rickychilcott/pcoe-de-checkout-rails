class CheckoutComponent < ApplicationComponent
  include Phlex::Rails::Helpers::CheckBoxTag
  prop :checkout, Checkout, reader: :private

  def view_template
    checkbox
    link
  end

  private

  def checkbox
    check_box_tag("checkout_ids[]", checkout.id, false, id: checkout_id)
  end

  def link
    label(for: checkout_id) do
      link_to(item_path(item), id: dom_id(checkout, :return), data: {turbo_frame: "_top"}, class: "ps-2") do
        plain "#{item_name} [#{customer_name}] due #{expected_return_on_phrase}"
      end
    end
  end

  def checkout_id = dom_id(checkout, :id)

  delegate :item, to: :checkout
  delegate :name, to: :item, prefix: true
  delegate :customer, to: :checkout
  delegate :name, to: :customer, prefix: true

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
