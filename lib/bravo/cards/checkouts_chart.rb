class Bravo::Cards::CheckoutsChart
  LABEL = "Checkout History"
  DESCRIPTION = "History of checkouts over time"

  RANGES = {
    "7 days" => "7",
    "30 days" => "30",
    "90 days" => "90",
    "365 days" => "365",
    "MTD" => "MTD",
    "QTD" => "QTD",
    "YTD" => "YTD",
    "All" => "ALL"
  }.freeze

  START_DATE = {
    "7" => -> { 7.days.ago },
    "30" => -> { 30.days.ago },
    "90" => -> { 90.days.ago },
    "365" => -> { 365.days.ago },
    "MTD" => -> { Date.current.beginning_of_month },
    "QTD" => -> { Date.current.beginning_of_quarter },
    "YTD" => -> { Date.current.beginning_of_year },
    "ALL" => ->(scope) { scope.minimum(:checked_out_at) || Date.current }
  }.freeze

  attr_reader :current_user, :range

  def initialize(current_user:, range: "30")
    @current_user = current_user
    @range = RANGES.value?(range.to_s) ? range.to_s : "30"
  end

  def query
    scoped = Checkout.resolved_policy_scope_for(current_user)
    start_lambda = START_DATE.fetch(range.to_s)
    start_date = (start_lambda.arity == 1) ? start_lambda.call(scoped) : start_lambda.call

    dates = start_date.to_date..Date.current
    raw_data =
      scoped
        .order(checked_out_at: :asc)
        .select(:checked_out_at, :expected_return_on, :returned_at)

    checked_out_item_data, past_due_items_data = {}, {}

    dates.each do |date|
      checked_out_item_data[date.to_s] = 0
      past_due_items_data[date.to_s] = 0
    end

    window_start = dates.first

    raw_data.each do |checkout|
      # Clamp to the chart window: checkouts older than the selected range
      # otherwise walk dates the hashes were never initialized for.
      checkout_date = [checkout.checked_out_at.to_date, window_start].max
      returned_at_date = checkout.returned_at&.to_date || Date.current

      (checkout_date..returned_at_date).each { |date| checked_out_item_data[date.to_s] += 1 }
    end

    raw_data.each do |checkout|
      expected_return_on_date = checkout.expected_return_on.to_date
      returned_at_date = checkout.returned_at&.to_date || Date.current

      next if expected_return_on_date.after?(returned_at_date) || expected_return_on_date.eql?(returned_at_date)

      ([expected_return_on_date, window_start].max..returned_at_date).each { |date| past_due_items_data[date.to_s] += 1 }
    end

    [
      {name: "Checked Out Items (count)", data: checked_out_item_data},
      {name: "Past Due Items (count)", data: past_due_items_data}
    ]
  end
end
