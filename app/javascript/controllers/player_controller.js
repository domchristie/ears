import { Controller } from '@hotwired/stimulus'
import { formatDuration } from '../helpers/time-helpers'

export default class PlayerController extends Controller {
  static targets = [
    'audio',
    'controls',
    'toggle',
    'loader',
    'elapsed',
    'remaining',
    'progress',
    'playForm',
    'elapsedField',
    'remainingField'
  ]

  initialize () {
    this.persistElapsedLater = throttle(_ => this.persistElapsed(), 20000)
    this.updateTimeLater = throttle(_ => this.updateTime(), 1000)
    this.updateTime()
  }

  get duration () {
    return this.audioTarget?.duration || 0
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

  updateTime () {
    this.elapsedTarget.textContent = formatDuration(this.currentTime, 'display')
    this.elapsedTarget.setAttribute('datetime', formatDuration(this.currentTime))
    const remaining = Math.max(this.duration - this.currentTime, 0)
    this.remainingTarget.textContent = '-' + formatDuration(remaining, 'display')
    this.remainingTarget.setAttribute('datetime', formatDuration(remaining))
  }

  updateProgress () {
    const progress = this.currentTime / this.duration
    this.progressTarget.value = progress
    this.progressTarget.style.setProperty('--progress', progress)
  }

  controlsTargetConnected () {
    this._controlsLoaded?.call()
  }

  trackProgress () {
    this.elapsedFieldTarget.value = this.currentTime
    this.remainingFieldTarget.value = Math.max(
      this.duration - this.currentTime,
      0
    )
    if (!this.audioTarget.paused) this.persistElapsedLater()
  }

  persistElapsed () {
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

function throttle (fn, delay) {
  let lastCalled = 0
  return function (...args) {
    let now = new Date().getTime()
    if (now - lastCalled < delay) return
    lastCalled = now
    return fn(...args)
  }
}
