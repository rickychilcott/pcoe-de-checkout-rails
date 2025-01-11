class CustomerPolicy < ApplicationPolicy
  def index? = super || user.groups.any?

  def show? = super || user.groups.any?

  def show_pid? = super_admin?

  def create? = super || user.groups.any?

  def update? = super || user.groups.any?

  def destroy? = super || user.groups.any?

  def upload_csv_file? = super_admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
