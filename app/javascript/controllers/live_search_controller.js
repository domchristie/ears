import { Controller } from '@hotwired/stimulus'
import { debounce } from 'helpers/debounce-helpers'

export default class LiveSearchController extends Controller {
  static targets = ['form', 'input', 'cancel']

  connect () {
    this.setCancelWidth()
    this.setQuery()
  }

  cancel () {
    this.inputTarget.value = ''
    this.setQuery()
  }

  setQuery () {
    this.formTarget.dataset.query = this.inputTarget.value
  }

  setCancelWidth () {
    this.cancelTarget.style.setProperty(
      '--width',
      `${this.cancelTarget.clientWidth}px`
    )
  }

  search = debounce(() => { this.formTarget.requestSubmit() }, 300)
}
