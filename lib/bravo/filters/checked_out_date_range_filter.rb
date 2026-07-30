class Bravo::Filters::CheckedOutDateRangeFilter < Bravo::DateRangeFilter
  self.title = "Checked out between"

  def apply(query, from, to)
    query = query.where(checked_out_at: from.beginning_of_day..) if from
    query = query.where(checked_out_at: ..to.end_of_day) if to
    query
  end

  def default_from = Checkout.minimum(:checked_out_at)&.to_date

  def default_to = Date.today
end
