import { Controller } from '@hotwired/stimulus'

export default class BackController extends Controller {
  back () {
    document.documentElement.dataset.animateRestore = true
    window.addEventListener('turn:enter', () => {
      document.documentElement.removeAttribute('data-animate-restore')
    }, { once: true })
    window.history.back()
  }
}
