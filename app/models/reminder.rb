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
        Hi #{customer.name},

        We are writing to remind you that you have items that are past due:

        #{past_due}

        In addition, you have items that are not yet past due:

        #{not_past_due}

        Please return the past due items as soon as possible and any items you're not currently using.

        Thank you,
      BODY
    )
  end

  private

  def markdownify(body)
    Kramdown::Document.new(body.strip).to_html
  end

  def past_due
    return if past_due_checkouts.blank?

    <<~PAST_DUE
      As a reminder, the items you have checked out are:

      #{checkouts_list(past_due_checkouts)}
    PAST_DUE
  end

  def not_past_due
    return if not_past_due_checkouts.blank?

    <<~NOT_PAST_DUE
      Additionally, you have other checkouts that are still out but are not yet past due:

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
