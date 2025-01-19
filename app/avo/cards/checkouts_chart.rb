class Avo::Cards::CheckoutsChart < Avo::Cards::ChartkickCard
  self.id = "checkouts_chart"
  self.label = "Checkout History"
  self.chart_type = :area_chart
  self.description = "History of checkouts over time"
  self.cols = 4
  self.rows = 2
  self.initial_range = 30
  self.ranges = {
    "7 days": 7,
    "30 days": 30,
    "90 days": 90,
    "365 days": 365,
    "Month to date": "MTD",
    "Quarter to date": "QTD",
    "Year to date": "YTD",
    All: "ALL"
  }
  self.chart_options = {library: {plugins: {legend: {display: true}}}}
  self.flush = true

  def query
    points = 16
    i = Time.new.year.to_i - points
    base_data = Array.new(points).map do
      i += 1
      [i.to_s, rand(0..20)]
    end.to_h

    start_date =
      case range
      when "7"
        7.days.ago
      when "30"
        30.days.ago
      when "90"
        90.days.ago
      when "365"
        365.days.ago
      when "MTD"
        DateTime.current.beginning_of_month
      when "QTD"
        DateTime.current.beginning_of_quarter
      when "YTD"
        DateTime.current.beginning_of_year
      when "ALL"
        Checkout.minimum(:checked_out_at) || DateTime.current
      end

    dates = start_date.to_date..DateTime.current.to_date
    raw_data =
      Checkout
        .resolved_policy_scope_for(current_user)
        .order(checked_out_at: :asc)
        .select(:checked_out_at, :expected_return_on, :returned_at)

    checked_out_item_data, past_due_items_data = {}, {}

    dates.each do |date|
      checked_out_item_data[date.to_s] = 0
      past_due_items_data[date.to_s] = 0
    end

    raw_data.each do |checkout|
      checkout_date, returned_at_date = checkout.checked_out_at.to_date, checkout.returned_at&.to_date

      (checkout_date..returned_at_date).each { |date| checked_out_item_data[date.to_s] += 1 }
    end

    raw_data.each do |checkout|
      expected_return_on_date, returned_at_date = checkout.expected_return_on.to_date, checkout.returned_at&.to_date

      next if expected_return_on_date.after?(returned_at_date) || expected_return_on_date.eql?(returned_at_date)

      (expected_return_on_date..returned_at_date).each { |date| past_due_items_data[date.to_s] += 1 }
    end

    result [
      {name: "Checked Out Items (count)", data: checked_out_item_data},
      {name: "Past Due Items (count)", data: past_due_items_data}
    ]
  end
end
