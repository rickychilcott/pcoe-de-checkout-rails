class GroupPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def create? = super

  def update? = super

  def destroy? = super

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
