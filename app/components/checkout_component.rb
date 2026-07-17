class CheckoutComponent < ApplicationComponent
  include Phlex::Rails::Helpers::CheckBoxTag

  prop :checkout, Checkout, reader: :private

  def view_template
    div(class: "flex items-center gap-2.5") do
      checkbox
      toggle_label
      item_link
    end
  end

  private

  def checkbox
    check_box_tag("checkout_ids[]", checkout.id, false, id: checkout_id, class: "h-4 w-4 shrink-0 rounded border-gray-300 cursor-pointer", data: {check_all_target: "checkbox"})
  end

  # Clicking the text toggles the checkbox; navigation lives on the separate arrow link
  def toggle_label
    label(for: checkout_id, class: "cursor-pointer select-none") do
      plain "#{item_name} [#{customer_name}] due #{expected_return_on_phrase}"
    end
  end

  def item_link
    link_to(item_path(item), id: dom_id(checkout, :return), title: "View item", data: {turbo_frame: "_top"}, class: "text-primary-600 hover:underline text-xs font-semibold whitespace-nowrap") do
      plain "View →"
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
