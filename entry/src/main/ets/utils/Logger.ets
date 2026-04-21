import hilog from '@ohos.hilog';

export class Logger {
  private static domain: number = 0xFF00;
  private static prefix: string = 'NoteApp_Log';

  static info(tag: string, msg: string) {
    hilog.info(Logger.domain, Logger.prefix, `[${tag}] ${msg}`);
  }

  static error(tag: string, msg: string) {
    hilog.error(Logger.domain, Logger.prefix, `[${tag}] ${msg}`);
  }
}