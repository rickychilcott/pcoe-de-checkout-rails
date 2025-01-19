class ApplicationController < ActionController::Base
  include CurrentAttributeSetters
  include Pundit::Authorization

  protect_from_forgery with: :exception, prepend: true
  before_action :authenticate_admin_user!

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def pundit_user = current_admin_user

  def resolved_policy_scope(klass_or_scope)
    klass_or_scope.resolved_policy_scope_for(current_admin_user)
  end
  helper_method :resolved_policy_scope
end
