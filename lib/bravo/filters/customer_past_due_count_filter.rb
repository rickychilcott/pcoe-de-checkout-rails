class Bravo::Filters::CustomerPastDueCountFilter < Bravo::NumberRangeFilter
  self.title = "Past due item count"

  def apply(query, min, max)
    return query if min.nil? && max.nil?

    # checkouts.id (not a literal 1) so a customer with no checkouts at all -- a
    # phantom NULL row from the LEFT JOIN, where returned_at is also NULL --
    # counts as 0 instead of 1.
    count_sql = "COUNT(CASE WHEN checkouts.returned_at IS NULL AND checkouts.expected_return_on < '#{Date.today}' THEN checkouts.id END)"

    matching_ids = Customer.left_joins(:checkouts).group(:id)
    matching_ids = matching_ids.having("#{count_sql} >= ?", min) if min
    matching_ids = matching_ids.having("#{count_sql} <= ?", max) if max

    query.where(id: matching_ids.select(:id))
  end
end
