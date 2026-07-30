class Bravo::Filters::ItemParentFilter < Bravo::SelectFilter
  self.title = "Parent Item"

  def apply(query, value)
    return query if value.blank?

    parent = Item.find_by(id: value)
    parent ? query.where(ancestry: parent.child_ancestry) : query
  end

  def options
    {"" => "All"}.merge(Item.order(:name).pluck(:id, :name).to_h)
  end
end
