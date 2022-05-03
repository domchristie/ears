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
    console.log("turbo:submit-end")
    const nonGetFetch = detail.formSubmission.fetchRequest.method !== FetchMethod.get
    const responseHTML = await detail.fetchResponse.responseHTML
    if (detail.success && nonGetFetch && responseHTML) {
      console.log("clearing")
      Turbo.clearCache()
    }
  })
})()
