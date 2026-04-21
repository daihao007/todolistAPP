import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

export class PreferenceUtil {
  // 偏好设置的文件名（随便起，全组统一就行）
  private static readonly PREF_NAME = 'NoteAppSettings';

  /**
   * 保存数据（字符串类型）
   */
  static async putString(context: common.Context, key: string, value: string) {
    try {
      let pref = await preferences.getPreferences(context, PreferenceUtil.PREF_NAME);
      await pref.put(key, value);
      // ⚠️ 重点：必须 flush 才会真正写进硬盘，否则重启就丢了
      await pref.flush();
    } catch (err) {
      console.error('Pref_Log: 保存失败', JSON.stringify(err));
    }
  }

  /**
   * 读取数据（字符串类型）
   */
  static async getString(context: common.Context, key: string, defaultValue: string): Promise<string> {
    try {
      let pref = await preferences.getPreferences(context, PreferenceUtil.PREF_NAME);
      let value = await pref.get(key, defaultValue);
      return value.toString();
    } catch (err) {
      return defaultValue;
    }
  }

  /**
   * 保存布尔值（常用于开关：如夜间模式）
   */
  static async putBoolean(context: common.Context, key: string, value: boolean) {
    let pref = await preferences.getPreferences(context, PreferenceUtil.PREF_NAME);
    await pref.put(key, value);
    await pref.flush();
  }

  static async getBoolean(context: common.Context, key: string, defaultValue: boolean): Promise<boolean> {
    let pref = await preferences.getPreferences(context, PreferenceUtil.PREF_NAME);
    return (await pref.get(key, defaultValue)) as boolean;
  }
}