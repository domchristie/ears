import { Controller } from '@hotwired/stimulus'

export default class BackController extends Controller {
  back (event) {
    document.documentElement.dataset.animateRestore = true
    window.addEventListener('turn:enter', () => {
      document.documentElement.removeAttribute('data-animate-restore')
    }, { once: true })

    if (this.#shouldRestore) {
      event.preventDefault()
      window.history.back()
    }
  }

  get #shouldRestore () {
    return !this.#isFirstHistoryEntry
  }

  get #isFirstHistoryEntry () {
    return !window.history.state.turbo ||
      window.history.state.turbo.restorationIndex === 0
  }
}
