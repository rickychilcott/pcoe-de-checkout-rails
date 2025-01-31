# frozen_string_literal: true

class Items::AutocompleteComponent < ApplicationComponent
  prop :item, Item, reader: :private

  def view_template
    div(class: "autocomplete-item", data: {id: item.id}) do
      if item.available?
        link_to item_path(item), id: dom_id(item, :checkout), data: {turbo_frame: "_top"} do
          render_inner_text
        end
      else
        link_to item_path(item), id: dom_id(item, :return), data: {turbo_frame: "_top"} do
          render_inner_text
        end
      end
    end
  end

  private

  def render_inner_text
    plain item.name_with_identifiers
  end
end
