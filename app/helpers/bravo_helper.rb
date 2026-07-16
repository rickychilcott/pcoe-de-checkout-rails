module BravoHelper
  def bravo_record_path(record, resource_class: nil)
    resource_class ||= Bravo.resource_for_model(record.class)
    bravo_resource_path(resource_class.route_key, record.id)
  end

  def bravo_record_title(record)
    record.try(:title).presence || record.try(:name).presence || "#{record.model_name.human} ##{record.id}"
  end

  def bravo_record_link(record, resource_class: nil)
    link_to bravo_record_title(record), bravo_record_path(record, resource_class:), class: "text-primary-600 hover:underline"
  end

  # Times display in the campus timezone, like Avo did
  def bravo_time(value)
    value&.in_time_zone("America/New_York")&.strftime("%Y-%m-%d %-l:%M %p")
  end

  def bravo_field_display(field, record, compact: false)
    render "bravo/fields/display", field:, record:, compact:
  end

  def bravo_sort_url(field)
    direction = (params[:sort] == field.id.to_s && params[:dir] != "desc") ? "desc" : "asc"
    url_for(request.query_parameters.merge(sort: field.id, dir: direction, page: nil))
  end

  def bravo_sort_indicator(field)
    return "" unless params[:sort] == field.id.to_s

    (params[:dir] == "desc") ? "↓" : "↑"
  end

  BADGE_CLASSES = {
    success: "bg-green-100 text-green-800",
    danger: "bg-red-100 text-red-800",
    warning: "bg-amber-100 text-amber-800",
    info: "bg-primary-100 text-primary-700"
  }.freeze

  def bravo_badge_class(field, value)
    kind, _values = field.options[:options].find { |_kind, values| Array(values).map(&:to_s).include?(value.to_s) }
    BADGE_CLASSES[kind] || "bg-gray-100 text-gray-800"
  end

  # Resolve a select value back to its human label
  def bravo_select_label(field, value)
    options = field.select_options(self)
    pair = options.to_a.find { |_label, v| v.to_s == value.to_s }
    pair ? pair.first : value
  end

  def bravo_sidebar_link(resource_class)
    path = bravo_resources_path(resource_class.route_key)
    active = request.path.start_with?(path)
    link_to resource_class.label, path,
      class: "block rounded-md px-3 py-1.5 hover:bg-primary-50 #{"bg-primary-100 text-primary-700 font-medium" if active}"
  end

  def bravo_current_filter_value(filter_class)
    params.dig(:filters, filter_class.key).presence || filter_class.new.default
  end
end
