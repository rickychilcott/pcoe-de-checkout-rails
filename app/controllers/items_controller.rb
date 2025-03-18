class ItemsController < ApplicationController
  include Autocompletable

  def index
    query = params[:q]

    autocomplete_for(autocomplete_component_class) do
      items =
        resolved_policy_scope(Item)
          .ransack(
            name_cont: query,
            serial_number_cont: query,
            qr_code_identifier_cont: query,
            m: "or"
          )
          .result(distinct: false)

      if only_not_checked_out?
        items.not_checked_out
      else
        items
      end
    end
  end

  def show
    item =
      resolved_policy_scope(Item)
        .includes(:location, :group, :current_checkout)
        .find(params[:id])

    current_checkout = item.current_checkout
    render locals: {item:, current_checkout:}
  end

  ALLOWED_AUTOCOMPLETE_CLASSES = [
    Items::AutocompleteNavigateComponent,
    Items::AutocompleteAddComponent
  ].map { |klass| [klass.name, klass] }.to_h.freeze

  private

  def only_not_checked_out?
    params[:filter] == "not_checked_out"
  end

  def autocomplete_component_class
    ALLOWED_AUTOCOMPLETE_CLASSES.fetch(params[:autocomplete_class], Items::AutocompleteNavigateComponent)
  end
end
