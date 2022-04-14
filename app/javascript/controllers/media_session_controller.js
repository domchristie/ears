import { Controller } from '@hotwired/stimulus'

export default class MediaSessionController extends Controller {
  create () {
    if ('mediaSession' in navigator && !this.hasTriggeredMediaSession) {
      this.audioTarget.pause()
      this.audioTarget.play()

      navigator.mediaSession.metadata = new MediaMetadata({
        title: this.titleValue,
        artist: this.artistValue,
        album: this.albumValue,
        artwork: this.artworkValue
      })

      this.hasTriggeredMediaSession = true
    }
  }
}

MediaSessionController.targets = ['audio']

MediaSessionController.values = {
  title: String,
  artist: String,
  album: String,
  artwork: Array
}
