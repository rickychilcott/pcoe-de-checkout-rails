# frozen_string_literal: true

class Items::AutocompleteComponent < ApplicationComponent
  prop :item, Item, reader: :private

  def view_template
    div(class: "autocomplete-item", data: {id: item.id}) do
      if item.available?
        link_to new_item_checkout_path(item), id: dom_id(item, :checkout) do
          render_inner_text
        end
      else
        link_to new_checkout_return_path(checkout), id: dom_id(checkout, :return), data: {turbo_frame: "_top"} do
          render_inner_text
        end
      end
    end
  end

  private

  def checkout = item.current_checkout

  def render_inner_text
    plain [item.name, qr_code_identifier, serial_number].compact.join(" ")
  end

  def qr_code_identifier
    return unless item.qr_code_identifier.present?

    "(#{item.qr_code_identifier})"
  end

  def serial_number
    return unless item.serial_number.present?

    "[#{item.serial_number}]"
  end
end
