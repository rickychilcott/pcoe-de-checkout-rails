# == Schema Information
#
# Table name: activities
#
#  id             :integer          not null, primary key
#  action         :string           not null
#  extra          :json             not null
#  occurred_at    :datetime         not null
#  record_type    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  actor_id       :integer
#  facilitator_id :integer          not null
#  record_id      :integer
#
# Indexes
#
#  index_activities_on_action          (action)
#  index_activities_on_actor_id        (actor_id)
#  index_activities_on_facilitator_id  (facilitator_id)
#  index_activities_on_record          (record_type,record_id)
#
# Foreign Keys
#
#  actor_id        (actor_id => customers.id)
#  facilitator_id  (facilitator_id => admin_users.id)
#
class Avo::Resources::Activity < Avo::BaseResource
  self.includes = [:actor, :record, :facilitator]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :action, as: :text, readonly: true, as_html: true do
      link_to record.action, avo.resources_activity_path(record)
    end
    field :record, as: :belongs_to, readonly: true, link_to_resource: true, polymorphic_as: :record, types: [::Item]
    field :actor, as: :belongs_to, readonly: true
    field :facilitator, as: :belongs_to, readonly: true
    field :extra, as: :key_value
  end
end
