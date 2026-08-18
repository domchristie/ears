export default (el, props, { on }) => {
  const observer = new IntersectionObserver(observed)
  el.querySelectorAll('[data-layout-target="observable"]')
    .forEach(observer.observe)

  on('click', '[href="#top"]', scrollToTop)

  function scrollToTop(ev) {
    ev.preventDefault(), window.scroll({ top: 0, behavior: 'smooth' })
  }

  function observed(entries) {
    const respondables = [
      ...el.querySelectorAll('[data-layout-target="respondable"]')
    ]
    entries.forEach(entry => {
      const relevants = respondables.filter(element =>
        element.dataset.activeWhen.split(':')[0] === entry.target.id
      )

      const state = entry.isIntersecting ? 'visible' : 'invisible'
      relevants.forEach(element => {
        if (element.dataset.activeWhen.split(':')[1] === state) {
          element.dataset.active = true
        } else {
          delete element.dataset.active
        }
      })
    })
  }
}
