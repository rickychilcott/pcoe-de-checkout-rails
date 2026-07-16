class Bravo::Cards::AvailableItemsChart
  LABEL = "Item Availability"

  def initialize(current_user:)
    @current_user = current_user
  end

  def query
    {
      "Available" => Item.resolved_policy_scope_for(@current_user).not_checked_out.count,
      "Checked Out" => Item.resolved_policy_scope_for(@current_user).checked_out.count
    }
  end
end
