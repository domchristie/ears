import { Controller } from '@hotwired/stimulus'

export default class ChapterController extends Controller {
  static targets = ['progress']

  static values = {
    startTime: Number,
    endTime: Number,
  }

  update (event) {
    if (this.eventApplicable(event)) {
      this.progressTarget.value = this.progress(event.detail.currentTime)
      this.element.classList.add('--playing')
    } else {
      this.progressTarget.value = 0
      this.element.classList.remove('--playing')
    }
  }

  get duration () {
    return this.endTimeValue - this.startTimeValue
  }

  progress (time) {
    return (time - this.startTimeValue) / this.duration
  }

  eventApplicable ({ detail: { href, currentTime } }) {
    return (
      href === this.element.dataset.href &&
      currentTime >= this.startTimeValue &&
      currentTime < this.endTimeValue
    )
  }
}
