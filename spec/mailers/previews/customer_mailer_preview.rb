# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer
class CustomerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer/reminder_email
  def reminder_email
    admin_user = AdminUser.first
    customer = Customer.joins(:checkouts).merge(Checkout.checked_out).first || Customer.first

    CustomerMailer.reminder_email(
      admin_user:,
      customer:,
      body: Reminder.new(customer:, admin_user:).body
    )
  end
end
