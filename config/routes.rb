Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  constraints(AdminConstraint) do
    namespace :bravo, path: "admin" do
      root to: "dashboard#show"
      get "dashboards/home", to: "dashboard#show", as: :dashboard

      get "import_customers_download_template", to: "tools#import_customers_download_template", as: :import_customers_download_template
      get "import_items_download_template", to: "tools#import_items_download_template", as: :import_items_download_template

      scope "resources/:resource_name", constraints: {resource_name: /items|customers|checkouts|groups|locations|activities|admin_users/} do
        get "", to: "resources#index", as: :resources
        post "", to: "resources#create"
        get "new", to: "resources#new", as: :new_resource
        post "actions/:action_key", to: "resource_actions#create", as: :resource_action
        get ":id", to: "resources#show", as: :resource
        get ":id/edit", to: "resources#edit", as: :edit_resource
        patch ":id", to: "resources#update"
        put ":id", to: "resources#update"
        delete ":id", to: "resources#destroy"
        delete ":id/attachments/:attachment_id", to: "attachments#destroy", as: :resource_attachment
      end
    end

    resources :customers, only: [:index, :new, :create, :show] do
      resources :checkouts, only: [:create], module: :customers
      resources :returns, only: [:create], module: :customers
      resources :reminders, only: [:new, :create], module: :customers
    end

    scope "/cart" do
      get :add_items, to: "cart#add_items", as: :cart_add_items
      delete :remove_items, to: "cart#remove_items", as: :cart_remove_items
    end

    resources :items, only: [:index, :show]
    resources :checkouts, only: [:index, :show]
  end

  devise_for :admin_users

  root "page#home"
end
