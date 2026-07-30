class Bravo::Filters::CheckoutGroupFilter < Bravo::SelectFilter
  self.title = "Group"

  def apply(query, value)
    value.present? ? query.joins(:item).where(items: {group_id: value}) : query
  end

  def options
    {"" => "All"}.merge(Group.order(:name).pluck(:id, :name).to_h)
  end
end
