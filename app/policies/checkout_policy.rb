class CheckoutPolicy < ApplicationPolicy
  def index? = super || in_any_group?

  def show? = super || in_any_group?

  def create? = false

  def update? = false

  def destroy? = false

  def return? = super_admin? || in_items_group?

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
