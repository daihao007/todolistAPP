import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';

export class PermissionUtil {
  /**
   * 检查并申请权限
   * @param context
   * @param permissions 权限列表
   */
  static async checkAndRequestPermissions(context: common.UIAbilityContext, permissions: Permissions[]): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();

    try {
      // 1. 申请权限
      let data = await atManager.requestPermissionsFromUser(context, permissions);

      // 2. 检查结果
      let grantStatus: number[] = data.authResults;
      let allGranted = grantStatus.every(result => result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);

      return allGranted;
    } catch (err) {
      console.error('PermissionError', JSON.stringify(err));
      return false;
    }
  }
}