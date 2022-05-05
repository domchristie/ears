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

export function distanceOfTimeInWords (seconds, scope = 'default') {
  const d = duration(seconds)

  let output = []
  for (const unit in d) {
    const count = d[unit]
    const template = findTemplate(count, unit, scope)
    count && template && output.push(typeof template === 'function'
      ? template(count, d)
      : template
    )
  }
  return output.join(' ')

  function findTemplate (count, unit, scope) {
    return DURATION.words[scope][unit]?.[count === 1 ? 'one' : 'other']
  }
}

function duration (seconds) {
  const hours = Math.floor(seconds / (60 * 60))
  const minutes = Math.floor(seconds / 60) % 60
  seconds = Math.floor(seconds % 60)
  return { hours, minutes, seconds }
}

function pad (number) {
  return number < 10 ? '0' + number : number.toString()
}

const DURATION = {
  words: {
    default: {
      hours: {
        one: '1 hour',
        other: count => `${count} hours`
      },
      minutes: {
        one: '1 minute',
        other: count => `${count} minutes`
      }
    },
    short: {
      hours: {
        one: (_, d) => d.minutes >= 1 ? '1 hr' : '1 hour',
        other: count => `${count} hrs`
      },
      minutes: {
        one: '1 min',
        other: count => `${count} mins`
      }
    }
  }
}
