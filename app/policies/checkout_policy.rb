class CheckoutPolicy < ApplicationPolicy
  def index? = super || user.groups.any?

  def show? = super || user.groups.any?

  def create? = false

  def update? = false

  def destroy? = false

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.joins(:item).where(item: {group: user.groups})
      end
    end
  end
end
