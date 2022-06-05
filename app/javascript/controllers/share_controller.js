import { Controller } from '@hotwired/stimulus'

export default class ShareController extends Controller {
  static values = { url: String, title: String }

  share (event) {
    if (this.supported) {
      event.preventDefault()
      navigator.share({ url: this.urlValue, title: this.titleValue })
    }
  }

  get supported () {
    return 'share' in window.navigator
  }
}
