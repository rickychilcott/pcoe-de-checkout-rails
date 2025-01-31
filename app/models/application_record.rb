class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object = nil)
    # List only the attributes you want to be searchable
    column_names & []  # Empty array means no attributes are searchable by default
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end

  def self.policy_class
    "#{self}Policy".constantize
  end

  def self.resolved_policy_scope_for(...)
    all.resolved_policy_scope_for(...)
  end

  def title
    try(:name) || try(:description) || try(:id)
  end
end
