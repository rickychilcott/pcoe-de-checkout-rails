// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

import TurboPower from "turbo_power"
TurboPower.initialize(Turbo.StreamActions)

import "controllers"
import * as bootstrap from "bootstrap"

import "trix"
import "@rails/actiontext"
