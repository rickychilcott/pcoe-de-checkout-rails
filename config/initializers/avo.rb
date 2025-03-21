# For more information regarding these settings check out our docs https://docs.avohq.io
# The values disaplayed here are the default ones. Uncomment and change them to fit your needs.
Avo.configure do |config|
  ## == Routing ==
  config.root_path = "/admin"
  # used only when you have custom `map` configuration in your config.ru
  # config.prefix_path = "/internal"

  # Where should the user be redirected when visiting the `/avo` url
  config.home_path = "/admin/dashboards/home"

  ## == Licensing ==
  config.license_key = ENV.fetch("AVO_LICENSE_KEY")

  ## == Set the context ==
  config.set_context do
    # Return a context object that gets evaluated within Avo::ApplicationController
  end

  ## == Authentication ==
  config.current_user_method = :current_admin_user
  config.current_user_resource_name = :current_admin_user
  config.sign_out_path_name = :destroy_admin_user_session_path
  # config.is_admin_method = :is_admin
  # config.is_developer_method = :is_developer
  # config.authenticate_with do
  # end

  ## == Authorization ==
  # config.authorization_methods = {
  #   index: 'index?',
  #   show: 'show?',
  #   edit: 'edit?',
  #   new: 'new?',
  #   update: 'update?',
  #   create: 'create?',
  #   destroy: 'destroy?',
  #   search: 'search?',
  # }
  # config.raise_error_on_missing_policy = false
  config.authorization_client = :pundit

  ## == Localization ==
  config.locale = :en

  ## == Resource options ==
  # config.resource_controls_placement = :right
  # config.model_resource_mapping = {}
  # config.default_view_type = :table
  # config.per_page = 24
  # config.per_page_steps = [12, 24, 48, 72]
  # config.via_per_page = 8
  # config.id_links_to_resource = false
  # config.pagination = -> do
  #   {
  #     type: :default,
  #     size: [1, 2, 2, 1],
  #   }
  # end

  ## == Response messages dismiss time ==
  # config.alert_dismiss_time = 5000

  ## == Number of search results to display ==
  # config.search_results_count = 8

  ## == Cache options ==
  ## Provide a lambda to customize the cache store used by Avo.
  ## We compute the cache store by default, this is NOT the default, just an example.
  # config.cache_store = -> {
  #   ActiveSupport::Cache.lookup_store(:solid_cache_store)
  # }
  # config.cache_resources_on_index_view = true
  ## permanent enable or disable cache_resource_filters, default value is false
  # config.cache_resource_filters = false
  ## provide a lambda to enable or disable cache_resource_filters per user/resource.
  # config.cache_resource_filters = -> { current_user.cache_resource_filters? }

  ## == Turbo options ==
  # config.turbo = -> do
  #   {
  #     instant_click: true
  #   }
  # end

  ## == Logger ==
  # config.logger = -> {
  #   file_logger = ActiveSupport::Logger.new(Rails.root.join("log", "avo.log"))
  #
  #   file_logger.datetime_format = "%Y-%m-%d %H:%M:%S"
  #   file_logger.formatter = proc do |severity, time, progname, msg|
  #     "[Avo] #{time}: #{msg}\n".tap do |i|
  #       puts i
  #     end
  #   end
  #
  #   file_logger
  # }

  ## == Customization ==
  config.app_name = "PCOE de Checkout"
  config.timezone = "EST"
  config.currency = "USD"
  # config.hide_layout_when_printing = false
  # config.full_width_container = false
  # config.full_width_index_view = false
  # config.search_debounce = 300
  # config.view_component_path = "app/components"
  # config.display_license_request_timeout_error = true
  # config.disabled_features = []
  # config.buttons_on_form_footers = true
  # config.field_wrapper_layout = true
  # config.resource_parent_controller = "Avo::ResourcesController"
  # config.click_row_to_view_record = false

  ## == Branding ==
  # config.branding = {
  #   colors: {
  #     background: "248 246 242",
  #     100 => "#CEE7F8",
  #     400 => "#399EE5",
  #     500 => "#0886DE",
  #     600 => "#066BB2",
  #   },
  #   chart_colors: ["#0B8AE2", "#34C683", "#2AB1EE", "#34C6A8"],
  #   logo: "/avo-assets/logo.png",
  #   logomark: "/avo-assets/logomark.png",
  #   placeholder: "/avo-assets/placeholder.svg",
  #   favicon: "/avo-assets/favicon.ico"
  # }

  ## == Breadcrumbs ==
  # config.display_breadcrumbs = true
  # config.set_initial_breadcrumbs do
  #   add_breadcrumb "Home", '/avo'
  # end

  # == Menus ==
  config.main_menu = -> do
    link "Main App", path: "/"

    section "Dashboards", icon: "avo/dashboards" do
      all_dashboards
    end

    section "Customers", icon: "heroicons/outline/academic-cap" do
      resource :customers, visible: -> { authorize current_admin_user, Customer, :index?, raise_exception: false }
    end

    section "Other Resources", icon: "avo/resources" do
      resource :items, visible: -> { authorize current_admin_user, Item, :index?, raise_exception: false }
      resource :locations, visible: -> { authorize current_admin_user, Location, :index?, raise_exception: false }
      resource :groups, visible: -> { authorize current_admin_user, Group, :index?, raise_exception: false }
      resource :admin_users
    end

    section "Checkouts", icon: "heroicons/outline/shopping-bag" do
      resource :checkouts, visible: -> { authorize current_admin_user, Checkout, :index?, raise_exception: false }
    end

    # section "Tools", icon: "avo/tools" do
    #   all_tools
    # end
  end

  config.profile_menu = -> do
    # link "Profile", path: "/avo/profile", icon: "heroicons/outline/user-circle"
  end
end

Rails.configuration.to_prepare do
  Avo::ApplicationController.include CurrentAttributeSetters
end
