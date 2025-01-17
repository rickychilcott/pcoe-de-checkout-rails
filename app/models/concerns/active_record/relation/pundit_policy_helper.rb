module ActiveRecord::Relation::PunditPolicyHelper
  extend ActiveSupport::Concern

  def policy_scope_for(user)
    model.policy_class::Scope.new(user, self)
  end
end

ActiveRecord::Relation.include(ActiveRecord::Relation::PunditPolicyHelper)
