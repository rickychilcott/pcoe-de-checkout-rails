require "rails_helper"

RSpec.describe CustomerMailer do
  describe "#reminder_email" do
    it "sends a multipart email rendering the rich body as HTML with a plain text alternative" do
      admin_user = create(:admin_user, email: "admin@example.com")
      customer = create(:customer, name: "Sally Smith")
      body = "<div>Hi Sally,<br><br></div><ul><li>camera due 2025-02-17</li></ul>"

      mail = described_class.reminder_email(admin_user:, customer:, body:)

      expect(mail.subject).to eq("Reminder: Sally Smith")
      expect(mail.to).to eq([customer.email])
      expect(mail.reply_to).to eq(["admin@example.com"])

      expect(mail.html_part.body.to_s).to include("<li>camera due 2025-02-17</li>")
      expect(mail.text_part.body.to_s).to include("camera due 2025-02-17")
      expect(mail.text_part.body.to_s).not_to include("<li>")
    end
  end
end
