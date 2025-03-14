# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer_mailer
class CustomerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer_mailer/reminder_email
  def reminder_email
    CustomerMailer.reminder_email(
      admin_user: AdminUser.first,
      customer: Customer.first,
      body: "This is a reminder email."
    )
  end
end
