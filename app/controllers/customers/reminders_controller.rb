class Customers::RemindersController < ApplicationController
  def new
    customer = Customer.find(params[:customer_id])

    reminder = Reminder.new(
      customer: customer,
      admin_user: current_admin_user
    )

    render :new, locals: {customer:, reminder:}
  end

  def create
    admin_user = current_admin_user
    body = params[:reminder][:body]
    customer = Customer.find(params[:customer_id])
    reminder = Reminder.new({customer:, admin_user:, body:})

    if reminder.valid?
      Process::Customer::SendReminder.run!(
        customer:,
        admin_user:,
        body:
      )
      # Handle the reminder creation here
      # This might involve sending an email, creating a notification, etc.
      redirect_to customer, notice: "Reminder was sent to #{customer.name}."
    else
      render :new, locals: {customer:, reminder:}
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:to, :from, :body)
  end
end
