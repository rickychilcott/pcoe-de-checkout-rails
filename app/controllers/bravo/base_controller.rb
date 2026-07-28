class Bravo::BaseController < ApplicationController
  include Pagy::Backend

  layout "bravo"

  rescue_from Pundit::NotAuthorizedError do
    redirect_to bravo_root_path, alert: "You are not authorized to perform this action."
  end
end
