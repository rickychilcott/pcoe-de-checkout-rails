class Bravo::Filters::ItemStatusFilter < Bravo::SelectFilter
  self.title = "Item status"

  def apply(query, value)
    case value
    when "available"
      query.not_checked_out
    when "checked_out"
      query.checked_out
    when "past_due"
      query.past_due
    else
      query
    end
  end

  def options
    {
      all: "All",
      available: "Available",
      checked_out: "Checked Out",
      past_due: "Past Due"
    }
  end

  def default
    "all"
  end
end
