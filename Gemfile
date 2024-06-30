source "https://rubygems.org"

ruby "3.2.0"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sprockets-rails"
gem "sqlite3", "~> 2"
gem "stimulus-rails"
gem "turbo-rails"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1.0"
end

group :development do
  gem "rack-mini-profiler"
  gem "standardrb"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "faker"
  gem "selenium-webdriver"
end
