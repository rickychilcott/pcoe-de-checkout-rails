require "rails_helper"

RSpec.describe Bravo::Cards::CheckoutsChart do
  it "counts checkouts older than the selected range without crashing" do
    admin = create(:admin_user, :super_admin)
    create(:checkout, checked_out_at: 60.days.ago, expected_return_on: 45.days.ago.to_date)

    card = described_class.new(current_user: admin, range: "30")

    data = card.query
    checked_out = data.find { |series| series[:name] == "Checked Out Items (count)" }[:data]
    past_due = data.find { |series| series[:name] == "Past Due Items (count)" }[:data]

    # The chart window starts 30 days ago; the still-out checkout from 60
    # days ago counts on every day inside the window, none before it.
    expect(checked_out.keys.min).to eq(30.days.ago.to_date.to_s)
    expect(checked_out[Date.current.to_s]).to eq(1)
    expect(past_due[Date.current.to_s]).to eq(1)
  end
end
