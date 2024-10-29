module Autocompletable
  extend ActiveSupport::Concern

  private

  def autocomplete_for(component_class, &block)
    json =
      {
        results: Array(yield).map do |record|
          render_to_string(
            component_class.new(record.model_name.element.to_sym => record),
            layout: false
          )
        end
      }

    render json:
  end
end
