# frozen_string_literal: true

class Customers::AutocompleteComponent < ApplicationComponent
  prop :customer, Customer, reader: :private

  def view_template
    div class: "autocomplete-item", data: {id: customer.id} do
      if customer.persisted?
        link_to customer_path(customer), id: dom_id(customer) do
          plain "#{customer.name} - #{customer.ohio_id}"
        end
      else
        link_to new_customer_path(name: customer.name, ohio_id: customer.ohio_id), id: dom_id(customer) do
          plain "New Customer"
        end
      end
    end
  end
end
