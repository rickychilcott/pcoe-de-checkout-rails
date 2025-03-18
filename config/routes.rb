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
  get "past_due", to: "tools#past_due", as: :past_due
  get "checked_out", to: "tools#checked_out", as: :checked_out

  scope :resources do
    # Add route for the skills_for_user action
    get "items/not_checked_out_items", to: "items#not_checked_out_items"
  end
end
