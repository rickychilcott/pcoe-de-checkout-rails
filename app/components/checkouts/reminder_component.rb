module Checkouts
  class ReminderComponent < ApplicationComponent
    def initialize(customer:)
      @customer = customer
    end

    def view_template
      link_to(new_customer_reminder_path(@customer), class: "ps-2") do
        render Phlex::Icons::Bootstrap::BellFill.new
      end
    end
  end
end
