class ItemsController < ApplicationController
  include Autocompletable

  def index
    query = params[:q]

    autocomplete_for(Items::AutocompleteComponent) do
      Item
        .ransack(
          name_cont: query,
          serial_number_cont: query,
          qr_code_identifier_cont: query,
          m: "or"
        )
        .result(distinct: false)
    end
  end
end
