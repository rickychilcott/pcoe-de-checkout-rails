module ActivityLoggable
  extend ActiveSupport::Concern

  included do
    has_many :activities, as: :record
  end

  def record_activity!(action, actor:, facilitator:, record: self, extra: {}, throttle_within: nil)
    kwargs = {action: action.to_s, record:, actor:, facilitator:}

    if throttle_within.present?
      existing = events.find_by(
        **kwargs,
        occurred_at: throttle_within.ago..
      )

      return existing if existing&.touch(:occurred_at)
    end

    extra = default_extras.merge(extra.symbolize_keys)

    activities.create!(**kwargs, extra:)
  end

  private

  def default_extras
    {
      request_id: Current.request_id,
      user_agent: Current.user_agent,
      ip_address: Current.ip_address
    }.compact
  end
end
