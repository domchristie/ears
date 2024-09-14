# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/models", under: "models"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/helpers", under: "helpers"
pin "local-time", to: "local-time.esm.js" # @2.1.0
pin "humanize-duration" # @3.29.0
pin "@domchristie/turn", to: "@domchristie--turn.js" # @2.1.0
pin "@honeybadger-io/js", to: "@honeybadger-io--js.js" # @6.4.1
