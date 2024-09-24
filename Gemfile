source "https://rubygems.org"

ruby file: ".ruby-version"

gem "active_interaction", "~> 5.3"
gem "active_interaction-extras"
gem "ancestry"
gem "avo", ">= 3.2"
gem "avo-advanced", ">= 3.2", source: "https://packager.dev/avo-hq/"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "csv"
gem "devise", "~> 4.9"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "pagy", "~> 9.0"
gem "puma", ">= 5.0"
gem "pundit", "~> 2.4"
gem "rails", "~> 7.2"
gem "ransack", "~> 4.2"
gem "rqrcode", "~> 2.0"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"

group :development, :test do
  gem "dotenv-rails"
  gem "annotate"
  gem "brakeman", "~> 6.1"
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1.0"
  gem "i18n-tasks"
end

group :development do
  gem "rack-mini-profiler"
  gem "standardrb"
  gem "web-console"
end

group :test do
  gem "axe-core-rspec", "4.9.0"
  gem "axe-core-api", "4.2.0"
  gem "axe-matchers", "2.6.1"
  gem "capybara"
  gem "cuprite"
  gem "factory_bot_rails"
  gem "faker"
end
