# frozen_string_literal: true

class Customers::AutocompleteComponent < ApplicationComponent
  prop :customer, Customer, reader: :private

  def view_template
    div class: "autocomplete-item", data: {id: customer.id} do
      if customer.persisted?
        link_to customer_path(customer), id: dom_id(customer), **wide_link do
          plain customer.title
        end
      else
        link_to new_customer_path(name: customer.name, ohio_id: customer.ohio_id), id: dom_id(customer), **wide_link do
          plain "New Customer"
        end
      end
    end
  end

  private

  def wide_link
    {
      class: "w-100 h-100 d-block",
      data: {
        turbo_frame: :_top
      }
    }
  end
end
