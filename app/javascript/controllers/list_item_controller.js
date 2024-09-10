import { Controller } from '@hotwired/stimulus'

export default class ListItemController extends Controller {
  select() {
    this.element.dataset.selected = true
  }

  deselect (event) {
    delete this.element.dataset.selected
  }

  disconnect() {
    this.deselect()
  }
}
