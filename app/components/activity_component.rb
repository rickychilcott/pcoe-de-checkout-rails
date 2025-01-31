class ActivityComponent < ApplicationComponent
  prop :activity, Activity, reader: :private

  def view_template
    upper do
      plain action_label
      plain " to ".freeze
      link_to actor_title, actor
    end

    middle do
      plain "Facilitated by ".freeze
      plain facilitator_name
      time
      br
    end

    lower do
      activity_details
    end
  end

  private

  delegate :action, :actor, :facilitator, :occurred_at, :records, to: :activity
  delegate :title, to: :actor, prefix: true
  delegate :name, to: :facilitator, prefix: true

  def upper(&)
    div(class: "fs-6", &)
  end

  def middle(&)
    div(class: "text-muted fs-6", &)
  end

  def lower(&)
    div(class: "text-muted fs-7", &)
  end

  def action_label
    Activity.label_for_action(action)
  end

  def time
    plain " (".freeze
    plain time_ago_in_words(occurred_at)
    plain " ago)".freeze
  end

  def activity_details
    details do
      summary do
        plain "Record Details".freeze
      end
      ul do
        records.each do |record|
          li do
            link_to record.title, record
          end
        end
      end
    end
  end
end
