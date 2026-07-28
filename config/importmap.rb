# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"

pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "turbo_power" # @0.8.0
# turbo_power 0.8 side-effect-imports "@hotwired/turbo"; resolve it to the
# copy turbo-rails already serves so Turbo initializes exactly once.
pin "@hotwired/turbo", to: "turbo.min.js"
