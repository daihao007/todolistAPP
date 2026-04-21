import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import {
  UiPalette
} from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { NoteViewModel, NoteCardViewData } from '../viewmodel/NoteViewModel'

@Entry
@Component
struct Index {
  // 🛠 修复点 1：禁止使用 any，改为具体的接口类型数组
  @State noteList: NoteCardViewData[] = []
  @State loading: boolean = true
  @State username: string = '开发者'

  private noteViewModel: NoteViewModel | null = null
  private db: RdbStoreManager = RdbStoreManager.getInstance(getContext(this) as common.Context)

  async aboutToAppear() {
    this.ensureViewModel()
    try {
      await this.db.initDb()
      await this.loadNotes()
    } catch (err) {
      console.error('E_Log: 初始化失败')
    }
  }

  onPageShow(): void {
    // 🛠 修复点 2：处理可能抛出的异常 (Special handling required)
    this.loadNotes().catch((err: Error) => {
      console.error('E_Log: 刷新失败 ' + err.message)
    })
  }

  private ensureViewModel(): void {
    if (this.noteViewModel !== null) return
    const context = getContext(this) as common.UIAbilityContext
    this.noteViewModel = new NoteViewModel(context)
  }

  private async loadNotes(): Promise<void> {
    this.ensureViewModel()
    if (this.noteViewModel === null) return
    this.loading = true
    try {
      this.noteList = await this.noteViewModel.loadNotes()
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      Column() {
        Text(`你好，${this.username}`).fontSize(28).fontWeight(FontWeight.Bold)
        Text('让创意随时随地发芽').fontSize(16).fontColor('#666').margin({ top: 8 })
      }
      .width('100%').alignItems(HorizontalAlign.Start).padding({ left: 30, top: 60, bottom: 40 })

      Column({ space: 20 }) {
        // 🛠 修复点 3：修正系统图标资源名。
        // 如果 sys.media.ohos_ic_public_notes 仍然报错，请确认 SDK 版本或改用本地图片
        this.MenuCard('我的笔记', '记录灵感、生活与创意', '#E3F2FD', 'pages/NoteEditPage', $r('app.media.icon_note'))
        this.MenuCard('待办清单', '管理日程，高效每一天', '#E8F5E9', 'pages/TodoDetailPage', $r('app.media.icon_todo'))
      }
      .padding({ left: 20, right: 20 })

      Blank()

      Button('我的笔记与代办事项')
        .width('85%').height(55).backgroundColor(UiPalette.PRIMARY).borderRadius(15).margin({ bottom: 60 })
        .onClick(async () => {
          // 🛠 修复点 4：异步跳转增加异常处理
          try {
            await router.pushUrl({ url: 'pages/SearchResultPage' })
          } catch (err) {
            console.error('Jump Error')
          }
        })
    }
    .width('100%').height('100%').backgroundColor('#F1F3F5')
  }

  @Builder MenuCard(title: string, subTitle: string, bgColor: string, targetUrl: string, icon: Resource) {
    Row() {
      Column({ space: 6 }) {
        Text(title).fontSize(22).fontWeight(FontWeight.Bold)
        Text(subTitle).fontSize(14).fontColor('#666')
      }.alignItems(HorizontalAlign.Start)
      Blank()
      Image(icon).width(45).height(45).opacity(0.1)
    }
    .width('100%').height(130).padding(30).backgroundColor(bgColor).borderRadius(24)
    .onClick(async () => {
      try {
        await router.pushUrl({ url: targetUrl })
      } catch (err) {
        console.error('Nav Error')
      }
    })
  }
}