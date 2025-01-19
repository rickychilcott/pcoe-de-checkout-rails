class Avo::Cards::AvailableItemsChart < Avo::Cards::ChartkickCard
  self.id = "available_items_chart"
  self.label = "Item Availability"
  self.chart_type = :pie_chart
  # self.description = "Some tiny description"
  self.cols = 1
  # self.chart_options = { library: { plugins: { legend: { display: true } } } }
  # self.flush = true

  def query
    result({
      "Available" => Item.resolved_policy_scope_for(current_user).not_checked_out.count,
      "Checked Out" => Item.resolved_policy_scope_for(current_user).checked_out.count
    })
  end
end
