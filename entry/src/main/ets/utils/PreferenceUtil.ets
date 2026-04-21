import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

export class PreferenceUtil {
  // 简单存一个 String 的例子
  static async putString(context: common.Context, key: string, value: string) {
    let pref = await preferences.getPreferences(context, 'app_settings');
    await pref.put(key, value);
    await pref.flush(); // 必须 flush 才会写入硬盘
  }

  static async getString(context: common.Context, key: string, defValue: string): Promise<string> {
    let pref = await preferences.getPreferences(context, 'app_settings');
    return (await pref.get(key, defValue)).toString();
  }
}