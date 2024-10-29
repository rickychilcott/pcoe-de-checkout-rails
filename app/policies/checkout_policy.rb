class CheckoutPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def act_on? = true

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      # TODO: Scope to group?
      scope.all
    end
  end
end
