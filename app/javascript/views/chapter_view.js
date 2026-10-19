export default (el, props, { on }) => {
  const { startTime, endTime } = props

  on(window, 'player:timeupdate', (ev) => {
    let currentTime, isPlaying
    if (eventApplicable(ev)) {
      currentTime = ev.detail.currentTime
      isPlaying = true
    } else {
      isPlaying = false
    }
    el.dataset.defoChapter = JSON.stringify({
      ...props, currentTime, isPlaying
    })
  })

  function progress(time) {
    return (time - startTime) / (endTime - startTime)
  }

  function eventApplicable({ detail: { href, currentTime } }) {
    return (
      href === el.dataset.href &&
      currentTime >= startTime &&
      currentTime < endTime
    )
  }

  return {
    update: (_, props) => {
      const { currentTime, isPlaying } = props
      const $progress = el.querySelector('[data-chapter-target="progress"]')
      $progress.value = isPlaying ? progress(currentTime) : 0
      el.toggleAttribute('data-playing', isPlaying)
    }
  }
}
