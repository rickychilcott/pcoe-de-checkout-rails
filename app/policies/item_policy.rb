class ItemPolicy < ApplicationPolicy
  def index? = true

  def show? = true

  def create? = true

  def update? = true

  def destroy? = true

  def act_on? = true

  def upload_csv_file? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      # TODO: Scope to group?
      scope.all
    end
  end
end
