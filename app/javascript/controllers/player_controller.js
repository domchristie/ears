import { Controller } from '@hotwired/stimulus'
import {
  chronoDuration,
  iso8601Duration,
  humanDuration
} from 'helpers/time-helpers'

export default class PlayerController extends Controller {
  static targets = [
    'audio',
    'controls',
    'loader',
    'elapsed',
    'remaining',
    'progress',
    'playForm',
    'elapsedField',
    'remainingField',
    'play',
    'timerIcon',
    'remainingInWords',
  ]

  get ready () {
    return this.audioTarget && this.audioTarget.readyState >= 3
  }

  get playing () {
    return this.ready && !this.audioTarget.paused
  }

  get loading () {
    return !this.ready && !this.audioTarget.paused
  }

  get duration () {
    return this.audioTarget?.duration || 0
  }

  get currentTime () {
    return this.audioTarget?.currentTime || 0
  }

  get remaining () {
    return Math.max(this.duration - this.currentTime, 0)
  }

  get progress () {
    return this.currentTime / this.duration
  }

  get complete () {
    return 0.05 * this.duration > 60
      ? this.remaining < 60
      : this.progress > 0.95
  }

  // Actions

  async toggle (event) {
    event.preventDefault()

    if (this.targetApplicable(event.currentTarget)) {
      this.audioTarget[this.audioTarget.paused ? 'play' : 'pause']()
    } else {
      this.audioTarget.src = event.currentTarget.href
      this.audioTarget.load()
      await this.loadNewControls(this.findLoader(event.currentTarget))
      this.audioTarget.play()
    }
  }

  async skipToAndPlay (event) {
    event.preventDefault()

    if (this.targetApplicable(event.currentTarget)) {
      this.audioTarget.currentTime = event.params.time || 0.001
      if (this.audioTarget.paused) this.audioTarget.play()
    } else {
      this.audioTarget.src = event.currentTarget.href
      this.audioTarget.load()
      await this.loadNewControls(this.findLoader(event.currentTarget))
      this.audioTarget.play()
    }
  }

  skipBack (event = {}) {
    event.currentTarget?.focus()
    this.audioTarget.currentTime = Math.max(
      this.audioTarget.currentTime - 15,
      0
    )
  }

  skipForward (event = {}) {
    event.currentTarget?.focus()
    this.audioTarget.currentTime = Math.min(
      this.audioTarget.currentTime + 30,
      this.duration
    )
  }

  updateToggles () {
    if (document.visibilityState === 'hidden') return

    this.playTargets.forEach((target) => {
      if (this.targetApplicable(target)) {
        target.toggleAttribute('data-loading', this.loading)
        target.toggleAttribute('data-playing', this.playing)
      } else {
        target.removeAttribute('data-loading')
        target.removeAttribute('data-playing')
      }
    })
  }

  updatePlays () {
    if (document.visibilityState === 'hidden') return

    this.ifApplicable(this.playTargets, t => {
      t.setAttribute('data-started', true)
      t.toggleAttribute('data-playing', this.playing)
    })
  }

  updateTime () {
    if (document.visibilityState === 'hidden') return
    if (this.audioTarget.readyState < 2) return

    this.ifApplicable(this.elapsedTargets, t => {
      t.textContent = chronoDuration(this.currentTime)
      t.setAttribute('datetime', iso8601Duration(this.currentTime))
      t.setAttribute(
        'aria-label',
        `${humanDuration(this.currentTime)} elapsed`
      )
    })

    this.ifApplicable(this.remainingTargets, t => {
      t.textContent = '-' + chronoDuration(this.remaining, 'display')
      t.setAttribute('datetime', iso8601Duration(this.remaining))
      t.setAttribute('aria-label', `${humanDuration(this.remaining)} left`)
    })

    this.ifApplicable(this.playTargets, t => {
      t.toggleAttribute('data-played', this.complete)
    })

    this.ifApplicable(this.timerIconTargets, t => {
      t.style.setProperty('--progress', this.currentTime / this.duration)
    })

    this.ifApplicable(this.remainingInWordsTargets, t => {
      t.textContent = this.complete
        ? 'Played'
        : `${humanDuration(this.remaining, 'short')} left`
      t.setAttribute('datetime', iso8601Duration(this.remaining))
      t.setAttribute('aria-label', `${humanDuration(this.remaining)} left`)
    })
  }

  get updateTimeLater () {
    if (document.visibilityState === 'hidden') return

    return this._updateTimeLater = (
      this._updateTimeLater || throttle(_ => this.updateTime(), 250)
    )
  }

  updateProgress () {
    if (document.visibilityState === 'hidden') return

    const progress = this.currentTime / this.duration
    this.ifApplicable(this.progressTargets, t => {
      t.value = progress
      t.style.setProperty('--progress', progress)
    })
  }

  get shouldTrackPlayTime () {
    return this.hasElapsedFieldTarget
  }

  trackElapsed () {
    if (!this.shouldTrackPlayTime) return

    this.elapsedFieldTarget.value = this.currentTime
    this.remainingFieldTarget.value = Math.max(
      this.duration - this.currentTime,
      0
    )
    if (!this.audioTarget.paused) this.persistElapsedLater()
  }

  persistElapsed () {
    if (!this.shouldTrackPlayTime) return

    this.dispatch('submit', { target: this.playFormTarget, prefix: '' })
  }

  get persistElapsedLater () {
    return this._persistElapsedLater = (
      this._persistElapsedLater || throttle(_ => this.persistElapsed(), 20000)
    )
  }

  dispatchTimeUpdate () {
    this.dispatch('timeupdate', {
      detail: {
        href: requestUrl(this.audioTarget.src),
        currentTime: this.currentTime
      }
    })
  }

  // Callbacks

  controlsTargetConnected () {
    this._controlsLoaded?.call()
  }

  // Private

  targetApplicable (target) {
    return requestUrl(target.dataset.href) === requestUrl(this.audioTarget.src)
  }

  ifApplicable (targets, callback) {
    targets.forEach(t => {
      if (this.targetApplicable(t)) callback.call(this, t)
    })
  }

  findLoader (target) {
    return target.parentNode.querySelector('[data-player-target="loader"]')
  }

  loadNewControls (loader) {
    const promise = new Promise(resolve => this._controlsLoaded = resolve)
    loader.click()
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
