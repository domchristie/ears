
import { Controller } from '@hotwired/stimulus'

export default class ExternalContentController extends Controller {
  connect () {
    this.anchors.forEach(this.addTarget)
  }

  get anchors () {
    return [...this.element.querySelectorAll('a')]
  }

  addTarget (a) {
    a.setAttribute('target', '_blank')
  }

  removeTarget (a) {
    a.removeAttribute('target')
  }

  disconnect () {
    this.anchors.forEach(this.removeTarget)
  }
}
