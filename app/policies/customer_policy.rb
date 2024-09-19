class CustomerPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def create? = true

  def update? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      # TODO: Scope to group?
      scope.all
    end
  end
end
