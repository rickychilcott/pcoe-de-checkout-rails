class Bravo::Resources::Activity < Bravo::BaseResource
  self.includes = [:actor, :facilitator]

  def fields
    field :action, as: :text, readonly: true do
      link_to record.action, bravo_resource_path("activities", record.id)
    end

    field :actor, as: :belongs_to, readonly: true
    field :facilitator, as: :belongs_to, readonly: true
    field :occurred, as: :text, readonly: true do
      time_ago_in_words(record.occurred_at) + " ago"
    end
    field :extra, as: :key_value, readonly: true, show_on: [:show]
  end
end
