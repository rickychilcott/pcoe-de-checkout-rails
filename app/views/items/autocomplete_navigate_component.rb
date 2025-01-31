# frozen_string_literal: true

class Items::AutocompleteNavigateComponent < ApplicationComponent
  prop :item, Item, reader: :private

  def view_template
    div(class: "autocomplete-item", data: {id: item.id}) do
      link_to item_path(item), id: link_id, class: "w-100 h-100 d-block", data: {turbo_frame: "_top"} do
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
