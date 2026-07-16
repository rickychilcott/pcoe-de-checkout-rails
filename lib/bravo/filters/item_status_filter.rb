class Bravo::Filters::ItemStatusFilter < Bravo::SelectFilter
  self.title = "Item status"

  def apply(_request, query, value)
    case value
    when "available"
      query.not_checked_out
    when "checked_out"
      query.checked_out
    else
      query
    end
  end

  def options
    {
      all: "All",
      available: "Available",
      checked_out: "Checked Out"
    }
  end

  def default
    "all"
  end
end
