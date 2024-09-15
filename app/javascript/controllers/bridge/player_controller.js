import { BridgeComponent } from '@hotwired/strada'

const EVENTS = {
  elapsed: 'timeupdate',
  paused: 'pause',
  playing: 'play',
  readyState: 'readystatechange'
}

export default class extends BridgeComponent {
  static component = 'player'
  static targets = ['artwork', 'controls', 'title']
  static values = {
    artwork: String,
    duration: Number,
    elapsed: Number,
    src: String,

    paused: { type: Boolean, default: true },
    playing: { type: Boolean, default: false },
    readyState: { type: Number, default: 3 }
  }

  connect () {
    this.send('value', {}, this.#setValue)
    this.send('connect')
  }

  load () {
    return this.send('load')
  }

  play () {
    return this.send('play')
  }

  pause () {
    return this.send('pause')
  }

  // Callbacks

  artworkValueChanged () {
    this.#syncValue('artwork')
  }

  durationValueChanged () {
    this.#syncValue('duration')
  }

  elapsedValueChanged () {
    this.#syncValue('elapsed')
  }

  srcValueChanged () {
    this.#syncValue('src')
  }

  controlsTargetConnected () {
    this.durationValue = this.controlsTarget.dataset.playerDuration
    this.elapsedValue = this.controlsTarget.dataset.playerElapsed
    this.srcValue = this.controlsTarget.dataset.playerSrc
  }

  artworkTargetConnected () {
    this.send('props', { props: { artworkSrc: this.artworkTarget.src } })
  }

  titleTargetConnected () {
    this.send('title', { value: this.titleTarget.textContent }, () => {
      this.titleTarget.click()
    })
  }

  // Values are sent from the native app
  // This sets the values and dispatches the change to be picked up by the
  // PlayerController
  #setValue = (message) => {
    const name = Object.keys(message.data)[0]
    const value = message.data[name]
    this[`_${name}`] = value
    this[`${name}Value`] = value

    if (EVENTS[name]) this.dispatch(EVENTS[name])
  }

  #syncValue (name) {
    if (this[`${name}Value`] !== this[`_${name}`]) {
      const value = (this[`_${name}`] = this[`${name}Value`])
      this.send('props', { props: { [name]: value } })
    }
  }

  // AudioSource Delegate
  get src () {
    return this.srcValue
  }

  set src (value) {
    return this.srcValue = value
  }

  get currentTime () {
    return this.elapsedValue
  }

  set currentTime (value) {
    return this.send('props', { props: { currentTime: value } })
  }

  get duration () {
    return this.durationValue
  }

  get paused () {
    return this.pausedValue
  }

  get readyState () {
    return this.readyStateValue
  }
}
