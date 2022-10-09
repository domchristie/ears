import { Controller } from '@hotwired/stimulus'

export default class BackController extends Controller {
  back (event) {
    event.preventDefault()
    document.body.dataset.turnOptions = JSON.stringify({
      animateRestore: true
    })
    window.history.back()
  }

  disconnect () {
    delete document.body.dataset.turnOptions
  }
}
