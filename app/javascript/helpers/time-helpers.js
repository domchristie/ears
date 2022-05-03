export function duration (seconds) {
  const hours = Math.floor(seconds / (60 * 60))
  const minutes = Math.floor(seconds / 60) % 60
  seconds = Math.floor(seconds % 60)
  return { hours, minutes, seconds }
}

export function formatDuration (elapsed, format) {
  const { hours, minutes, seconds } = duration(elapsed)
  switch (format) {
  case 'words':
    [
      (hours > 1 && `%{hours} hrs`),
      (hours === 1 && `%{hours} hr`),
      (minutes > 1 && `%{minutes} mins`),
      (minutes === 1 && `%{minutes} min`)
    ].filter(p => p != null).join(' ')
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

export function pad (number) {
  return number < 10 ? '0' + number : number.toString()
}
