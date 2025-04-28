class Avo::Actions::ExportActivities < Avo::BaseAction
  self.name = "Export Activities to CSV"
  self.no_confirmation = true
  self.standalone = true

  def fields
    field :start_date, as: :date, required: true, default: -> { Activity.minimum(:occurred_at) }
    field :end_date, as: :date, required: true, default: -> { Activity.maximum(:occurred_at) }
  end

  def handle(records:, fields:, resource:, **args)
    activities =
      Activity
        .where(occurred_at: fields[:start_date]..fields[:end_date])
        .includes(:actor, :facilitator)

    # attributes = Activity.column_names.without("id", "created_at", "updated_at", "record_gids", "actor_id", "facilitator_id")
    attributes = ["action", "occurred_on", "occurred_at", "actor", "facilitator", "records"]

    file = CSV.generate(headers: true) do |csv|
      csv << attributes

      activities.each do |record|
        csv << attributes.map do |attr|
          format_result record.send(attr)
        end
      end
    end

    succeed "Done!"
    download file, "activities.csv"
  end

  def format_result(result)
    if result.is_a?(ActiveSupport::TimeWithZone) || result.is_a?(Date)
      result.to_formatted_s(:db)
    elsif result.is_a?(String)
      result
    elsif result.is_a?(Array)
      result.map { |r| format_result(r) }.join("; ")
    elsif result.respond_to?(:title)
      [result.class, result.title].join(": ")
    else
      raise "Unknown type: #{r.class}"
    end
  end
end
