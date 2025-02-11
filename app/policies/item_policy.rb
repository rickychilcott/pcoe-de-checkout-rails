class ItemPolicy < ApplicationPolicy
  def index? = super || true

  def show? = super || true

  def create? = super || in_group?

  def update? = super || in_group?

  def destroy? = super || in_group?

  def act_on? = super

  def upload_csv_file? = super_admin?

  def upload_images? = super_admin? || in_group?

  def download_images? = super_admin? || in_group?

  def delete_images? = super_admin? || in_group?

  class Scope < ApplicationPolicy::Scope
    def resolve
      all_or_in_group
    end
  end
end
