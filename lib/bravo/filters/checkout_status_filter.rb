class Bravo::Filters::CheckoutStatusFilter < Bravo::SelectFilter
  self.title = "Checkout status"

  def apply(_request, query, value)
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
