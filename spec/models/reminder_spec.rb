require "rails_helper"

RSpec.describe Reminder do
  it "renders the default body as HTML with past due and current items" do
    customer = create(:customer, name: "Sally Smith")
    admin_user = create(:admin_user)
    past_due = create(:checkout, customer:, item: create(:item, name: "Laptop"), expected_return_on: 2.days.ago.to_date)
    current = create(:checkout, customer:, item: create(:item, name: "Camera"), expected_return_on: 3.days.from_now.to_date)

    body = described_class.new(customer:, admin_user:).body

    expect(body).to include("<p>Hi Sally Smith,")
    expect(body).to include("past due")
    expect(body).to include("<li>#{past_due.item.name} due #{past_due.expected_return_on}</li>")
    expect(body).to include("<li>#{current.item.name} due #{current.expected_return_on}</li>")
  end

  it "renders a body without list items when nothing is checked out" do
    customer = create(:customer, name: "Sally Smith")
    admin_user = create(:admin_user)

    body = described_class.new(customer:, admin_user:).body

    expect(body).to include("<p>Hi Sally Smith,")
    expect(body).not_to include("<li>")
  end
end
