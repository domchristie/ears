// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import LocalTime from "local-time"
LocalTime.start()

;(function () {
  // Fix buttons becoming re-enabled during response processing
  let submitter = null
  addEventListener('turbo:submit-end', function (event) {
    submitter = event.detail.formSubmission.submitter
    submitter && (submitter.disabled = true)
  })
  addEventListener('turbo:before-cache', function () {
    submitter && (submitter.disabled = false)
    submitter = null
  })
})()

// Frame View Transitions
addEventListener('turbo:before-frame-render', function (event) {
  if (document.startViewTransition) {
    const render = event.detail.render
    event.detail.render = function (currentElement, newElement) {
      document.startViewTransition(_ => render(currentElement, newElement))
    }
  }
})

// Flag Turbo Requests
addEventListener('turbo:before-fetch-request', function ({ detail }) {
  detail.fetchOptions.headers['Turbo-Request'] = 1
})
