import { Controller } from '@hotwired/stimulus'

export default class BackController extends Controller {
  back (event) {
    event.preventDefault()
    window.history.back()
  }
}
