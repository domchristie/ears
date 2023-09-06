import { Controller } from '@hotwired/stimulus'
import Turn from '@domchristie/turn'
let started = false

export default class PageTransitionsController extends Controller {
  connect () {
    if (!started) {
      Turn.start()
      started = true
    }
  }
}
