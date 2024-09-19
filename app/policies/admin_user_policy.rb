class AdminUserPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def create? = user.super_admin?

  def update? = user.super_admin?

  def destroy? = user.super_admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      # TODO: Scope to super admins?
      scope.all
    end
  end
end
