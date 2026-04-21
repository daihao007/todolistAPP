import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { CommonConstants, TodoVisualStatus, UiPalette } from '../common/Constants'
import { BusinessError } from '@ohos.base'
import common from '@ohos.app.ability.common'

@Entry
@Component
struct TestDatabasePage {
  @State searchKey: string = ''
  @State notes: Note[] = []

  // ✅ 修复 1：使用 getInstance 获取单例，并使用 as 进行类型转换
  private db: RdbStoreManager = RdbStoreManager.getInstance(getContext(this) as common.Context)

  async aboutToAppear(): Promise<void> {
    try {
      await this.db.initDb()
      await this.refresh()
    } catch (err) {
      const error: BusinessError = err as BusinessError
      console.error(`RDB_LOG: Init failed: ${error.message}`)
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
            // ✅ 修复 2：补全 todoStatus 属性，确保符合 Note 接口定义
            const newNote: Note = {
              id: Date.now().toString(),
              title: `测试-${Math.floor(Math.random() * 100)}`,
              content: 'ArkTS 强类型检查通过',
              imagePath: '',
              tags: '测试',
              createTime: Date.now(),
              isTodo: 0,
              // 必须补上这个属性，否则编译器会报 Property missing
              todoStatus: TodoVisualStatus.COMPLETED
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
        }, (item: Note): string => item.id + "_" + item.isTodo) // 建议 key 加入状态标识
      }
      .layoutWeight(1)
      .width('95%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}