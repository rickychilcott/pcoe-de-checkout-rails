Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  constraints(AdminConstraint) do
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  devise_for :admin_users

  root "page#home"
end
