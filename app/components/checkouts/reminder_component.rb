class Checkouts::ReminderComponent < ApplicationComponent
  prop :customer, Customer, reader: :private

  def view_template
    link_to(new_customer_reminder_path(customer), id: dom_id(customer, :remind), class: "ps-2", data: {turbo_frame: "_top"}) do
      render PhlexIcons::Bootstrap::BellFill.new
    end
  end
end
