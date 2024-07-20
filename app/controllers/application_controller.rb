class ApplicationController < ActionController::Base
  # before_action :authenticate_user!, unless: :page_controller?

  # def page_controller?
  #   params[:controller] == "pages"
  # end

  def after_sign_in_path_for(resource)
    avo_path
  end
end
