import { Controller } from '@hotwired/stimulus'

export default class PlayerController extends Controller {
  initialize () {
    this.throttledPersistProgress = throttle(
      () => this.persistProgress(),
      20000
    )
  }

  get duration () {
    return this.audioTarget.duration
  }

  get currentTime () {
    return this.audioTarget?.currentTime || 0
  }

  async toggle (event) {
    event.preventDefault()

    if (this.targetApplicable(event.currentTarget)) {
      this.audioTarget[this.audioTarget.paused ? 'play' : 'pause']()
    } else {
      this.audioTarget.src = event.currentTarget.dataset.href
      await this.loadNewControls()
      this.audioTarget.play()
    }
  }

  skipBack () {
    this.audioTarget.currentTime -= 15
  }

  skipForward () {
    this.audioTarget.currentTime += 30
  }

  updateToggles () {
    this.toggleTargets.forEach((target) => {
      if (this.targetApplicable(target)) {
        target.classList.toggle('--playing', !this.audioTarget.paused)
      }
    })
  }

  controlsTargetConnected () {
    this._controlsLoaded?.call()
  }

  trackProgress () {
    this.progressFieldTarget.value = this.currentTime
    this.remainingFieldTarget.value = Math.max(
      this.duration - this.currentTime,
      0
    )
    if (!this.audioTarget.paused) this.throttledPersistProgress()
  }

  persistProgress () {
    this.dispatch('submit', { target: this.playFormTarget, prefix: '' })
  }

  targetApplicable (target) {
    return requestUrl(target.dataset.href) === requestUrl(this.audioTarget.src)
  }

  loadNewControls () {
    const promise = new Promise(resolve => this._controlsLoaded = resolve)
    this.loaderTarget.click()
    return promise
  }
}

function requestUrl (url) {
  return url.split("#")[0]
}

PlayerController.targets = [
  'audio',
  'controls',
  'toggle',
  'loader',
  'playForm',
  'progressField',
  'remainingField'
]

PlayerController.values = {
  duration: Number
}

function throttle (fn, delay) {
  let lastCalled = 0
  return function (...args) {
    let now = new Date().getTime()
    if (now - lastCalled < delay) return
    lastCalled = now
    return fn(...args)
  }
}
