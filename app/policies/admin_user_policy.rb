class AdminUserPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def create? = super

  def update? = super

  def destroy? = super

  def attach_admin_group? = false

  def detach_admin_group? = false

  def edit_admin_group? = super_admin?

  def create_admin_group? = super_admin?

  def destroy_admin_group? = super_admin?

  def act_on_admin_group? = super_admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
