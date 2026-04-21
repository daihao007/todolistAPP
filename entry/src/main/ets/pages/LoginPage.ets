import { UserViewModel } from '../viewmodel/UserViewModel';
import common from '@ohos.app.ability.common';
import router from '@ohos.router';

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
        // 🛠 修复：如果 app_icon 报错，确保 media 文件夹下有这个文件，或先改用 sys 资源
        Image($r('sys.media.ohos_app_icon'))
          .width(80).height(80)
        Text('灵感笔记').fontSize(26).fontWeight(FontWeight.Bold)
      }.margin({ top: 100, bottom: 40 })

      // 2. 输入区
      TextInput({ placeholder: '账号' }).onChange(v => this.username = v).height(50)
      TextInput({ placeholder: '密码' }).type(InputType.Password).onChange(v => this.password = v).height(50)

      // 3. 登录按钮
      Button('登 录')
        .width('100%').height(50).margin({ top: 20 })
        .onClick(async () => {
          // 🛠 修复：使用 try-catch 处理可能抛出的异常
          try {
            const context = getContext(this) as common.Context;
            await this.userVM.login(context, this.username, this.password);
          } catch (error) {
            console.error('Login_Error: ' + JSON.stringify(error));
          }
        })

      // 4. 注册入口
      Row() {
        Text('还没有账号？')
        Text('立即注册')
          .fontColor('#007DFF')
          .onClick(() => {
            router.pushUrl({ url: 'pages/RegisterPage' });
          })
      }.margin({ top: 20 })
    }
    .padding(30).width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}