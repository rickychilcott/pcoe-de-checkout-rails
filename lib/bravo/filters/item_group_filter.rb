class Bravo::Filters::ItemGroupFilter < Bravo::SelectFilter
  self.title = "Group"

  def apply(query, value)
    value.present? ? query.where(group_id: value) : query
  end

  def options
    {"" => "All"}.merge(Group.order(:name).pluck(:id, :name).to_h)
  end
end
