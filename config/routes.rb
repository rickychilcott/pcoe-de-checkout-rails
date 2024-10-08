Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  constraints(AdminConstraint) do
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  devise_for :admin_users

  root "page#home"
end

if defined? ::Avo
  Avo::Engine.routes.draw do
    get "import_items_download_template", to: "tools#import_items_download_template", as: :import_items_download_template
    get "past_due", to: "tools#past_due", as: :past_due
    get "checked_out", to: "tools#checked_out", as: :checked_out

    scope :resources do
      # Add route for the skills_for_user action
      get "items/not_checked_out_items", to: "items#not_checked_out_items"
    end
  end
end
