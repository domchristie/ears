// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'
import LocalTime from 'local-time'
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

// Service Worker
if (navigator.serviceWorker) {
  // Clear out old registrations
  navigator.serviceWorker.getRegistrations().then((regs) => {
    regs.forEach((reg) => {
      const wrongScope = !/app(\.local)?\/$/.test(reg.scope)
      const oldUrl = /serviceworker.js$/.test(reg.active?.scriptURL)
      if (wrongScope || oldUrl) reg.unregister()
    })
  })

  navigator.serviceWorker.register('/service-worker.js').then(function () {
    console.log('[Page] Service worker registered!')
  })
}
