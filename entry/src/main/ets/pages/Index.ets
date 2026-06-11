import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import {
  Breakpoint,
  CommonConstants,
  TodoVisualStatus,
  UiConstants,
  UiPalette
} from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { NoteViewModel, NoteCardViewData } from '../viewmodel/NoteViewModel'
import { NoteCard } from '../components/NoteCard'
import { CommonEmptyView } from '../components/CommonEmptyView'
import { TagChip } from '../components/TagChip'
import { NoteEditPage } from './NoteEditPage'
import { TodoDetailPage } from './TodoDetailPage'
import { BreakpointUtil } from '../utils/BreakpointUtil'
import { PreferenceUtil } from '../utils/PreferenceUtil'
import promptAction from '@ohos.promptAction'

@Component
struct DatePickerButton {
  placeholder: string = ''
  minDate?: string
  @Link dateValue: string

  build() {
    Row() {
      Text(this.dateValue ? this.dateValue : this.placeholder)
        .fontColor(this.dateValue ? UiPalette.TEXT_PRIMARY : UiPalette.TEXT_MUTED)
        .fontSize(UiConstants.BODY_SIZE)
    }
    .layoutWeight(1)
    .height(48)
    .padding({ left: 16, right: 16 })
    .backgroundColor(UiPalette.SURFACE)
    .borderRadius(999)
    .onClick(() => {
      let selectedDate = this.dateValue ? new Date(this.dateValue) : new Date()
      let startDate = this.minDate ? new Date(this.minDate) : new Date('2020-01-01')
      if (selectedDate.getTime() < startDate.getTime()) {
        selectedDate = startDate
      }

      DatePickerDialog.show({
        start: startDate,
        end: new Date('2050-12-31'),
        selected: selectedDate,
        onAccept: (value: DatePickerResult) => {
          let m = (value.month! + 1).toString().padStart(2, '0')
          let d = value.day!.toString().padStart(2, '0')
          this.dateValue = `${value.year}-${m}-${d}`
        }
      })
    })
  }
}

@Entry
@Component
struct Index {
  @StorageProp('currentBreakpoint') currentBreakpoint: Breakpoint = Breakpoint.SM
  @State noteList: NoteCardViewData[] = []
  @State loading: boolean = true
  @State username: string = '开发者'
  @State currentUser: string = ''
  @State nicknameDraft: string = ''
  @State editingNickname: boolean = false
  @State currentIndex: number = 0
  @State noteKeyword: string = ''
  @State noteStartDate: string = ''
  @State noteEndDate: string = ''
  @State todoKeyword: string = ''
  @State todoStartDate: string = ''
  @State todoEndDate: string = ''
  @State selectedTags: string[] = []
  @State filterTags: string[] = ['全部'].concat(CommonConstants.DEFAULT_TAGS)
  @State selectedNoteId: string = ''
  @State selectedType: string = 'note'
  @State showEmbeddedEditor: boolean = false

  private noteViewModel: NoteViewModel | null = null
  private db: RdbStoreManager = RdbStoreManager.getInstance(getContext(this) as common.Context)

  async aboutToAppear() {
    this.ensureViewModel()
    this.applyRouteParams()
    try {
      await this.loadCurrentUser()
      await this.db.initDb()
      await this.loadNotes()
    } catch (err) {
      console.error('E_Log: 初始化失败')
    }
  }

  onPageShow(): void {
    this.applyRouteParams()
    this.loadCurrentUser().catch((err: Error) => {
      console.error('E_Log: 用户信息读取失败 ' + err.message)
    })
    this.loadNotes().catch((err: Error) => {
      console.error('E_Log: 刷新失败 ' + err.message)
    })
  }

  private async loadCurrentUser(): Promise<void> {
    const context = getContext(this) as common.Context
    const currentUser = await PreferenceUtil.getString(context, 'CURRENT_USER', '')
    this.currentUser = currentUser
    if (currentUser.length === 0) {
      this.username = '开发者'
      this.nicknameDraft = ''
      return
    }
    const nickname = await PreferenceUtil.getString(context, `NICKNAME_${currentUser}`, '')
    const displayName = nickname.trim().length > 0 ? nickname.trim() : currentUser
    this.username = displayName
    this.nicknameDraft = displayName
  }

  private async saveNickname(): Promise<void> {
    const nextNickname = this.nicknameDraft.trim()
    if (nextNickname.length === 0) {
      promptAction.showToast({ message: '昵称不能为空' })
      return
    }
    if (this.currentUser.length === 0) {
      promptAction.showToast({ message: '请先登录' })
      return
    }
    const context = getContext(this) as common.Context
    await PreferenceUtil.putString(context, `NICKNAME_${this.currentUser}`, nextNickname)
    this.username = nextNickname
    this.editingNickname = false
    promptAction.showToast({ message: '昵称已更新' })
  }

  private handleLogout(): void {
    router.replaceUrl({ url: 'pages/LoginPage' })
  }

  private applyRouteParams(): void {
    const params = router.getParams() as Record<string, string | number> | undefined
    if (params === undefined) {
      return
    }

    const targetTab = params.targetTab
    if (targetTab === 0 || targetTab === '0') {
      this.currentIndex = 0
      return
    }

    if (targetTab === 1 || targetTab === '1') {
      this.currentIndex = 1
    }
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

  private getPagePadding(): number {
    return BreakpointUtil.getPagePadding(this.currentBreakpoint)
  }

  private getGridSpan(): number {
    return BreakpointUtil.getGridSpan(this.currentBreakpoint)
  }

  private getGridColumns(): number {
    return BreakpointUtil.getColumns(this.currentBreakpoint) * 4
  }

  private async handleToggleStatus(noteId: string, isDone: boolean): Promise<void> {
    await this.db.updateNoteCompleteStatus(noteId, isDone)
    await this.loadNotes()
  }

  private async handleStatusChange(noteId: string, status: TodoVisualStatus): Promise<void> {
    await this.db.updateNoteTodoStatus(noteId, status)
    await this.loadNotes()
  }

  private openNote(noteId: string, isTodo: boolean): void {
    if (this.currentBreakpoint !== Breakpoint.LG) {
      router.pushUrl({
        url: isTodo ? 'pages/TodoDetailPage' : 'pages/NoteEditPage',
        params: { noteId: noteId }
      })
      return
    }
    this.selectedNoteId = noteId
    this.selectedType = isTodo ? 'todo' : 'note'
    this.showEmbeddedEditor = true
  }

  private createNote(isTodo: boolean): void {
    if (this.currentBreakpoint !== Breakpoint.LG) {
      router.pushUrl({ url: isTodo ? 'pages/TodoDetailPage' : 'pages/NoteEditPage' })
      return
    }
    this.selectedNoteId = ''
    this.selectedType = isTodo ? 'todo' : 'note'
    this.showEmbeddedEditor = true
  }

  private updateSelectedDraft(title: string, content: string, imagePath: string, tags: string[],
    todoStatus?: TodoVisualStatus): void {
    if (this.selectedNoteId.length === 0) {
      return
    }
    this.noteList = this.noteList.map((note: NoteCardViewData) => {
      if (note.id !== this.selectedNoteId) {
        return note
      }
      return new NoteCardViewData(
        note.id,
        title,
        content,
        note.dateText,
        imagePath,
        tags,
        todoStatus === undefined ? note.todoStatus : todoStatus
      )
    })
  }

  private async handleEmbeddedSaved(noteId: string): Promise<void> {
    this.selectedNoteId = noteId
    this.showEmbeddedEditor = true
    await this.loadNotes()
  }

  private async handleEmbeddedDeleted(): Promise<void> {
    this.selectedNoteId = ''
    this.showEmbeddedEditor = false
    await this.loadNotes()
  }

  private filterItems(isTodo: boolean): NoteCardViewData[] {
    let filtered = this.noteList.filter((note: NoteCardViewData) =>
      isTodo ? note.todoStatus !== TodoVisualStatus.NONE : note.todoStatus === TodoVisualStatus.NONE
    )

    const keyword = isTodo ? this.todoKeyword : this.noteKeyword
    const startDate = isTodo ? this.todoStartDate : this.noteStartDate
    const endDate = isTodo ? this.todoEndDate : this.noteEndDate

    if (keyword.length > 0) {
      filtered = filtered.filter((note: NoteCardViewData) => note.title.includes(keyword) || note.content.includes(keyword))
    }
    if (startDate.length > 0) {
      filtered = filtered.filter((note: NoteCardViewData) => note.dateText >= startDate)
    }
    if (endDate.length > 0) {
      filtered = filtered.filter((note: NoteCardViewData) => note.dateText <= endDate)
    }
    if (this.selectedTags.length > 0) {
      filtered = filtered.filter((note: NoteCardViewData) => {
        return note.tags.some((tag: string) => this.selectedTags.indexOf(tag) >= 0)
      })
    }

    return filtered
  }

  private toggleTagFilter(tag: string): void {
    if (tag === '全部') {
      this.selectedTags = []
      return
    }
    if (this.selectedTags.indexOf(tag) >= 0) {
      this.selectedTags = this.selectedTags.filter((item: string) => item !== tag)
    } else {
      this.selectedTags = [...this.selectedTags, tag]
    }
  }

  private isTagFilterSelected(tag: string): boolean {
    return tag === '全部' ? this.selectedTags.length === 0 : this.selectedTags.indexOf(tag) >= 0
  }

  @Builder TabBuilder(title: string, targetIndex: number, iconRaw: string) {
    Column() {
      Column({ space: 2 }) {
        Text(title)
          .fontColor(this.currentIndex === targetIndex ? UiPalette.TEXT_PRIMARY : UiPalette.TEXT_MUTED)
          .fontSize(14)
          .fontWeight(this.currentIndex === targetIndex ? FontWeight.Bold : FontWeight.Medium)

        if (this.currentIndex === targetIndex) {
          Text('•')
            .fontSize(14)
            .fontColor(UiPalette.PRIMARY)
        }
      }
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(this.currentIndex === targetIndex ? UiPalette.PRIMARY_SOFT : UiPalette.SURFACE)
      .borderRadius(999)
      .shadow({
        radius: this.currentIndex === targetIndex ? 10 : 0,
        color: '#18FFB7C5',
        offsetY: 4
      })
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
    })
  }

  @Builder TagFilterBar() {
    Scroll() {
      Row({ space: 8 }) {
        ForEach(this.filterTags, (tag: string) => {
          Row() {
            TagChip({
              label: tag,
              selected: this.isTagFilterSelected(tag),
              fillColor: UiPalette.SURFACE_MUTED,
              textColor: tag === '全部' ? UiPalette.PRIMARY : UiPalette.TEXT_PRIMARY
            })
          }
          .onClick(() => {
            this.toggleTagFilter(tag)
          })
        }, (tag: string) => tag)
      }
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }

  @Builder PhoneLayout() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Column() {
            Row() {
              Column({ space: 8 }) {
                if (this.editingNickname) {
                  Row({ space: 8 }) {
                    Text('你好，')
                      .fontSize(UiConstants.TITLE_SIZE)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(UiPalette.TEXT_PRIMARY)

                    TextInput({ placeholder: '输入昵称', text: this.nicknameDraft })
                      .width(180)
                      .height(40)
                      .fontSize(18)
                      .backgroundColor(UiPalette.SURFACE)
                      .borderRadius(12)
                      .padding({ left: 12, right: 12 })
                      .onChange((value: string) => {
                        this.nicknameDraft = value
                      })
                  }
                } else {
                  Text(`你好，${this.username}`)
                    .fontSize(UiConstants.TITLE_SIZE)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(UiPalette.TEXT_PRIMARY)
                }

                Text('今日份的阳光与灵感已查收')
                  .fontSize(16)
                  .fontColor(UiPalette.TEXT_SECONDARY)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Row({ space: 8 }) {
                if (this.editingNickname) {
                  Button('保存')
                    .height(36)
                    .fontSize(14)
                    .backgroundColor(UiPalette.PRIMARY)
                    .fontColor(Color.White)
                    .borderRadius(18)
                    .onClick(() => {
                      void this.saveNickname()
                    })

                  Button('取消')
                    .height(36)
                    .fontSize(14)
                    .backgroundColor(UiPalette.SURFACE)
                    .fontColor(UiPalette.TEXT_PRIMARY)
                    .borderRadius(18)
                    .onClick(() => {
                      this.nicknameDraft = this.username
                      this.editingNickname = false
                    })
                } else {
                  Button('改昵称')
                    .height(36)
                    .fontSize(14)
                    .backgroundColor(UiPalette.SURFACE)
                    .fontColor(UiPalette.TEXT_PRIMARY)
                    .borderRadius(18)
                    .onClick(() => {
                      this.editingNickname = true
                    })

                  Button('登出')
                    .height(36)
                    .fontSize(14)
                    .backgroundColor(UiPalette.SURFACE)
                    .fontColor(UiPalette.TEXT_PRIMARY)
                    .borderRadius(18)
                    .onClick(() => {
                      this.handleLogout()
                    })
                }
              }
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .padding({ left: this.getPagePadding(), right: this.getPagePadding(), top: 40, bottom: 20 })

            Column({ space: 12 }) {
              Stack({ alignContent: Alignment.End }) {
                TextInput({ placeholder: '输入关键字搜索笔记...', text: this.noteKeyword })
                  .width('100%')
                  .height(48)
                  .fontSize(UiConstants.BODY_SIZE)
                  .backgroundColor(UiPalette.SURFACE)
                  .borderRadius(999)
                  .padding({ left: 20, right: 40 })
                  .placeholderColor(UiPalette.TEXT_MUTED)
                  .fontColor(UiPalette.TEXT_PRIMARY)
                  .onChange((value: string) => {
                    this.noteKeyword = value
                  })
                if (this.noteKeyword.length > 0) {
                  Text('✕')
                    .fontSize(18)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .margin({ right: 16 })
                    .onClick(() => {
                      this.noteKeyword = ''
                    })
                }
              }

              Row({ space: 10 }) {
                DatePickerButton({
                  placeholder: '开始日期',
                  dateValue: $noteStartDate
                })
                if (this.noteStartDate.length > 0) {
                  Text('✕')
                    .fontSize(16)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .onClick(() => {
                      this.noteStartDate = ''
                    })
                }

                DatePickerButton({
                  placeholder: '结束日期',
                  minDate: this.noteStartDate,
                  dateValue: $noteEndDate
                })
                if (this.noteEndDate.length > 0) {
                  Text('✕')
                    .fontSize(16)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .onClick(() => {
                      this.noteEndDate = ''
                    })
                }
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              this.TagFilterBar()
            }
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .margin({ left: this.getPagePadding(), right: this.getPagePadding(), bottom: 12 })
            .backgroundColor(UiPalette.SURFACE)
            .borderRadius(20)
            .shadow({ radius: 12, color: '#12CABFBF', offsetY: 6 })

            Scroll() {
              GridRow({ columns: this.getGridColumns(), gutter: { x: 12, y: 12 } }) {
                ForEach(this.filterItems(false), (note: NoteCardViewData) => {
                  GridCol({ span: this.getGridSpan() }) {
                  NoteCard({
                    title: note.title,
                    content: note.content,
                    dateText: note.dateText,
                    tags: note.tags,
                    todoStatus: note.todoStatus,
                    imagePath: note.imagePath
                  })
                  }
                  .onClick(() => {
                    this.openNote(note.id, false)
                  })
                }, (note: NoteCardViewData) => note.id)
              }
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: this.getPagePadding(), right: this.getPagePadding(), bottom: 80 })
            .scrollBar(BarState.Off)
          }
          .width('100%').height('100%')
          .backgroundColor(UiPalette.PAGE_BACKGROUND)

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Text('+').fontSize(36).fontColor(UiPalette.TEXT_PRIMARY).fontWeight(FontWeight.Regular)
          }
          .width(64)
          .height(64)
          .margin({ right: 24, bottom: 24 })
          .backgroundColor(UiPalette.PRIMARY)
          .shadow({ radius: 16, color: '#40FFB7C5', offsetY: 8 }) // 柔和透明的樱花粉阴影
          .onClick(() => {
            this.createNote(false)
          })
        }
        .width('100%').height('100%')
      }.tabBar(this.TabBuilder('我的笔记', 0, ''))

      TabContent() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Column() {
            Column() {
              Text('待办清单').fontSize(UiConstants.TITLE_SIZE).fontWeight(FontWeight.Bold).fontColor(UiPalette.TEXT_PRIMARY)
              Text('规划日程，享受划掉任务的快乐').fontSize(16).fontColor(UiPalette.TEXT_SECONDARY).margin({ top: 8 })
            }
            .width('100%').alignItems(HorizontalAlign.Start).padding({ left: this.getPagePadding(), right: this.getPagePadding(), top: 40, bottom: 20 })

            Column({ space: 12 }) {
              Stack({ alignContent: Alignment.End }) {
                TextInput({ placeholder: '输入你想找的待办...', text: this.todoKeyword })
                  .width('100%')
                  .height(48)
                  .fontSize(UiConstants.BODY_SIZE)
                  .backgroundColor(UiPalette.SURFACE)
                  .borderRadius(999)
                  .padding({ left: 20, right: 40 })
                  .placeholderColor(UiPalette.TEXT_MUTED)
                  .fontColor(UiPalette.TEXT_PRIMARY)
                  .onChange((value: string) => {
                    this.todoKeyword = value
                  })
                if (this.todoKeyword.length > 0) {
                  Text('✕')
                    .fontSize(18)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .margin({ right: 16 })
                    .onClick(() => {
                      this.todoKeyword = ''
                    })
                }
              }

              Row({ space: 10 }) {
                DatePickerButton({
                  placeholder: '开始日期',
                  dateValue: $todoStartDate
                })
                if (this.todoStartDate.length > 0) {
                  Text('✕')
                    .fontSize(16)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .onClick(() => {
                      this.todoStartDate = ''
                    })
                }

                DatePickerButton({
                  placeholder: '结束日期',
                  minDate: this.todoStartDate,
                  dateValue: $todoEndDate
                })
                if (this.todoEndDate.length > 0) {
                  Text('✕')
                    .fontSize(16)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .onClick(() => {
                      this.todoEndDate = ''
                    })
                }
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)

              this.TagFilterBar()
            }
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .margin({ left: this.getPagePadding(), right: this.getPagePadding(), bottom: 12 })
            .backgroundColor(UiPalette.SURFACE)
            .borderRadius(20)
            .shadow({ radius: 12, color: '#12CABFBF', offsetY: 6 })

            Scroll() {
              GridRow({ columns: this.getGridColumns(), gutter: { x: 12, y: 12 } }) {
                ForEach(this.filterItems(true), (note: NoteCardViewData) => {
                  GridCol({ span: this.getGridSpan() }) {
                  NoteCard({
                    title: note.title,
                    content: note.content,
                    dateText: note.dateText,
                    tags: note.tags,
                    todoStatus: note.todoStatus,
                    imagePath: note.imagePath,
                    onCheckboxChange: (isDone: boolean) => {
                      void this.handleToggleStatus(note.id, isDone)
                    },
                    onTodoStatusChange: (status: TodoVisualStatus) => {
                      void this.handleStatusChange(note.id, status)
                    }
                  })
                  }
                  .onClick(() => {
                    this.openNote(note.id, true)
                  })
                }, (note: NoteCardViewData) => note.id + '_' + note.todoStatus)
              }
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: this.getPagePadding(), right: this.getPagePadding(), bottom: 80 })
            .scrollBar(BarState.Off)
          }
          .width('100%').height('100%')
          .backgroundColor(UiPalette.PAGE_BACKGROUND)

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Text('+').fontSize(36).fontColor(UiPalette.TEXT_PRIMARY).fontWeight(FontWeight.Regular)
          }
          .width(64)
          .height(64)
          .margin({ right: 24, bottom: 24 })
          .backgroundColor(UiPalette.SUCCESS) // 待办清单页用绿色按钮区分
          .shadow({ radius: 16, color: '#40B5D5C5', offsetY: 8 })
          .onClick(() => {
            this.createNote(true)
          })
        }
        .width('100%').height('100%')
      }.tabBar(this.TabBuilder('待办事项', 1, ''))
    }
    .onChange((index: number) => {
      this.currentIndex = index
    })
    .width('100%')
    .height('100%')
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }

  @Builder TabletSideBar() {
    Column({ space: 12 }) {
      Text(`你好，${this.username}`)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(UiPalette.TEXT_PRIMARY)
        .width('100%')

      Row({ space: 8 }) {
        Button('我的笔记')
          .layoutWeight(1)
          .height(40)
          .fontColor(this.currentIndex === 0 ? Color.White : UiPalette.TEXT_PRIMARY)
          .backgroundColor(this.currentIndex === 0 ? UiPalette.PRIMARY : UiPalette.SURFACE_MUTED)
          .onClick(() => {
            this.currentIndex = 0
            this.selectedType = 'note'
            this.showEmbeddedEditor = false
            this.selectedNoteId = ''
          })

        Button('待办事项')
          .layoutWeight(1)
          .height(40)
          .fontColor(this.currentIndex === 1 ? Color.White : UiPalette.TEXT_PRIMARY)
          .backgroundColor(this.currentIndex === 1 ? UiPalette.SUCCESS : UiPalette.SURFACE_MUTED)
          .onClick(() => {
            this.currentIndex = 1
            this.selectedType = 'todo'
            this.showEmbeddedEditor = false
            this.selectedNoteId = ''
          })
      }
      .width('100%')

      TextInput({
        placeholder: this.currentIndex === 0 ? '搜索笔记...' : '搜索待办...',
        text: this.currentIndex === 0 ? this.noteKeyword : this.todoKeyword
      })
        .width('100%')
        .height(UiConstants.COMPACT_CONTROL_HEIGHT)
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(999)
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          if (this.currentIndex === 0) {
            this.noteKeyword = value
          } else {
            this.todoKeyword = value
          }
        })

      this.TagFilterBar()

      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.filterItems(this.currentIndex === 1), (note: NoteCardViewData) => {
            Column() {
              NoteCard({
                title: note.title,
                content: note.content,
                dateText: note.dateText,
                tags: note.tags,
                todoStatus: note.todoStatus,
                imagePath: note.imagePath,
                onCheckboxChange: (isDone: boolean) => {
                  if (this.currentIndex === 1) {
                    void this.handleToggleStatus(note.id, isDone)
                  }
                },
                onTodoStatusChange: (status: TodoVisualStatus) => {
                  if (this.currentIndex === 1) {
                    void this.handleStatusChange(note.id, status)
                  }
                }
              })
            }
            .width('100%')
            .padding(2)
            .border({
              width: this.selectedNoteId === note.id && this.showEmbeddedEditor ? 2 : 0,
              color: this.currentIndex === 0 ? UiPalette.PRIMARY : UiPalette.SUCCESS,
              radius: UiConstants.CARD_RADIUS
            })
            .onClick(() => {
              this.openNote(note.id, this.currentIndex === 1)
            })
          }, (note: NoteCardViewData) =>
            `${note.id}_${note.todoStatus}_${note.title}_${note.content}_${note.imagePath}_${note.tags.join(',')}`)

          if (!this.loading && this.filterItems(this.currentIndex === 1).length === 0) {
            CommonEmptyView({
              title: this.currentIndex === 0 ? '还没有笔记' : '还没有待办',
              description: '点击下方按钮新建一条内容。'
            })
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)

      Button(this.currentIndex === 0 ? '+ 新建笔记' : '+ 新建待办')
        .width('100%')
        .height(48)
        .fontColor(Color.White)
        .backgroundColor(this.currentIndex === 0 ? UiPalette.PRIMARY : UiPalette.SUCCESS)
        .borderRadius(UiConstants.BUTTON_RADIUS)
        .onClick(() => {
          this.createNote(this.currentIndex === 1)
        })
    }
    .width('100%')
    .height('100%')
    .padding(UiConstants.CARD_PADDING)
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder TabletDetail() {
    if (!this.showEmbeddedEditor) {
      Column() {
        CommonEmptyView({
          title: this.currentIndex === 0 ? '选择一个笔记开始编辑' : '选择一个待办查看详情',
          description: '左侧列表会保持可见，编辑和预览会显示在这里。'
        })
        .constraintSize({ maxWidth: 420 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .padding(32)
      .backgroundColor(UiPalette.PAGE_BACKGROUND)
    } else {
      Scroll() {
        if (this.selectedType === 'note') {
          NoteEditPage({
            noteId: this.selectedNoteId,
            isEmbedded: true,
            onSaved: (noteId: string) => {
              void this.handleEmbeddedSaved(noteId)
            },
            onDeleted: () => {
              void this.handleEmbeddedDeleted()
            },
            onDraftChange: (title: string, content: string, imagePath: string, tags: string[]) => {
              this.updateSelectedDraft(title, content, imagePath, tags)
            }
          })
        } else {
          TodoDetailPage({
            noteId: this.selectedNoteId,
            isEmbedded: true,
            onSaved: (noteId: string) => {
              void this.handleEmbeddedSaved(noteId)
            },
            onDeleted: () => {
              void this.handleEmbeddedDeleted()
            },
            onDraftChange: (title: string, content: string, imagePath: string, tags: string[],
              todoStatus: TodoVisualStatus) => {
              this.updateSelectedDraft(title, content, imagePath, tags, todoStatus)
            }
          })
        }
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .backgroundColor(UiPalette.PAGE_BACKGROUND)
    }
  }

  @Builder TabletLayout() {
    SideBarContainer(SideBarContainerType.Embed) {
      this.TabletSideBar()
      this.TabletDetail()
    }
    .sideBarWidth(360)
    .minSideBarWidth(360)
    .maxSideBarWidth(360)
    .showSideBar(true)
    .showControlButton(false)
    .width('100%')
    .height('100%')
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }

  build() {
    Stack() {
      if (this.currentBreakpoint === Breakpoint.LG) {
        this.TabletLayout()
      } else {
        this.PhoneLayout()
      }
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldArea: Area, newArea: Area) => {
      BreakpointUtil.updateByWidth(newArea.width.toString())
    })
  }
}
