import { Controller } from '@hotwired/stimulus'
import {
  chronoDuration,
  iso8601Duration,
  humanDuration
} from 'helpers/time-helpers'
import { throttle } from 'helpers/debounce-helpers'

const PLAY_PERSISTENCE_DURATION = 30000

export default class PlayerController extends Controller {
  static values = { duration: Number }
  static targets = [
    'audio',
    'controls',
    'elapsed',
    'remaining',
    'progress',
    'playForm',
    'elapsedField',
    'remainingField',
    'play',
    'timerIcon',
    'remainingInWords',
    'iframe'
  ]

  get hasNothing () {
    return !this.audioTarget?.readyState
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

  get duration () {
    return this.audioTarget?.duration || this.durationValue || 0
  }

  get currentTime () {
    return this.audioTarget?.currentTime || 0
  }

  set currentTime (value) {
    // In Safari, when a src contains a Media Fragment, currentTime will be
    // reset to the Media Fragment time when the audio is loaded. This means
    // setting currentTime before anything has loaded won't work as expected.
    // To fix, update the Media Fragment so when the audio is loaded, it'll
    // play from the expected point. Only set if the audio has not yet loaded
    // to prevent reloads.
    if (this.hasNothing) {
      const src = new URL(this.audioTarget.src)
      src.hash = `#t=${value}`
      this.audioTarget.src = src.toString()
    }
    this.audioTarget.currentTime = value
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
    if (this.targetApplicable(event.currentTarget)) {
      await this.audioTarget[this.audioTarget.paused ? 'play' : 'pause']()
    } else {
      let src = event.currentTarget.dataset.href
      if (event.currentTarget.hash) src += event.currentTarget.hash
      this.audioTarget.src = src
      this.audioTarget.load()
      await this.loadNewControls(event.currentTarget.href)
      await this.audioTarget.play()
    }
  }

  async skipToAndPlay ({ currentTarget }) {
    if (this.targetApplicable(currentTarget)) {
      this.currentTime = parseTimestamp(currentTarget.hash) || 0.001
      if (this.audioTarget.paused) this.audioTarget.play()
    } else {
      let src = currentTarget.dataset.href
      if (currentTarget.hash) src += currentTarget.hash
      this.audioTarget.src = src
      this.audioTarget.load()
      await this.loadNewControls(currentTarget.href)
      await this.audioTarget.play()
    }
  }

  skipBack (event = {}) {
    event.currentTarget?.focus()

    this.currentTime = Math.max(
      this.audioTarget.currentTime - 15,
      0
    )
  }

  skipForward (event = {}) {
    event.currentTarget?.focus()

    this.currentTime = Math.min(
      this.audioTarget.currentTime + 30,
      this.duration
    )
  }

  updateActiveElements () {
    this.updateToggles()
    this.updatePlays()
    this.updateTime()
    this.updateProgress()
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
    if (this.seeking) return

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

  updateTimeLater = throttle(_ => this.updateTime(), 250)

  updateProgress () {
    if (document.visibilityState === 'hidden') return
    if (this.seeking) return

    const progress = (this.currentTime / this.duration) || 0
    this.ifApplicable(this.progressTargets, t => {
      t.value = progress * 100
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

  persistElapsedLater = throttle(_ => this.persistElapsed(), PLAY_PERSISTENCE_DURATION)

  dispatchTimeUpdate () {
    this.dispatch('timeupdate', {
      detail: {
        href: requestUrl(this.audioTarget.src),
        currentTime: this.currentTime
      }
    })
  }

  startSeeking () {
    this.seeking = true
  }

  stopSeeking () {
    this.seeking = false
  }

  seekTo (event) {
    const progress = Number(event.currentTarget.value) / 100
    this.currentTime = progress * this.duration
  }

  seek (event) {
    const progress = Number(event.currentTarget.value) / 100
    const elapsed = this.duration * progress
    const remaining = this.duration * (1 - progress)

    this.ifApplicable(this.elapsedTargets, t => {
      t.textContent = chronoDuration(elapsed)
      t.setAttribute('datetime', iso8601Duration(elapsed))
      t.setAttribute(
        'aria-label',
        `${humanDuration(elapsed)} elapsed`
      )
    })

    this.ifApplicable(this.remainingTargets, t => {
      t.textContent = '-' + chronoDuration(remaining, 'display')
      t.setAttribute('datetime', iso8601Duration(remaining))
      t.setAttribute('aria-label', `${humanDuration(remaining)} left`)
    })
  }

  // Callbacks

  controlsTargetConnected () {
    this._controlsLoaded?.call()
    this.durationValue = this.controlsTarget.dataset.playerDuration
  }

  audioTargetConnected () {
    // Fix NotSupported error on Firefox
    if (!this.audioSrcReset && this.audioTarget.src) {
      this.audioTarget.src = this.audioTarget.src
      this.audioSrcReset = true
    }
  }

  iframeTargetConnected () {
    this.iframeTarget.remove()
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

  loadNewControls (url) {
    const promise = new Promise(resolve => this._controlsLoaded = resolve)
    Turbo.visit(url, { frame: 'player' })
    return promise
  }
}

function requestUrl (url) {
  const u =  new URL(url)
  return u.origin + u.pathname + u.search
}

function parseTimestamp (hash) {
  return Number(hash.replace(/[^\d.]/g, ''))
}
