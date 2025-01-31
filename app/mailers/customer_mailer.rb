class CustomerMailer < ApplicationMailer
  SMTP_USER = ENV.fetch("SMTP_USER", "coe-projrms-sa@ohio.edu")
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.reminder_email.subject
  #
  def reminder_email(admin_user:, customer:, body:)
    mail(
      to: email_address_with_name(customer.email, customer.name),
      reply_to: [
        email_address_with_name(admin_user.email, admin_user.name),
        SMTP_USER
      ],
      subject: "Reminder: #{customer.name}",
      body:
    )
  end
end
