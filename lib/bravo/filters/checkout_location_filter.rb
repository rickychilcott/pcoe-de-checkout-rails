class Bravo::Filters::CheckoutLocationFilter < Bravo::SelectFilter
  self.title = "Location"

  def apply(query, value)
    value.present? ? query.joins(:item).where(items: {location_id: value}) : query
  end

  def options
    {"" => "All"}.merge(Location.order(:name).pluck(:id, :name).to_h)
  end
end
