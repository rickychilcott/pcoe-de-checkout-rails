class Reminder
  include ActiveModel::Model

  attr_accessor :customer, :admin_user
  attr_writer :body

  validates :admin_user, presence: true
  validates :customer, presence: true

  delegate :email_address_with_name, to: ActionMailer::Base

  def to = email_address_with_name(customer.email, customer.name)

  def from = email_address_with_name(admin_user.email, admin_user.name)

  def body
    @body ||= markdownify(
      <<~BODY
        Dear #{customer.name},

        Our records indicate that technology equipment checked out through the Center for Technology and Online Programs (CTOP) is currently past due for return.

        #{past_due_item_info}

        #{not_past_due_item_info}

        Please return the equipment to CTOP as soon as possible. If you believe the equipment has already been returned, please contact us so we can double check our records.

        Failure to return university-owned equipment may result in a hold being placed on your record until the equipment is returned or other arrangements have been made.

        If you have questions or need assistance coordinating the return, please contact us at ctop@ohio.edu.

        Thank you for your prompt attention to this matter.

        Center for Technology and Online Programs
      BODY
    )
  end

  private

  def markdownify(body)
    ConvertMarkdown.run!(text: body.strip)
  end

  def past_due_item_info
    return if past_due_checkouts.blank?

    <<~PAST_DUE
      Past due items:

      #{checkouts_list(past_due_checkouts)}
    PAST_DUE
  end

  def not_past_due_item_info
    return if not_past_due_checkouts.blank?

    <<~NOT_PAST_DUE
      Additionally, the following items are still checked out but not yet past due:

      #{checkouts_list(not_past_due_checkouts)}
    NOT_PAST_DUE
  end

  def checkouts_list(checkouts)
    checkouts
      .map do |checkout|
      checkout_item = checkout.item

      "- #{checkout_item.name} due #{checkout.expected_return_on}"
    end
      .join("\n")
  end

  def past_due_checkouts
    customer.current_checkouts.select(&:past_due?)
  end

  def not_past_due_checkouts
    customer.current_checkouts.reject(&:past_due?)
  end
end
