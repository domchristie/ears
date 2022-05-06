import { Controller } from '@hotwired/stimulus'

export default class MediaSessionController extends Controller {
  static targets = ['audio', 'controls']
  static values = { metadata: Object }

  initialize () {
    this.createLater = throttle(_ => this.create(), 20000)
  }

  controlsTargetConnected () {
    this.element.dataset.mediaSessionMetadataValue =
      this.controlsTarget.dataset.mediaSessionMetadata
  }

  async create () {
    if ('mediaSession' in navigator) {
      await Promise.resolve() // next tick to fix off-by-one errors in iOS

      navigator.mediaSession.metadata = new MediaMetadata(this.metadataValue)

      navigator.mediaSession.setActionHandler('play', () =>
        this.audioTarget.play()
      )
      navigator.mediaSession.setActionHandler('pause', () =>
        this.audioTarget.pause()
      )
      navigator.mediaSession.setActionHandler('seekbackward', (details) =>
        this.audioTarget.currentTime -= details.seekOffset
      )
      navigator.mediaSession.setActionHandler('seekforward', (details) =>
        this.audioTarget.currentTime += details.seekOffset
      )
    }
  }

  setState () {
    if ('mediaSession' in navigator) {
      navigator.mediaSession.playbackState =
        this.audioTarget.paused ? 'paused' : 'playing'
    }
  }
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
