class ApplicationController < ActionController::Base
  include CurrentAttributeSetters

  before_action :authenticate_admin_user!

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
