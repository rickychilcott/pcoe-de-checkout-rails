class ApplicationController < ActionController::Base
  include CurrentAttributeSetters
  include Pundit::Authorization

  before_action :authenticate_admin_user!

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def pundit_user = current_admin_user
end
