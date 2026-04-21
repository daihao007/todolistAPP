export class DateUtil {
  /**
   * 将时间戳转换为：2026/04/21 20:30 格式
   */
  static formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${year}/${month}/${day} ${hours}:${minutes}`;
  }

  /**
   * 高级功能：转换成“刚刚”、“1小时前”
   */
  static getRelativeTime(timestamp: number): string {
    const now = Date.now();
    const diff = (now - timestamp) / 1000;
    if (diff < 60) return '刚刚';
    if (diff < 3600) return `${Math.floor(diff / 60)}分钟前`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}小时前`;

    return DateUtil.formatTime(timestamp);
  }
}