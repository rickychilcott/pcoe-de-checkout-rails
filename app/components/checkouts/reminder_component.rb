class Checkouts::ReminderComponent < ApplicationComponent
  prop :customer, Customer, reader: :private

  def view_template
    link_to(new_customer_reminder_path(customer),
      id: dom_id(customer, :remind),
      data: {turbo_frame: "_top"},
      class: "inline-flex items-center gap-1.5 rounded-md border border-primary-500 text-primary-600 px-3 py-1.5 text-xs font-semibold hover:bg-primary-50 transition-colors whitespace-nowrap") do
      render PhlexIcons::Bootstrap::BellFill.new(class: "size-4")
      plain "Remind"
    end
  end
end
