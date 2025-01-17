class ApplicationController < ActionController::Base
  include CurrentAttributeSetters
  include Pundit::Authorization

  before_action :authenticate_admin_user!
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def pundit_user = current_admin_user
end
