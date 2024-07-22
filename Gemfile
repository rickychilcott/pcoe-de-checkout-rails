source "https://rubygems.org"

ruby file: ".ruby-version"

gem "ancestry"
gem "avo", ">= 3.2"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise", "~> 4.9"
gem "image_processing", "~> 1.2"
gem "importmap-rails"
gem "pagy", "~> 8.0"
gem "puma", ">= 5.0"
gem "rails", "7.2.0.beta3"
gem "rqrcode", "~> 2.0"
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
  gem "cuprite"
  gem "factory_bot_rails"
  gem "faker"
end
