class ActivityPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def create? = false

  def update? = false

  def destroy? = false

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
