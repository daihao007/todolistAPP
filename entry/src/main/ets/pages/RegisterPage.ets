import { UserViewModel } from '../viewmodel/UserViewModel';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { UiConstants, UiPalette } from '../common/Constants';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State nickname: string = '';
  @State password: string = '';
  private userVM: UserViewModel = new UserViewModel();

  build() {
    Column({ space: 20 }) {
      Text('新用户注册 ✨')
        .fontSize(UiConstants.TITLE_SIZE)
        .fontWeight(FontWeight.Bold)
        .fontColor(UiPalette.TEXT_PRIMARY)
        .margin({ top: 80, bottom: 20 })

      TextInput({ placeholder: '请输入账号名' })
        .onChange(v => this.username = v)
        .height(UiConstants.CONTROL_HEIGHT)
        .fontSize(UiConstants.BODY_LARGE_SIZE)
        .borderRadius(UiConstants.BUTTON_RADIUS)
        .backgroundColor(UiPalette.SURFACE)
        .placeholderColor(UiPalette.TEXT_MUTED)
        .fontColor(UiPalette.TEXT_PRIMARY)

      TextInput({ placeholder: '设置昵称' })
        .onChange(v => this.nickname = v)
        .height(UiConstants.CONTROL_HEIGHT)
        .fontSize(UiConstants.BODY_LARGE_SIZE)
        .borderRadius(UiConstants.BUTTON_RADIUS)
        .backgroundColor(UiPalette.SURFACE)
        .placeholderColor(UiPalette.TEXT_MUTED)
        .fontColor(UiPalette.TEXT_PRIMARY)

      TextInput({ placeholder: '设置一个安全密码' })
        .type(InputType.Password)
        .onChange(v => this.password = v)
        .height(UiConstants.CONTROL_HEIGHT)
        .fontSize(UiConstants.BODY_LARGE_SIZE)
        .borderRadius(UiConstants.BUTTON_RADIUS)
        .backgroundColor(UiPalette.SURFACE)
        .placeholderColor(UiPalette.TEXT_MUTED)
        .fontColor(UiPalette.TEXT_PRIMARY)

      Button('立即注册')
        .width('100%').height(UiConstants.CONTROL_HEIGHT).margin({ top: 20 })
        .fontSize(UiConstants.SUBTITLE_SIZE)
        .fontWeight(FontWeight.Medium)
        .backgroundColor(UiPalette.PRIMARY)
        .fontColor('#FFFFFF')
        .shadow({ radius: 10, color: UiPalette.PRIMARY_SOFT, offsetY: 5 })
        .onClick(async () => {
          const context = getContext(this) as common.Context;
          const isOk = await this.userVM.register(context, this.username, this.password, this.nickname);
          if (isOk) router.back(); // 注册成功后返回登录页
        })

      Text('已有账号？去登录 🚀')
        .fontColor(UiPalette.PRIMARY)
        .fontSize(UiConstants.LABEL_SIZE)
        .fontWeight(FontWeight.Bold)
        .onClick(() => router.back())
    }
    .padding(UiConstants.FORM_PADDING).width('100%').height('100%').backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}
