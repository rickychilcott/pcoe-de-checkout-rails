# frozen_string_literal: true

class Items::AutocompleteAddComponent < ApplicationComponent
  prop :item, Item, reader: :private

  def view_template
    div(class: "autocomplete-item", data: {id: item.id}) do
      link_to cart_add_items_path(item_ids: [item.id], replacement_target: "check-out-available-items-list", format: :turbo_stream), id: link_id, class: "w-100 h-100 d-block", data: {turbo_prefetch: false} do
        plain item.title
      end
    end
  end

  private

  def link_id
    if item.available?
      dom_id(item, :checkout)
    else
      dom_id(item, :return)
    end
  end
end
