class Bravo::Filters::CustomerCheckedOutCountFilter < Bravo::NumberRangeFilter
  self.title = "Checked out item count"

  # checkouts.id (not a literal 1) so a customer with no checkouts at all -- a
  # phantom NULL row from the LEFT JOIN, where returned_at is also NULL --
  # counts as 0 instead of 1.
  COUNT_SQL = "COUNT(CASE WHEN checkouts.returned_at IS NULL THEN checkouts.id END)"

  def apply(query, min, max)
    return query if min.nil? && max.nil?

    matching_ids = Customer.left_joins(:checkouts).group(:id)
    matching_ids = matching_ids.having("#{COUNT_SQL} >= ?", min) if min
    matching_ids = matching_ids.having("#{COUNT_SQL} <= ?", max) if max

    query.where(id: matching_ids.select(:id))
  end
end
