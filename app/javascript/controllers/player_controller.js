import { Controller } from '@hotwired/stimulus'
import {
  chronoDuration,
  iso8601Duration,
  distanceOfTimeInWords
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

  initialize () {
    this.persistElapsedLater = throttle(_ => this.persistElapsed(), 20000)
    this.updateTimeLater = throttle(_ => this.updateTime(), 1000)
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
      this.audioTarget.src = event.currentTarget.href
      await this.loadNewControls(this.findLoader(event.currentTarget))
      this.audioTarget.play()
    }
  }

  skipBack () {
    this.audioTarget.currentTime -= 15
  }

  skipForward () {
    this.audioTarget.currentTime += 30
  }

  get ready () {
    return this.audioTarget && this.audioTarget.readyState >= 3
  }

  get playing () {
    return this.ready && !this.audioTarget.paused
  }

  get loading () {
    return !this.ready && !this.audioTarget.paused
  }

  get shouldTrackPlayTime () {
    return this.hasElapsedFieldTarget
  }

  updateToggles () {
    this.playTargets.forEach((target) => {
      if (this.targetApplicable(target)) {
        target.classList.toggle('--loading', this.loading)
        target.classList.toggle('--playing', this.playing)
      } else {
        target.classList.remove('--loading')
        target.classList.remove('--playing')
      }
    })
  }

  updateTime () {
    if (this.audioTarget.readyState < 2) return

    const remaining = Math.max(this.duration - this.currentTime, 0)

    this.ifApplicable(this.elapsedTargets, t => {
      t.textContent = chronoDuration(this.currentTime)
      t.setAttribute('datetime', iso8601Duration(this.currentTime))
      t.setAttribute(
        'aria-label',
        `${distanceOfTimeInWords(this.currentTime)} elapsed`
      )
    })

    this.ifApplicable(this.remainingTargets, t => {
      t.textContent = '-' + chronoDuration(remaining, 'display')
      t.setAttribute('datetime', iso8601Duration(remaining))
      t.setAttribute('aria-label', `${distanceOfTimeInWords(remaining)} left`)
    })

    this.ifApplicable(this.playTargets, t => {
      t.classList.toggle('--played', remaining < 60)
    })

    this.ifApplicable(this.timerIconTargets, t => {
      t.style.setProperty('--progress', this.currentTime / this.duration)
    })

    this.ifApplicable(this.remainingInWordsTargets, t => {
      t.textContent = `${distanceOfTimeInWords(remaining, 'short')} left`
      t.setAttribute('datetime', iso8601Duration(remaining))
      t.setAttribute('aria-label', `${distanceOfTimeInWords(remaining)} left`)
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
