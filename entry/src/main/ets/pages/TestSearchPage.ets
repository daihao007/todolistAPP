import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { CommonConstants, UiPalette } from '../common/Constants'
import { BusinessError } from '@ohos.base'

@Entry
@Component
struct TestDatabasePage {
  @State searchKey: string = ''
  @State notes: Note[] = []
  // 明确初始化 db 实例
  private db: RdbStoreManager = new RdbStoreManager(getContext(this))

  async aboutToAppear(): Promise<void> {
    try {
      await this.db.initDb()
      await this.refresh()
    } catch (err) {
      const error: BusinessError = err as BusinessError
      console.error(`Init failed: ${error.message}`)
    }
  }

  async refresh(): Promise<void> {
    this.notes = await this.db.queryAllNotes()
  }

  build() {
    Column({ space: 20 }) {
      Text('C 逻辑实验室 (强类型版)')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })

      Search({ placeholder: '搜索标题...', value: this.searchKey })
        .width('90%')
        .onChange(async (val: string) => {
          this.searchKey = val
          // 调用你写的模糊查询
          this.notes = await this.db.searchNotes(val)
        })

      Row({ space: 10 }) {
        Button('随机插入笔记')
          .onClick(async () => {
            const newNote: Note = {
              id: Date.now().toString(),
              title: `测试-${Math.floor(Math.random() * 100)}`,
              content: 'ArkTS 强类型检查通过',
              imagePath: '',
              tags: '测试',
              createTime: Date.now(),
              isTodo: 0
            }
            await this.db.insertNote(newNote)
            await this.refresh()
          })

        Button('刷新列表')
          .onClick(async () => {
            await this.refresh()
          })
      }

      List({ space: 10 }) {
        ForEach(this.notes, (item: Note) => {
          ListItem() {
            Column() {
              Text(item.title).fontWeight(FontWeight.Bold).fontSize(18)
              Text(item.content).fontSize(14).fontColor(UiPalette.TEXT_SECONDARY).margin({ top: 5 })
            }
            .width('100%')
            .padding(15)
            .backgroundColor(UiPalette.SURFACE)
            .borderRadius(12)
            .shadow({ radius: 10, color: '#10000000', offsetX: 0, offsetY: 5 })
          }
        }, (item: Note): string => item.id) // 明确 key 生成器的类型
      }
      .layoutWeight(1)
      .width('95%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}