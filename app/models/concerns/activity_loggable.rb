module ActivityLoggable
  extend ActiveSupport::Concern

  NoRecordError = Class.new(StandardError)

  included do
    if ancestors.include?(ApplicationRecord)
      has_many(:activities, as: :record)
    end
  end

  def activities
    Activity
      .includes(:actor, :facilitator)
      .matching_record_gid(
        to_global_id
      )
  end

  def record_activity!(action, actor:, facilitator:, records: nil, extra: {}, throttle_within: nil)
    records ||= [self] if is_a?(ApplicationRecord)

    raise NoRecordError, "No record provided" if records.blank?

    kwargs = {action: action.to_s, records:, actor:, facilitator:}

    if throttle_within.present?
      existing = events.find_by(
        **kwargs,
        occurred_at: throttle_within.ago..
      )

      return existing if existing&.touch(:occurred_at)
    end

    extra = default_extras.merge(extra.symbolize_keys)

    Activity.create!(**kwargs, extra:, occurred_at: Time.current)
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
