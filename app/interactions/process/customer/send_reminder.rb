class Process::Customer::SendReminder < ApplicationInteraction
  object :customer
  object :admin_user
  string :body

  def execute
    send_email
    log_activity
  end

  private

  def send_email
    CustomerMailer
      .reminder_email(admin_user:, customer:, body:)
      .deliver_later
  end

  def log_activity
    customer.record_activity!(
      :customer_reminder_sent,
      extra: {
        body:
      },
      actor: customer,
      facilitator: admin_user
    )
  end
end
