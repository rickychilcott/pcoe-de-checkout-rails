class CustomerMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.reminder_email.subject
  #
  def reminder_email(admin_user:, customer:, body:)
    mail(
      to: email_address_with_name(customer.email, customer.name),
      from: email_address_with_name(admin_user.email, admin_user.name),
      subject: "Reminder: #{customer.name}",
      body:
    )
  end
end
