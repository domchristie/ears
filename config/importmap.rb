# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "local-time", to: "https://ga.jspm.io/npm:local-time@2.1.0/app/assets/javascripts/local-time.js"
pin "turn", to: "turn.js"
pin_all_from "app/javascript/helpers", under: "helpers"
pin "humanize-duration", to: "https://ga.jspm.io/npm:humanize-duration@3.27.3/humanize-duration.js"
pin "@domchristie/turn", to: "https://ga.jspm.io/npm:@domchristie/turn@1.1.0/dist/turn.min.js"
