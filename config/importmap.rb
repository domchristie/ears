# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "local-time", to: "https://ga.jspm.io/npm:local-time@2.1.0/app/assets/javascripts/local-time.js"
pin_all_from "app/javascript/helpers", under: "helpers"
pin "humanize-duration", to: "https://ga.jspm.io/npm:humanize-duration@3.27.3/humanize-duration.js"
pin "lodash.debounce", to: "https://ga.jspm.io/npm:lodash.debounce@4.0.8/index.js"
pin "@domchristie/turn", to: "https://ga.jspm.io/npm:@domchristie/turn@2.1.0/dist/turn.min.js"
pin "@honeybadger-io/js", to: "https://ga.jspm.io/npm:@honeybadger-io/js@6.2.0/dist/browser/honeybadger.js"
