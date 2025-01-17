class Avo::Filters::CheckoutStatusFilter < Avo::Filters::SelectFilter
  self.name = "Checkout status"

  def apply(request, query, value)
    query = query.policy_scope_for(current_user).resolve

    case value
    when "current"
      query.checked_out
    when "past_due"
      query.past_due
    when "completed"
      query.checked_in
    else
      query
    end
  end

  def options
    {
      current: "Current",
      past_due: "Past due",
      completed: "Completed",
      all: "All"
    }
  end

  def default
    "current"
  end
end
