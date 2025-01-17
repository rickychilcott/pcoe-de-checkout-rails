class Avo::Filters::ItemStatusFilter < Avo::Filters::SelectFilter
  self.name = "Item status"

  def apply(request, query, value)
    query = query.policy_scope_for(current_user).resolve

    case value
    when "available"
      query.not_checked_out
    when "checked_out"
      query.checked_out
    end
  end

  def options
    {
      available: "Available",
      checked_out: "Checked Out"
    }
  end

  def default
    "available"
  end
end
