export class DateUtil {
  private static formatSegment(value: number): string {
    return value.toString().padStart(2, '0')
  }

  static formatDate(timestamp: number): string {
    const date = new Date(timestamp)
    const year = date.getFullYear()
    const month = DateUtil.formatSegment(date.getMonth() + 1)
    const day = DateUtil.formatSegment(date.getDate())
    return `${year}-${month}-${day}`
  }

  static formatTime(timestamp: number): string {
    const date = new Date(timestamp)
    const hours = DateUtil.formatSegment(date.getHours())
    const minutes = DateUtil.formatSegment(date.getMinutes())
    return `${DateUtil.formatDate(timestamp)} ${hours}:${minutes}`
  }

  static getRelativeTime(timestamp: number): string {
    const diffSeconds = Math.floor((Date.now() - timestamp) / 1000)
    if (diffSeconds < 60) {
      return 'just now'
    }
    if (diffSeconds < 3600) {
      return `${Math.floor(diffSeconds / 60)} min ago`
    }
    if (diffSeconds < 86400) {
      return `${Math.floor(diffSeconds / 3600)} h ago`
    }
    return DateUtil.formatDate(timestamp)
  }
}
