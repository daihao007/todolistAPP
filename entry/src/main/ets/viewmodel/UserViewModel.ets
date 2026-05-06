import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { PreferenceUtil } from '../utils/PreferenceUtil';
import common from '@ohos.app.ability.common';

export class UserViewModel {
  /**
   * 注册逻辑
   */
  async register(context: common.Context, user: string, pass: string) {
    if (user.length < 3 || pass.length < 3) {
      promptAction.showToast({ message: '账号密码长度需大于3位' });
      return false;
    }

    // 1. 检查账号是否已存在 (key 为账号名，默认值设为 'NOT_FOUND')
    const checkUser = await PreferenceUtil.getString(context, user, 'NOT_FOUND');

    if (checkUser !== 'NOT_FOUND') {
      promptAction.showToast({ message: '账号已存在，请直接登录' });
      return false;
    }

    // 2. 存储账号密码
    await PreferenceUtil.putString(context, user, pass);
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

    // 2. 判定逻辑
    if (savedPass === 'NOT_FOUND') {
      promptAction.showToast({ message: '账号不存在，请先注册' });
    } else if (savedPass !== pass) {
      promptAction.showToast({ message: '密码错误' });
    } else {
      // ✅ 记录当前登录用户
      await PreferenceUtil.putString(context, 'CURRENT_USER', user);
      promptAction.showToast({ message: '登录成功，欢迎回来' });
      // ✅ 跳转首页并销毁登录页
      router.replaceUrl({ url: 'pages/Index' });
    }
  }
}