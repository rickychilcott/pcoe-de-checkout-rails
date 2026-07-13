Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  constraints(AdminConstraint) do
    mount_avo

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

Avo::Engine.routes.draw do
  get "import_customers_download_template", to: "tools#import_customers_download_template", as: :import_customers_download_template
  get "import_items_download_template", to: "tools#import_items_download_template", as: :import_items_download_template
end
