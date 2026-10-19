import Turn from '@domchristie/turn'

let started = false
export default () => {
  if (!started) Turn.start(), started = true
}
