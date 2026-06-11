import { UserViewModel } from '../viewmodel/UserViewModel';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { UiConstants, UiPalette } from '../common/Constants';

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  private userVM: UserViewModel = new UserViewModel();

  build() {
    Column({ space: 15 }) {
      // 1. 品牌 Logo 区
      Column({ space: 10 }) {
        Image($r('app.media.layered_image')) // 使用项目自带的图标
          .width(90).height(90)
          .borderRadius(24)
          .shadow({ radius: 20, color: '#105C5454', offsetY: 10 })
        Text('灵感笔记')
          .fontSize(UiConstants.TITLE_SIZE)
          .fontWeight(FontWeight.Bold)
          .fontColor(UiPalette.TEXT_PRIMARY)
          .margin({ top: 10 })
        Text('生活碎片，云端珍藏 ☁️')
          .fontSize(UiConstants.LABEL_SIZE)
          .fontColor(UiPalette.TEXT_SECONDARY)
      }.margin({ top: 80, bottom: 40 })

      // 2. 输入区
      TextInput({ placeholder: '在此输入账号' })
        .onChange(v => this.username = v)
        .height(UiConstants.CONTROL_HEIGHT)
        .fontSize(UiConstants.BODY_LARGE_SIZE)
        .borderRadius(UiConstants.BUTTON_RADIUS)
        .backgroundColor(UiPalette.SURFACE)
        .placeholderColor(UiPalette.TEXT_MUTED)
        .fontColor(UiPalette.TEXT_PRIMARY)

      TextInput({ placeholder: '请输入密码' })
        .type(InputType.Password)
        .onChange(v => this.password = v)
        .height(UiConstants.CONTROL_HEIGHT)
        .fontSize(UiConstants.BODY_LARGE_SIZE)
        .borderRadius(UiConstants.BUTTON_RADIUS)
        .backgroundColor(UiPalette.SURFACE)
        .placeholderColor(UiPalette.TEXT_MUTED)
        .fontColor(UiPalette.TEXT_PRIMARY)

      // 3. 登录按钮
      Button('登 录')
        .width('100%').height(UiConstants.CONTROL_HEIGHT).margin({ top: 20 })
        .fontSize(UiConstants.SUBTITLE_SIZE)
        .fontWeight(FontWeight.Medium)
        .backgroundColor(UiPalette.PRIMARY)
        .fontColor('#FFFFFF')
        .shadow({ radius: 10, color: UiPalette.PRIMARY_SOFT, offsetY: 5 })
        .onClick(async () => {
          try {
            const context = getContext(this) as common.Context;
            await this.userVM.login(context, this.username, this.password);
          } catch (error) {
            console.error('Login_Error: ' + JSON.stringify(error));
          }
        })

      // 4. 注册入口
      Row() {
        Text('还没有账号？').fontColor(UiPalette.TEXT_SECONDARY).fontSize(UiConstants.LABEL_SIZE)
        Text('立即注册 ✨')
          .fontColor(UiPalette.PRIMARY)
          .fontSize(UiConstants.LABEL_SIZE)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({ url: 'pages/RegisterPage' });
          })
      }.margin({ top: 20 })
    }
    .padding(UiConstants.FORM_PADDING).width('100%').height('100%').backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}
