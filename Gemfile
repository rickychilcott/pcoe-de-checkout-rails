source "https://rubygems.org"

ruby file: ".ruby-version"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"

group :development, :test do
  gem "brakeman", "~> 6.1"
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
