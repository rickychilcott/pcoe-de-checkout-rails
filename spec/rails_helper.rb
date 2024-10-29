# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "capybara/rspec"
require "capybara/cuprite"
require "axe-rspec"

Capybara.default_max_wait_time = 5
Capybara.disable_animation = true

Rails.root.glob("spec/support/**/*.rb").sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join("spec/fixtures")
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do
    driven_by(:cuprite, screen_size: [1440, 810], options: {
      js_errors: true,
      headless: %w[0 false].exclude?(ENV["HEADLESS"]),
      slowmo: ENV["SLOWMO"]&.to_f,
      process_timeout: 15,
      timeout: 10
    })
  end

  config.before(:each) do
    Current.reset
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.filter_gems_from_backtrace("capybara", "cuprite", "ferrum")

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :system

  config.include ActiveSupport::Testing::TimeHelpers
end
