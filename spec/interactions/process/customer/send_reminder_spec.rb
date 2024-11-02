require "rails_helper"

RSpec.describe Process::Customer::SendReminder do
  let(:customer) { create(:customer) }
  let(:admin_user) { create(:admin_user) }
  let(:body) { "This is a reminder message" }

  subject(:interaction) do
    described_class.run(
      customer: customer,
      admin_user: admin_user,
      body: body
    )
  end

  it "sends an email" do
    expect { interaction }.to have_enqueued_mail(
      CustomerMailer,
      :reminder_email
    ).with(
      admin_user:,
      customer:,
      body:
    )
  end

  it "logs activity" do
    interaction

    activity = Activity.find_by(action: "customer_reminder_sent")
    expect(activity.actor).to eq(customer)
    expect(activity.facilitator).to eq(admin_user)
    expect(activity.extra).to eq({"body" => body})
  end

  describe "validations" do
    it "requires a customer" do
      result = described_class.run(
        customer: nil,
        admin_user: admin_user,
        body: body
      )
      expect(result.errors.messages_for(:customer)).to include("is required")
    end

    it "requires an admin_user" do
      result = described_class.run(
        customer: customer,
        admin_user: nil,
        body: body
      )
      expect(result.errors.messages_for(:admin_user)).to include("is required")
    end

    it "requires a body" do
      result = described_class.run(
        customer: customer,
        admin_user: admin_user,
        body: nil
      )
      expect(result.errors.messages_for(:body)).to include("is required")
    end
  end
end
