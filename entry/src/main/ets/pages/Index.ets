import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import {
  CommonConstants,
  TodoVisualStatus,
  UiConstants,
  UiCopywriting,
  UiPalette
} from '../common/Constants'
import { CommonEmptyView } from '../components/CommonEmptyView'
import { NoteCard } from '../components/NoteCard'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { NoteCardViewData, NoteViewModel } from '../viewmodel/NoteViewModel'

@Entry
@Component
struct Index {
  @State noteList: NoteCardViewData[] = []
  @State loading: boolean = true
  @State helperText: string = ''

  private noteViewModel: NoteViewModel | null = null
  private db: RdbStoreManager = RdbStoreManager.getInstance(getContext(this) as common.Context)

  // ✅ 核心修复点 1：使用 async/await 确保初始化顺序
  async aboutToAppear() {
    this.ensureViewModel()
    try {
      // 必须先等数据库初始化完成
      await this.db.initDb()
      // 数据库就绪后再加载笔记
      await this.loadNotes()
    } catch (err) {
      console.error('C_LOG: 初始化失败', JSON.stringify(err))
    }
  }

  // ✅ 核心修复点 2：页面展示时（如从编辑页回来）自动刷新
  onPageShow(): void {
    void this.loadNotes()
  }

  private ensureViewModel(): void {
    if (this.noteViewModel !== null) return
    const context = getContext(this) as common.UIAbilityContext
    this.noteViewModel = new NoteViewModel(context)
  }

  /**
   * 加载数据
   */
  private async loadNotes(): Promise<void> {
    this.ensureViewModel()
    if (this.noteViewModel === null) return

    this.loading = true
    try {
      // 确保在查询前 DB 是初始化的（ViewModel 内部通常也会处理，但这里双重保险）
      this.noteList = await this.noteViewModel.loadNotes()
      this.helperText = ''
    } catch (error) {
      this.noteList = []
      this.helperText = '获取笔记失败'
    } finally {
      this.loading = false
    }
  }

  /**
   * 实验室造数据
   */
  private async seedTestData() {
    try {
      const ts = Date.now();
      const testNotes: Note[] = [
        {
          id: 'test_' + ts + '_1',
          title: '周一开会 (待办)',
          content: '点击勾选试试删除线效果',
          imagePath: '',
          tags: '工作',
          createTime: ts,
          isTodo: 1,
          todoStatus: TodoVisualStatus.PENDING
        },
        {
          id: 'test_' + ts + '_2',
          title: '已完成事项',
          content: '这是一条已经带删除线的笔记',
          imagePath: '',
          tags: '生活',
          createTime: ts,
          isTodo: 0,
          todoStatus: TodoVisualStatus.COMPLETED
        }
      ]
      // 这里的 await 保证了数据写完才刷新 UI
      await this.db.initDb()
      for (let note of testNotes) {
        await this.db.insertNote(note)
      }
      await this.loadNotes()
      AlertDialog.show({ message: '测试数据注入成功！' })
    } catch (err) {
      this.helperText = '注入失败'
    }
  }

  private openCreatePage(): void {
    router.pushUrl({ url: CommonConstants.PAGE_EDIT })
  }

  private openEditPage(noteId: string): void {
    router.pushUrl({
      url: CommonConstants.PAGE_EDIT,
      params: { noteId: noteId }
    })
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {

        // ==========================================
        // 🚀 实验室控制台
        // ==========================================
        Column({ space: 10 }) {
          Text('C 逻辑实验室 - 交互同步版')
            .fontSize(14).fontColor(Color.White).fontWeight(FontWeight.Medium)
          Row({ space: 10 }) {
            Button('注入测试数据').layoutWeight(1).height(36).fontSize(12).backgroundColor(UiPalette.SUCCESS)
              .onClick(() => this.seedTestData())
            Button('清空/刷新').layoutWeight(1).height(36).fontSize(12).backgroundColor(UiPalette.PRIMARY)
              .onClick(() => this.loadNotes())
          }
        }
        .width('100%').padding(15).backgroundColor('#1F2430').borderRadius(UiConstants.CARD_RADIUS)

        // ==========================================
        // 头部导航
        // ==========================================
        Column({ space: 6 }) {
          Text(UiCopywriting.DESIGN_TITLE).fontSize(28).fontWeight(FontWeight.Bold)
          Text(UiCopywriting.DESIGN_SUBTITLE).fontSize(UiConstants.BODY_SIZE).fontColor(UiPalette.TEXT_SECONDARY)
        }.alignItems(HorizontalAlign.Start).width('100%')

        Row({ space: 10 }) {
          Button('新建笔记').layoutWeight(1).height(46).backgroundColor(UiPalette.PRIMARY)
            .onClick(() => this.openCreatePage())
          Button('搜索').layoutWeight(1).height(46).backgroundColor(UiPalette.SURFACE).fontColor(UiPalette.TEXT_PRIMARY)
            .onClick(() => router.pushUrl({ url: CommonConstants.PAGE_SEARCH }))
        }.width('100%')

        // ==========================================
        // 列表展示区
        // ==========================================
        Column({ space: 12 }) {
          Text('我的笔记').fontSize(UiConstants.TITLE_SIZE).fontWeight(FontWeight.Bold)

          if (this.loading) {
            CommonEmptyView({ title: '加载中...', description: '正在从本地数据库同步内容' })
          } else if (this.noteList.length === 0) {
            CommonEmptyView({ title: '无笔记', description: '点击注入数据或新建笔记开始记录吧' })
          } else {
            ForEach(this.noteList, (note: NoteCardViewData) => {
              Column() {
                NoteCard({
                  title: note.title,
                  content: note.content,
                  dateText: note.dateText,
                  imagePath: note.imagePath,
                  tags: note.tags,
                  todoStatus: note.todoStatus,
                  // 勾选实时同步
                  onCheckboxChange: async (isDone: boolean) => {
                    await this.db.updateNoteCompleteStatus(note.id, isDone)
                    await this.loadNotes()
                  }
                })
              }
              .width('100%')
              .hitTestBehavior(HitTestMode.Transparent)
              .onClick(() => {
                this.openEditPage(note.id)
              })
            }, (note: NoteCardViewData) => note.id + "_" + note.todoStatus)
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .padding(UiConstants.PAGE_PADDING)
    }
    .scrollBar(BarState.Off)
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}