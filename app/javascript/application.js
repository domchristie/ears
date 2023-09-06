// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import LocalTime from "local-time"
LocalTime.start()

// clear cache after both turbo-frame and turbo-stream form submissions
// https://github.com/hotwired/turbo/issues/554#issuecomment-1078479296
;(function () {
  const FetchMethod = { get: 0 }
  document.addEventListener('turbo:submit-end', async ({ detail }) => {
    const shouldClearCache = (
      detail.success &&
      await detail.fetchResponse?.responseHTML &&
      detail.formSubmission.fetchRequest.method !== FetchMethod.get
    )
    if (shouldClearCache) Turbo.cache.clear()
  })

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
