import { Controller } from '@hotwired/stimulus'
import debounce from 'lodash.debounce'

export default class LiveSearchController extends Controller {
  static targets = ['form', 'input', 'cancel']

  initialize () {
    this.search = debounce(this.search, 300).bind(this)
    this.#hideCancel()
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

  #hideCancel () {
    this.setCancelWidth()
    this.cancelTarget.classList.add('w-0')
  }
}
