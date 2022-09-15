import humanizeDuration from 'humanize-duration'

const LANGUAGES = {
  'en-short': {
    y: (n) => pluralize(n, 'yr', 'yrs'),
    mo: (n) => pluralize(n, 'mth', 'mths'),
    w: (n) => pluralize(n, 'wk', 'wks'),
    d: (n) => pluralize(n, 'day', 'days'),
    h: (n) => pluralize(n, 'hr', 'hrs'),
    m: (n) => pluralize(n, 'min', 'mins'),
    s: (n) => pluralize(n, 'sec', 'secs'),
    ms: () => "ms"
  }
}

const HUMANIZERS = {
  default: humanizeDuration.humanizer({
    round: true,
    largest: 2,
    units: ['h', 'm', 's'],
  }),
  short: humanizeDuration.humanizer({
    language: 'en-short',
    languages: LANGUAGES,
    round: true,
    largest: 2,
    units: ['h', 'm', 's'],
    conjunction: ' ',
    serialComma: false
  })
}

export function chronoDuration (d) {
  const { hours, minutes, seconds } = duration(d)
  return [
    hours ? pad(hours) : null,
    pad(minutes),
    pad(seconds)
  ].filter(p => p != null).join(':')
}

export function iso8601Duration (d) {
  const { hours, minutes, seconds } = duration(d)
  return `PT${hours}H${minutes}M${seconds}S`
}

export function humanDuration (seconds, humanizer = 'default') {
  if (seconds < 60 && humanizer === 'short') return '< 1 min'

  return HUMANIZERS[humanizer](seconds * 1000, {
    largest: seconds < 60 * 60 ? 1 : 2
  })
}

function duration (seconds) {
  const MINUTE = 60
  const HOUR = MINUTE * 60
  const hours = Math.floor(seconds / HOUR)
  const minutes = Math.floor(seconds / MINUTE) % 60
  return { hours, minutes, seconds: Math.floor(seconds % 60) }
}

function pad (number) {
  return number < 10 ? '0' + number : number.toString()
}

function pluralize (n, singular, plural) {
  return n > 1 || n === 0 ? plural : singular
}
