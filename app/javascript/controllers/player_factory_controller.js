import { Controller } from '@hotwired/stimulus'

const html = document.documentElement

export default class extends Controller {
  initialize (event) {
    this.#createPlayer()
  }

  destroyPlayerIfBlank ({ detail: { newBody }}) {
    if (!newBody.querySelector(`#${this.element.id}`)) this.#destroyPlayer()
  }

  #createPlayer () {
    html.dataset.controller += ' player bridge--player'
  }

  #destroyPlayer () {
    html.dataset.controller = html.dataset.controller.replace(' player bridge--player', '')
  }
}
