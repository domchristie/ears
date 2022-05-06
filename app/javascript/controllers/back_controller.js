import { Controller } from '@hotwired/stimulus'
import Turn from 'turn'

export default class BackController extends Controller {
  back (event) {
    event.preventDefault()
    Turn.animateRestore = true
    window.history.back()
  }
}
