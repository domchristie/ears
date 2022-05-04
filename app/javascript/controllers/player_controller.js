import { Controller } from '@hotwired/stimulus'
import { formatDuration } from 'helpers/time-helpers'

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
    'remainingField',
    'timerIcon',
    'remainingInWords',
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
    const remaining = Math.max(this.duration - this.currentTime, 0)

    this.ifApplicable(this.elapsedTargets, t => {
      t.textContent = formatDuration(this.currentTime, 'display')
      t.setAttribute('datetime', formatDuration(this.currentTime))
    })

    this.ifApplicable(this.remainingTargets, t => {
      t.textContent = '-' + formatDuration(remaining, 'display')
      t.setAttribute('datetime', formatDuration(remaining))
    })

    this.ifApplicable(this.timerIconTargets, t => {
      t.style.setProperty('--progress', this.currentTime / this.duration)
    })

    this.ifApplicable(this.remainingInWordsTargets, t => {
      t.textContent = remaining > 60
        ? `${formatDuration(remaining, 'words')} left`
        : 'Played'
      t.setAttribute('datetime', formatDuration(remaining))
    })
  }

  updateProgress () {
    const progress = this.currentTime / this.duration
    this.ifApplicable(this.progressTargets, t => {
      t.value = progress
      t.style.setProperty('--progress', progress)
    })
  }

  controlsTargetConnected () {
    this._controlsLoaded?.call()
  }

  trackElapsed () {
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

  ifApplicable (targets, callback) {
    targets.forEach(t => {
      if (this.targetApplicable(t)) callback.call(this, t)
    })
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
