class CheckoutGroupPolicy < ApplicationPolicy
  def index? = super || matching_group_ids?

  def show? = super || matching_group_ids?

  def create? = super || matching_group_ids?

  def update? = false

  def destroy? = false

  class Scope < ApplicationPolicy::Scope
    def resolve
      raise NotImplementedError
    end
  end

  private

  def matching_group_ids?
    record_items_group_ids.all? { _1.in?(user_group_ids) }
  end

  def user_group_ids
    user.groups.map(&:id)
  end

  def record_items_group_ids
    record.items.map(&:group_id)
  end
end
