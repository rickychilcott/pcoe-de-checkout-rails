module ActiveRecord::Relation::PunditPolicyHelper
  extend ActiveSupport::Concern

  def policy_scope_for(user)
    model.policy_class::Scope.new(user, self)
  end

  def resolved_policy_scope_for(...)
    policy_scope_for(...).resolve
  end
end

ActiveRecord::Relation.include(ActiveRecord::Relation::PunditPolicyHelper)
