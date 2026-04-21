import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import common from '@ohos.app.ability.common'

@Entry
@Component
export struct SearchResultPage {
  // 搜索条件状态
  @State keyword: string = ''
  @State startDate: string = '2026-04-01'
  @State endDate: string = '2026-04-30'

  // 数据库查询结果
  @State filteredNotes: Note[] = []

  // 初始化数据库管理器
  private db: RdbStoreManager = new RdbStoreManager(getContext(this) as common.UIAbilityContext)

  // 页面进入时初始化并首查
  async aboutToAppear() {
    await this.db.initDb()
    await this.handleSearch()
  }

  /**
   * 核心业务逻辑：组合关键词搜索与日期过滤
   */
  async handleSearch() {
    // 1. 从数据库获取模糊匹配关键词的结果 (这里内部查询的是 TABLE_NOTES)
    let dbResults = await this.db.searchNotes(this.keyword)

    // 2. 在内存中进一步过滤日期范围
    this.filteredNotes = dbResults.filter((note: Note) => {
      const noteDate = new Date(note.createTime).toISOString().split('T')[0]
      return noteDate >= this.startDate && noteDate <= this.endDate
    })
  }

  /**
   * C 同学追加逻辑：更新笔记勾选状态并同步数据库
   * @param noteId 笔记ID
   * @param isDone 是否勾选
   */
  async handleToggleStatus(noteId: string, isDone: boolean) {
    // 1. 调用 RdbStoreManager 更新 TABLE_NOTES 中的 isTodo 字段
    // 注意：根据你的逻辑，1 代表 PENDING (未完成)，0 代表 COMPLETED (已完成)
    const newStatusValue = isDone ? 0 : 1

    // ✅ 正确调用（调用你专门为笔记状态准备的方法）
    await this.db.updateNoteCompleteStatus(noteId, isDone)

    // 2. 重新触发 handleSearch 以刷新 UI 数据流
    await this.handleSearch()
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        // 头部标题区
        Column({ space: 6 }) {
          Text('搜索结果')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('已连接逻辑实验室数据库。勾选状态将实时同步至 RDB。')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        // 搜索筛选控制区
        Column({ space: 12 }) {
          Stack({ alignContent: Alignment.End }) {
            TextInput({ placeholder: '输入关键字搜索...', text: this.keyword })
              .width('100%')
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding({ left: 14, right: 40 })
              .onChange((value: string) => {
                this.keyword = value
                this.handleSearch()
              })

            if (this.keyword.length > 0) {
              Image($r('app.media.ic_clear'))
                .width(20)
                .height(20)
                .margin({ right: 12 })
                .fillColor(UiPalette.TEXT_SECONDARY)
                .onClick(() => {
                  this.keyword = ''
                  this.handleSearch()
                })
            }
          }

          Row({ space: 10 }) {
            TextInput({ placeholder: '开始日期', text: this.startDate })
              .layoutWeight(1)
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .onChange((value: string) => {
                this.startDate = value
                this.handleSearch()
              })

            TextInput({ placeholder: '结束日期', text: this.endDate })
              .layoutWeight(1)
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .onChange((value: string) => {
                this.endDate = value
                this.handleSearch()
              })
          }

          Row({ space: 8 }) {
            TagChip({ label: '关键字', selected: this.keyword.trim().length > 0, fillColor: UiPalette.PRIMARY_SOFT, textColor: UiPalette.PRIMARY })
            TagChip({ label: '日期筛选', selected: true, fillColor: UiPalette.SURFACE_MUTED, textColor: UiPalette.TEXT_SECONDARY })
            TagChip({ label: `${this.filteredNotes.length} 条结果`, selected: true, fillColor: UiPalette.SUCCESS_SOFT, textColor: UiPalette.SUCCESS })
          }
        }
        .padding(16)
        .width('100%')
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        // 结果展示区
        if (this.filteredNotes.length === 0) {
          Column({ space: 8 }) {
            Text('未找到匹配笔记').fontSize(UiConstants.SUBTITLE_SIZE).fontWeight(FontWeight.Medium)
            Text('尝试调整筛选条件').fontSize(UiConstants.BODY_SIZE).fontColor(UiPalette.TEXT_SECONDARY)
          }
          .padding(40).width('100%').backgroundColor(UiPalette.SURFACE).borderRadius(UiConstants.CARD_RADIUS).alignItems(HorizontalAlign.Center)
        } else {
          Column({ space: 12 }) {
            ForEach(this.filteredNotes, (note: Note) => {
              NoteCard({
                title: note.title,
                content: note.content,
                dateText: new Date(note.createTime).toLocaleDateString(),
                tags: note.tags ? note.tags.split(',') : [],
                // 1 是 PENDING, 0 是 COMPLETED
                todoStatus: note.isTodo === 1 ? TodoVisualStatus.PENDING : TodoVisualStatus.COMPLETED,
                imagePath: note.imagePath,
                // 这里是核心：将勾选动作回调给 handleToggleStatus
                onCheckboxChange: (isDone: boolean) => {
                  this.handleToggleStatus(note.id, isDone)
                }
              })
            }, (note: Note) => note.id + "_" + note.isTodo) // 增加 isTodo 作为 Key 的一部分，确保状态变化时渲染刷新
          }
          .width('100%')
        }
      }
      .padding(UiConstants.PAGE_PADDING)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}