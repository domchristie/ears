
import { Controller } from '@hotwired/stimulus'

const ACTION = 'external-content#openInNewWindow'

export default class ExternalContentController extends Controller {
  connect () {
    this.anchors.forEach(this.addAction)
  }

  get anchors () {
    return Array.from(this.element.querySelectorAll('a'))
  }

  addAction (a) {
    a.dataset.action = a.dataset.action || ''
    if (a.dataset.action.indexOf(ACTION) === -1) {
      a.dataset.action += ` ${ACTION}`
    }
  }

  removeAction (a) {
    a.dataset.action = a.dataset.action.replace(` ${ACTION}`, '')
  }

  openInNewWindow (event) {
    event.preventDefault()
    window.open(event.target.href, '_blank')
  }

  disconnect () {
    this.anchors.forEach(this.removeAction)
  }
}
