import { UserViewModel } from '../viewmodel/UserViewModel';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  private userVM: UserViewModel = new UserViewModel();

  build() {
    Column({ space: 20 }) {
      Text('新用户注册').fontSize(28).fontWeight(FontWeight.Bold).margin({ top: 80 })

      TextInput({ placeholder: '请输入账号' })
        .onChange(v => this.username = v).height(50)

      TextInput({ placeholder: '请输入密码' })
        .type(InputType.Password)
        .onChange(v => this.password = v).height(50)

      Button('立即注册')
        .width('100%').height(50).margin({ top: 20 })
        .onClick(async () => {
          const context = getContext(this) as common.Context;
          const isOk = await this.userVM.register(context, this.username, this.password);
          if (isOk) router.back(); // 注册成功后返回登录页
        })

      Text('已有账号？去登录').fontColor('#007DFF').onClick(() => router.back())
    }
    .padding(30).width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}