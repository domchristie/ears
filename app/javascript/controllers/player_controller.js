import { Controller } from '@hotwired/stimulus'

export default class PlayerController extends Controller {
  initialize () {
    this.throttledPersistProgress = throttle(
      () => this.persistProgress(),
      20000
    )
  }

  async connect () {
    const audioElement = this.audioTarget
    const clone = audioElement.cloneNode(true)
    audioElement.parentNode.insertBefore(clone, audioElement)
    audioElement.remove()

    this.updateTime()
    this.updateScrubber()
  }

  get duration () {
    return this.audioTarget.duration || this.durationValue
  }

  get currentTime () {
    return this.started ? (this.audioTarget.currentTime || 0) : this.offset
  }

  get offset () {
    return this._offset != null ? this._offset : this.offsetValue
  }

  set offset (value) {
    this._offset = value
  }

  start () {
    if (!this.started) {
      this.audioTarget.currentTime = this.offset
      this.started = true
    }
  }

  play () {
    return this.audioTarget.play()
  }

  pause () {
    return this.audioTarget.pause()
  }

  updateControls () {
    if (this.audioTarget.paused) {
      this.playTarget.hidden = false
      this.playTarget.focus()
      this.pauseTarget.hidden = true
    } else {
      this.playTarget.hidden = true
      this.pauseTarget.hidden = false
      this.pauseTarget.focus()
    }
  }

  updateTime () {
    this.elapsedTarget.textContent = formatDuration(this.currentTime, 'display')
    this.elapsedTarget.setAttribute('datetime', formatDuration(this.currentTime))
    const remaining = this.duration - this.currentTime
    this.remainingTarget.textContent = formatDuration(remaining, 'display')
    this.remainingTarget.setAttribute('datetime', formatDuration(remaining))
  }

  updateScrubber () {
    const value = this.duration ? this.currentTime / this.duration : 0
    this.scrubberTarget.value = value
    this.scrubberTarget.style.setProperty('--val', value)
  }

  scrub () {
    const value = +this.scrubberTarget.value * this.duration
    this.offset = value
    this.audioTarget.currentTime = value
    this.scrubberTarget.style.setProperty('--val', +this.scrubberTarget.value)
    this.updateTime()
  }

  trackProgress () {
    this.progressFieldTarget.value = this.currentTime
    if (!this.audioTarget.paused) this.throttledPersistProgress()
  }

  persistProgress () {
    this.dispatch('submit', { target: this.playFormTarget, prefix: '' })
  }
}

PlayerController.targets = [
  'audio',
  'play',
  'pause',
  'scrubber',
  'elapsed',
  'remaining',
  'playForm',
  'progressField'
]

PlayerController.values = {
  playsPath: String,
  offset: Number,
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

function duration (seconds) {
  const hours = Math.floor(seconds / (60 * 60))
  const minutes = Math.floor(seconds / 60) % 60
  seconds = Math.floor(seconds % 60)
  return { hours, minutes, seconds }
}

function formatDuration (elapsed, format) {
  const { hours, minutes, seconds } = duration(elapsed)
  switch (format) {
  case 'display':
    return [
      hours ? pad(hours) : null,
      pad(minutes),
      pad(seconds)
    ].filter(p => p != null).join(':')
  default:
    return `PT${hours}H${minutes}M${seconds}S`
  }
}

function pad (number) {
  return number < 10 ? '0' + number : number.toString()
}
