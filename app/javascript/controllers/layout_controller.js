import { Controller } from '@hotwired/stimulus'

export default class LayoutController extends Controller {
  static targets = ['observable', 'respondable']

  initialize () {
    this.observer = new IntersectionObserver(this.#observed)
  }

  connect () {
    this.observableTargets.forEach(t => this.observer.observe(t))
  }

  scrollToTop () {
    window.scroll({ top: 0, behavior: 'smooth' })
  }

  #observed = (entries) => {
    const respondables = this.respondableTargets
    entries.forEach(entry => {
      const relevants = respondables.filter(element =>
        element.dataset.activeWhen.split(':')[0] === entry.target.id
      )

      const state = entry.isIntersecting ? 'visible' : 'invisible'
      relevants.forEach(element => {
        if (element.dataset.activeWhen.split(':')[1] === state) {
          element.dataset.active = true
        } else {
          delete element.dataset.active
        }
      })
    })
  }
}
