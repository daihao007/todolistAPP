import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import { CommonConstants, UiConstants, UiCopywriting, UiPalette } from '../common/Constants'
import { CommonEmptyView } from '../components/CommonEmptyView'
import { NoteCard } from '../components/NoteCard'
import { NoteCardViewData, NoteViewModel } from '../viewmodel/NoteViewModel'

@Entry
@Component
struct Index {
  @State noteList: NoteCardViewData[] = []
  @State loading: boolean = true
  @State helperText: string = ''
  private noteViewModel: NoteViewModel | null = null

  aboutToAppear(): void {
    this.ensureViewModel()
    void this.loadNotes()
  }

  onPageShow(): void {
    void this.loadNotes()
  }

  private ensureViewModel(): void {
    if (this.noteViewModel !== null) {
      return
    }
    const context = getContext(this) as common.UIAbilityContext
    this.noteViewModel = new NoteViewModel(context)
  }

  private async loadNotes(): Promise<void> {
    this.ensureViewModel()
    if (this.noteViewModel === null) {
      this.loading = false
      this.helperText = '当前页面尚未准备好。'
      return
    }
    this.loading = true
    try {
      this.noteList = await this.noteViewModel.loadNotes()
      this.helperText = ''
    } catch (error) {
      this.noteList = []
      this.helperText = '读取笔记失败，请稍后重试。'
    } finally {
      this.loading = false
    }
  }

  private openCreatePage(): void {
    router.pushUrl({ url: CommonConstants.PAGE_EDIT })
  }

  private openEditPage(noteId: string): void {
    router.pushUrl({
      url: CommonConstants.PAGE_EDIT,
      params: {
        noteId: noteId
      }
    })
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        Column({ space: 6 }) {
          Text(UiCopywriting.DESIGN_TITLE)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text(UiCopywriting.DESIGN_SUBTITLE)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
            .lineHeight(22)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Row({ space: 10 }) {
          Button('新建笔记')
            .layoutWeight(1)
            .height(46)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(Color.White)
            .backgroundColor(UiPalette.PRIMARY)
            .borderRadius(UiConstants.BUTTON_RADIUS)
            .onClick(() => {
              this.openCreatePage()
            })

          Button('打开搜索页')
            .layoutWeight(1)
            .height(46)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_PRIMARY)
            .backgroundColor(UiPalette.SURFACE)
            .borderRadius(UiConstants.BUTTON_RADIUS)
            .onClick(() => {
              router.pushUrl({ url: CommonConstants.PAGE_SEARCH })
            })
        }
        .width('100%')

        if (this.helperText.length > 0) {
          Text(this.helperText)
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(UiPalette.DANGER)
        }

        Column({ space: 10 }) {
          Text('笔记列表')
            .fontSize(UiConstants.TITLE_SIZE)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('保存后的笔记会自动回到首页，并在这里显示真实数据库内容。')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
            .lineHeight(22)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        if (this.loading) {
          CommonEmptyView({
            title: '正在加载笔记',
            description: '稍等一下，首页正在从本地数据库读取内容。'
          })
        } else if (this.noteList.length === 0) {
          CommonEmptyView({
            title: '还没有笔记',
            description: '点击上方的新建笔记，保存后这里会立即显示。'
          })
        } else {
          Column({ space: 12 }) {
            ForEach(this.noteList, (note: NoteCardViewData) => {
              Column() {
                NoteCard({
                  title: note.title,
                  content: note.content,
                  dateText: note.dateText,
                  imagePath: note.imagePath,
                  tags: note.tags,
                  todoStatus: note.todoStatus
                })
              }
              .width('100%')
              .onClick(() => {
                this.openEditPage(note.id)
              })
            }, (note: NoteCardViewData) => note.id)
          }
          .width('100%')
        }
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
