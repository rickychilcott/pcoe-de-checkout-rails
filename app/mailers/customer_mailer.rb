class CustomerMailer < ApplicationMailer
  def reminder_email(admin_user:, customer:, body:)
    @body = body

    mail(
      to: email_address_with_name(customer.email, customer.name),
      reply_to: email_address_with_name(admin_user.email, admin_user.name),
      subject: "CTOP Equipment Return Reminder"
    )
  end
end
