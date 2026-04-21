import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { TodoStatusSwitch } from '../components/TodoStatusSwitch'
import { TodoVisualStatus, UiConstants, UiCopywriting, UiPalette } from '../common/Constants'
import router from '@ohos.router'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import common from '@ohos.app.ability.common'

@Entry
@Component
struct Index {
  @State currentStatus: TodoVisualStatus = TodoVisualStatus.PENDING
  // --- C 同学新增：驱动 UI 的真实数据源 ---
  @State allNotes: Note[] = []

  // 初始化数据库管理器
  private db: RdbStoreManager = new RdbStoreManager(getContext(this) as common.UIAbilityContext)

  async aboutToAppear() {
    await this.db.initDb()
    await this.refreshData() // 页面进入时加载一次数据
  }

  /**
   * 从数据库刷新数据并更新 UI
   */
  async refreshData() {
    const data = await this.db.queryAllNotes()
    this.allNotes = data
    console.info('C_LOG: 首页数据已刷新，当前笔记总数: ' + this.allNotes.length)
  }

  /**
   * 处理勾选逻辑：回写数据库并局部刷新
   */
  async handleToggle(noteId: string, isDone: boolean) {
    // 调用之前在 RdbStoreManager 写的更新方法 (操作 TABLE_NOTES)
    await this.db.updateNoteCompleteStatus(noteId, isDone)
    // 重新获取数据，触发 @State 变更
    await this.refreshData()
  }

  /**
   * 实验室辅助功能：快速造数据
   */
  async seedTestData() {
    try {
      console.info('C_LOG: 准备开始注入数据...');
      const timestamp = Date.now();
      const testNotes: Note[] = [
        { id: 'test_' + timestamp + '_1', title: '周一开会', content: '讨论搜索功能实现', imagePath: '', tags: '工作', createTime: timestamp, isTodo: 1 },
        { id: 'test_' + timestamp + '_2', title: '超市买菜', content: '买西红柿和鸡蛋', imagePath: '', tags: '生活', createTime: timestamp, isTodo: 0 },
        { id: 'test_' + timestamp + '_3', title: '学习ArkTS', content: '掌握RDB数据库操作', imagePath: '', tags: '学习', createTime: timestamp, isTodo: 1 }
      ]

      for (let note of testNotes) {
        await this.db.insertNote(note);
      }

      await this.refreshData() // 注入后立即刷新显示
      AlertDialog.show({ message: '数据注入成功，列表已更新！' })
    } catch (err) {
      console.error('C_LOG: 注入失败: ' + JSON.stringify(err));
    }
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {

        // ==========================================
        // 🚀 C 同学实验室控制台 (测试完记得删掉哦)
        // ==========================================
        Column({ space: 10 }) {
          Text('C 同学逻辑实验室控制台')
            .fontSize(14).fontColor(Color.White).fontWeight(FontWeight.Bold)

          Row({ space: 10 }) {
            Button('1. 注入测试数据').layoutWeight(1).height(36)
              .backgroundColor(UiPalette.SUCCESS).onClick(() => this.seedTestData())

            Button('2. 进入搜索测试').layoutWeight(1).height(36)
              .backgroundColor(UiPalette.DANGER).onClick(() => {
              router.pushUrl({ url: 'pages/SearchResultPage' })
            })
          }
        }
        .width('100%').padding(15).backgroundColor('#1F2430').borderRadius(UiConstants.CARD_RADIUS)

        // ==========================================
        // 头部欢迎区
        // ==========================================
        Column({ space: 6 }) {
          Text(UiCopywriting.DESIGN_TITLE).fontSize(28).fontWeight(FontWeight.Bold).fontColor(UiPalette.TEXT_PRIMARY)
          Text(UiCopywriting.DESIGN_SUBTITLE).fontSize(UiConstants.BODY_SIZE).fontColor(UiPalette.TEXT_SECONDARY)
        }.alignItems(HorizontalAlign.Start).width('100%')

        // 快捷操作按钮
        Row({ space: 10 }) {
          Button('打开编辑页').layoutWeight(1).height(46).backgroundColor(UiPalette.PRIMARY)
            .onClick(() => router.pushUrl({ url: 'pages/NoteEditPage' }))

          Button('打开搜索页').layoutWeight(1).height(46).backgroundColor(UiPalette.SURFACE).fontColor(UiPalette.TEXT_PRIMARY)
            .onClick(() => router.pushUrl({ url: 'pages/SearchResultPage' }))
        }.width('100%')

        // ==========================================
        // 真实数据列表区
        // ==========================================
        Column({ space: 12 }) {
          Text('我的笔记动态列表')
            .fontSize(UiConstants.SUBTITLE_SIZE).fontWeight(FontWeight.Bold).fontColor(UiPalette.TEXT_PRIMARY)

          if (this.allNotes.length === 0) {
            // 缺省状态
            Column() {
              Text('数据库空空如也').fontSize(14).fontColor(UiPalette.TEXT_MUTED)
              Text('请使用上方实验室按钮注入数据').fontSize(12).fontColor(UiPalette.TEXT_MUTED).margin({ top: 4 })
            }.width('100%').padding(40).alignItems(HorizontalAlign.Center)
          } else {
            // 动态渲染
            ForEach(this.allNotes, (note: Note) => {
              NoteCard({
                title: note.title,
                content: note.content,
                dateText: new Date(note.createTime).toLocaleDateString(),
                tags: note.tags ? note.tags.split(',') : [],
                // 1 为待办，0 为完成
                todoStatus: note.isTodo === 1 ? TodoVisualStatus.PENDING : TodoVisualStatus.COMPLETED,
                imagePath: note.imagePath,
                // ⭐ 核心回调：首页勾选实时回写
                onCheckboxChange: (isDone: boolean) => {
                  this.handleToggle(note.id, isDone)
                }
              })
            }, (note: Note) => note.id + "_" + note.isTodo) // Key 包含状态，确保样式刷新
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding(UiConstants.PAGE_PADDING)
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}