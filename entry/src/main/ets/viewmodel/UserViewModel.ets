import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { PreferenceUtil } from '../utils/PreferenceUtil';
import { NativeCrypto } from '../utils/NativeCrypto';
import common from '@ohos.app.ability.common';

export class UserViewModel {
  private getNicknameKey(user: string): string {
    return `NICKNAME_${user}`;
  }

  private isHexString(value: string): boolean {
    for (let i = 0; i < value.length; i++) {
      const code = value.charCodeAt(i);
      const isNumber = code >= 48 && code <= 57;
      const isLowerHex = code >= 97 && code <= 102;
      const isUpperHex = code >= 65 && code <= 70;
      if (!isNumber && !isLowerHex && !isUpperHex) {
        return false;
      }
    }
    return true;
  }

  private parsePasswordRecord(record: string): string[] {
    const parts = record.split(':');
    if (parts.length !== 2) {
      return [];
    }

    const hash = parts[0];
    const salt = parts[1];
    if (hash.length !== 64 || salt.length !== 32 || !this.isHexString(hash) || !this.isHexString(salt)) {
      return [];
    }
    return [hash, salt];
  }

  private buildPasswordRecord(pass: string): string {
    const salt = NativeCrypto.generateSalt();
    const hash = NativeCrypto.hashPassword(pass, salt);
    if (salt.length !== 32 || hash.length !== 64) {
      return '';
    }
    return `${hash}:${salt}`;
  }

  private async migratePlainPassword(context: common.Context, user: string, pass: string): Promise<boolean> {
    const passwordRecord = this.buildPasswordRecord(pass);
    if (passwordRecord.length === 0) {
      return false;
    }

    await PreferenceUtil.putString(context, user, passwordRecord);
    return true;
  }

  private async completeLogin(context: common.Context, user: string): Promise<void> {
    await PreferenceUtil.putString(context, 'CURRENT_USER', user);
    promptAction.showToast({ message: '登录成功，欢迎回来' });
    router.replaceUrl({ url: 'pages/Index' });
  }

  /**
   * 注册逻辑
   */
  async register(context: common.Context, user: string, pass: string, nickname: string) {
    const safeNickname = nickname.trim();
    if (user.length < 3 || pass.length < 3) {
      promptAction.showToast({ message: '账号密码长度需大于3位' });
      return false;
    }
    if (safeNickname.length === 0) {
      promptAction.showToast({ message: '请输入昵称' });
      return false;
    }

    // 1. 检查账号是否已存在 (key 为账号名，默认值设为 'NOT_FOUND')
    const checkUser = await PreferenceUtil.getString(context, user, 'NOT_FOUND');

    if (checkUser !== 'NOT_FOUND') {
      promptAction.showToast({ message: '账号已存在，请直接登录' });
      return false;
    }

    // 2. 存储加盐哈希后的账号密码
    const passwordRecord = this.buildPasswordRecord(pass);
    if (passwordRecord.length === 0) {
      promptAction.showToast({ message: '密码加密失败，请重试' });
      return false;
    }

    await PreferenceUtil.putString(context, user, passwordRecord);
    await PreferenceUtil.putString(context, this.getNicknameKey(user), safeNickname);
    await PreferenceUtil.putString(context, 'CURRENT_USER', user);
    promptAction.showToast({ message: '注册成功！' });
    router.replaceUrl({ url: 'pages/Index' });
    return true;
  }

  /**
   * 登录逻辑
   */
  async login(context: common.Context, user: string, pass: string) {
    // 1. 获取该账号对应的密码
    const savedPass = await PreferenceUtil.getString(context, user, 'NOT_FOUND');

    if (savedPass === 'NOT_FOUND') {
      promptAction.showToast({ message: '账号不存在，请先注册' });
      return false;
    }

    const passwordRecord = this.parsePasswordRecord(savedPass);
    if (passwordRecord.length === 2) {
      const savedHash = passwordRecord[0];
      const savedSalt = passwordRecord[1];
      if (!NativeCrypto.verifyPassword(pass, savedSalt, savedHash)) {
        promptAction.showToast({ message: '密码错误' });
        return false;
      }

      await this.completeLogin(context, user);
      return true;
    }

    if (savedPass !== pass) {
      promptAction.showToast({ message: '密码错误' });
      return false;
    }

    const migrated = await this.migratePlainPassword(context, user, pass);
    if (!migrated) {
      promptAction.showToast({ message: '密码升级失败，请重试' });
      return false;
    }

    await this.completeLogin(context, user);
    return true;
  }
}
