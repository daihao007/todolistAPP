import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import {
  TodoVisualStatus,
  UiConstants,
  UiPalette
} from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { NoteViewModel, NoteCardViewData } from '../viewmodel/NoteViewModel'
import { NoteCard } from '../components/NoteCard'

class DatePickerConfig {
  placeholder: string = ''
  dateValue: string = ''
  onDateSelect: (date: string) => void = () => {}
}

@Component
struct DatePickerButton {
  placeholder: string = ''
  minDate?: string
  @Link dateValue: string

  build() {
    Row() {
      Text(this.dateValue ? this.dateValue : this.placeholder)
        .fontColor(this.dateValue ? UiPalette.TEXT_PRIMARY : '#999')
        .fontSize(UiConstants.BODY_SIZE)
    }
    .layoutWeight(1)
    .height(44)
    .padding({ left: 14, right: 14 })
    .backgroundColor(UiPalette.SURFACE)
    .borderRadius(14)
    .onClick(() => {
      let selectedDate = this.dateValue ? new Date(this.dateValue) : new Date()
      let startDate = this.minDate ? new Date(this.minDate) : new Date('2020-01-01')
      // 确保选中的默认日期不会小于最小日期限制
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
  @State noteList: NoteCardViewData[] = []
  @State loading: boolean = true
  @State username: string = '开发者'
  @State currentIndex: number = 0
  @State noteKeyword: string = ''
  @State noteStartDate: string = ''
  @State noteEndDate: string = ''
  @State todoKeyword: string = ''
  @State todoStartDate: string = ''
  @State todoEndDate: string = ''

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

  async handleToggleStatus(noteId: string, isDone: boolean) {
    const newStatusValue = isDone ? 0 : 1
    await this.db.updateNoteCompleteStatus(noteId, isDone)
    await this.loadNotes()
  }

  private filterItems(isTodo: boolean): NoteCardViewData[] {
    let filtered = this.noteList.filter(n =>
      isTodo ? n.todoStatus !== TodoVisualStatus.NONE : n.todoStatus === TodoVisualStatus.NONE
    )

    const kw = isTodo ? this.todoKeyword : this.noteKeyword
    const sd = isTodo ? this.todoStartDate : this.noteStartDate
    const ed = isTodo ? this.todoEndDate : this.noteEndDate

    if (kw.length > 0) {
      filtered = filtered.filter(n => n.title.includes(kw) || n.content.includes(kw))
    }
    if (sd.length > 0) {
      filtered = filtered.filter(n => n.dateText >= sd)
    }
    if (ed.length > 0) {
      filtered = filtered.filter(n => n.dateText <= ed)
    }

    return filtered
  }

  @Builder TabBuilder(title: string, targetIndex: number, iconRaw: string) {
    Column() {
      // 简单文本替代复杂图文即可
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? UiPalette.PRIMARY : '#999')
        .fontSize(16)
        .fontWeight(this.currentIndex === targetIndex ? FontWeight.Bold : FontWeight.Normal)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      // 笔记页面
      TabContent() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Column() {
            Column() {
              Text(`你好，${this.username}`).fontSize(28).fontWeight(FontWeight.Bold)
              Text('让创意随时随地发芽').fontSize(16).fontColor('#666').margin({ top: 8 })
            }
            .width('100%').alignItems(HorizontalAlign.Start).padding({ left: UiConstants.PAGE_PADDING, top: 40, bottom: 20 })

            Column({ space: 12 }) {
              Stack({ alignContent: Alignment.End }) {
                TextInput({ placeholder: '输入关键字搜索笔记...', text: this.noteKeyword })
                  .width('100%')
                  .height(44)
                  .fontSize(UiConstants.BODY_SIZE)
                  .backgroundColor(UiPalette.SURFACE)
                  .borderRadius(14)
                  .padding({ left: 14, right: 40 })
                  .onChange((value: string) => {
                    this.noteKeyword = value
                  })
                if (this.noteKeyword.length > 0) {
                  Text('✕')
                    .fontSize(16)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .margin({ right: 14 })
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
                    .fontSize(14)
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
                    .fontSize(14)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .onClick(() => {
                      this.noteEndDate = ''
                    })
                }
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)
            }
            .padding({ left: UiConstants.PAGE_PADDING, right: UiConstants.PAGE_PADDING, bottom: 12 })

            List({ space: 12 }) {
              ForEach(this.filterItems(false), (note: NoteCardViewData) => {
                ListItem() {
                  NoteCard({
                    title: note.title,
                    content: note.content,
                    dateText: note.dateText,
                    tags: note.tags,
                    todoStatus: note.todoStatus,
                    imagePath: note.imagePath,
                  })
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/NoteEditPage', params: { noteId: note.id } })
                })
              }, (note: NoteCardViewData) => note.id)
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: UiConstants.PAGE_PADDING, right: UiConstants.PAGE_PADDING, bottom: 80 })
          }
          .width('100%').height('100%')

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Text('+').fontSize(32).fontColor(Color.White)
          }
          .width(60)
          .height(60)
          .margin({ right: 20, bottom: 20 })
          .backgroundColor(UiPalette.PRIMARY)
          .shadow({ radius: 10, color: UiPalette.PRIMARY_SOFT, offsetY: 5 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/NoteEditPage' })
          })
        }
        .width('100%').height('100%')
      }.tabBar(this.TabBuilder('我的笔记', 0, ''))

      // 待办页面
      TabContent() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Column() {
            Column() {
              Text(`待办清单`).fontSize(28).fontWeight(FontWeight.Bold)
              Text('管理日程，高效每一天').fontSize(16).fontColor('#666').margin({ top: 8 })
            }
            .width('100%').alignItems(HorizontalAlign.Start).padding({ left: UiConstants.PAGE_PADDING, top: 40, bottom: 20 })

            Column({ space: 12 }) {
              Stack({ alignContent: Alignment.End }) {
                TextInput({ placeholder: '输入关键字搜索待办...', text: this.todoKeyword })
                  .width('100%')
                  .height(44)
                  .fontSize(UiConstants.BODY_SIZE)
                  .backgroundColor(UiPalette.SURFACE)
                  .borderRadius(14)
                  .padding({ left: 14, right: 40 })
                  .onChange((value: string) => {
                    this.todoKeyword = value
                  })
                if (this.todoKeyword.length > 0) {
                  Text('✕')
                    .fontSize(16)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .margin({ right: 14 })
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
                    .fontSize(14)
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
                    .fontSize(14)
                    .fontColor(UiPalette.TEXT_SECONDARY)
                    .onClick(() => {
                      this.todoEndDate = ''
                    })
                }
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)
            }
            .padding({ left: UiConstants.PAGE_PADDING, right: UiConstants.PAGE_PADDING, bottom: 12 })

            List({ space: 12 }) {
              ForEach(this.filterItems(true), (note: NoteCardViewData) => {
                ListItem() {
                  NoteCard({
                    title: note.title,
                    content: note.content,
                    dateText: note.dateText,
                    tags: note.tags,
                    todoStatus: note.todoStatus,
                    imagePath: note.imagePath,
                    onCheckboxChange: (isDone: boolean) => {
                      this.handleToggleStatus(note.id, isDone)
                    }
                  })
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/TodoDetailPage', params: { noteId: note.id } })
                })
              }, (note: NoteCardViewData) => note.id + "_" + note.todoStatus)
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: UiConstants.PAGE_PADDING, right: UiConstants.PAGE_PADDING, bottom: 80 })
          }
          .width('100%').height('100%')

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Text('+').fontSize(32).fontColor(Color.White)
          }
          .width(60)
          .height(60)
          .margin({ right: 20, bottom: 20 })
          .backgroundColor(UiPalette.SUCCESS)
          .shadow({ radius: 10, color: UiPalette.SUCCESS_SOFT, offsetY: 5 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/TodoDetailPage' })
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
    .backgroundColor('#F1F3F5')
  }
}