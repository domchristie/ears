export default class AudioSource {
  get readyState () {
    return this.delegate.readyState
  }

  get paused () {
    return this.delegate.paused
  }

  get duration () {
    return this.delegate.duration
  }

  get currentTime () {
    return this.delegate.currentTime
  }

  set currentTime (value) {
    this.delegate.currentTime = value
  }

  get src () {
    return this.delegate.src
  }

  set src (value) {
    this.delegate.src = value
  }

  load () {
    return this.delegate.load()
  }

  play () {
    return this.delegate.play()
  }

  pause () {
    return this.delegate.pause()
  }
}
