import { Controller } from '@hotwired/stimulus'
import debounce from 'lodash.debounce'

export default class LiveSearchController extends Controller {
  static targets = ['form', 'input', 'cancel']

  initialize () {
    this.search = debounce(this.search, 300).bind(this)
  }

  connect () {
    this.setCancelWidth()
    this.setQuery()
  }

  search () {
    this.formTarget.requestSubmit()
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
}
