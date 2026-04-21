import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'

class SearchNoteItem {
  title: string
  content: string
  dateText: string
  tags: string[]
  todoStatus: TodoVisualStatus
  imagePath: string

  constructor(title: string, content: string, dateText: string, tags: string[], todoStatus: TodoVisualStatus, imagePath: string = '') {
    this.title = title
    this.content = content
    this.dateText = dateText
    this.tags = tags
    this.todoStatus = todoStatus
    this.imagePath = imagePath
  }
}

@Component
export struct SearchResultPage {
  @State keyword: string = ''
  @State startDate: string = '2026-04-01'
  @State endDate: string = '2026-04-30'
  private readonly noteList: SearchNoteItem[] = [
    new SearchNoteItem('\u8F6F\u4EF6\u5DE5\u7A0B\u8BFE\u8BBE', '\u6574\u7406\u7EC4\u5458\u5206\u5DE5\u548C\u9875\u9762\u89C4\u8303\uFF0C\u786E\u4FDD\u7EC4\u4EF6\u547D\u540D\u7EDF\u4E00\u3002', '2026-04-21', ['\u5B66\u4E60'], TodoVisualStatus.PENDING),
    new SearchNoteItem('\u4F1A\u8BAE\u7EAA\u8981', '\u8BB0\u5F55\u4E0B\u5468\u529F\u80FD\u5B8C\u6210\u8282\u70B9\uFF0C\u5305\u62EC\u641C\u7D22\u9875\u3001\u5F85\u529E\u5217\u8868\u548C\u6570\u636E\u5E93\u8054\u8C03\u3002', '2026-04-18', ['\u5DE5\u4F5C'], TodoVisualStatus.COMPLETED, '/storage/media/100/local/meeting.png'),
    new SearchNoteItem('\u5468\u672B\u91C7\u8D2D\u6E05\u5355', '\u751F\u6D3B\u6807\u7B7E\u4E0B\u8BB0\u5F55\u65E5\u5E38\u8D2D\u7269\u9879\uFF0C\u987A\u4FBF\u8FFD\u52A0\u4E24\u4E2A\u5EF6\u671F\u5F85\u529E\u3002', '2026-04-08', ['\u751F\u6D3B'], TodoVisualStatus.DEFERRED)
  ]

  private matchesKeyword(note: SearchNoteItem): boolean {
    if (this.keyword.trim().length === 0) {
      return true
    }
    const value: string = this.keyword.trim().toLowerCase()
    return note.title.toLowerCase().indexOf(value) >= 0 || note.content.toLowerCase().indexOf(value) >= 0
  }

  private matchesDate(note: SearchNoteItem): boolean {
    return note.dateText >= this.startDate && note.dateText <= this.endDate
  }

  private getFilteredNotes(): SearchNoteItem[] {
    return this.noteList.filter((note: SearchNoteItem) => this.matchesKeyword(note) && this.matchesDate(note))
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        Column({ space: 6 }) {
          Text('\u641C\u7D22\u7ED3\u679C')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('\u652F\u6301\u6309\u5173\u952E\u5B57\u548C\u65E5\u671F\u8303\u56F4\u7B5B\u9009\u7B14\u8BB0\u3002\u73B0\u5728\u8FD9\u4E2A\u9875\u9762\u5DF2\u7ECF\u63A5\u5165 NoteCard \u6807\u51C6\u6837\u5F0F\u3002')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Column({ space: 12 }) {
          TextInput({ placeholder: '\u8F93\u5165\u5173\u952E\u5B57', text: this.keyword })
            .width('100%')
            .height(52)
            .fontSize(UiConstants.BODY_SIZE)
            .backgroundColor(UiPalette.SURFACE_MUTED)
            .borderRadius(14)
            .padding({ left: 14, right: 14 })
            .onChange((value: string) => {
              this.keyword = value
            })

          Row({ space: 10 }) {
            TextInput({ placeholder: '\u5F00\u59CB\u65E5\u671F', text: this.startDate })
              .layoutWeight(1)
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.startDate = value
              })

            TextInput({ placeholder: '\u7ED3\u675F\u65E5\u671F', text: this.endDate })
              .layoutWeight(1)
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.endDate = value
              })
          }

          Row({ space: 8 }) {
            TagChip({ label: '\u5173\u952E\u5B57', selected: this.keyword.trim().length > 0, fillColor: UiPalette.PRIMARY_SOFT, textColor: UiPalette.PRIMARY })
            TagChip({ label: '\u65E5\u671F\u8303\u56F4', selected: true, fillColor: UiPalette.SURFACE_MUTED, textColor: UiPalette.TEXT_SECONDARY })
            TagChip({ label: `${this.getFilteredNotes().length} \u6761\u7ED3\u679C`, selected: true, fillColor: UiPalette.SUCCESS_SOFT, textColor: UiPalette.SUCCESS })
          }
        }
        .padding(16)
        .width('100%')
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        if (this.getFilteredNotes().length === 0) {
          Column({ space: 8 }) {
            Text('\u6682\u672A\u627E\u5230\u5339\u914D\u7B14\u8BB0')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            Text('\u53EF\u4EE5\u5C1D\u8BD5\u653E\u5BBD\u5173\u952E\u5B57\u6216\u8C03\u6574\u65E5\u671F\u8303\u56F4\u3002')
              .fontSize(UiConstants.BODY_SIZE)
              .fontColor(UiPalette.TEXT_SECONDARY)
          }
          .padding(20)
          .width('100%')
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)
        } else {
          Column({ space: 12 }) {
            ForEach(this.getFilteredNotes(), (note: SearchNoteItem) => {
              NoteCard({
                title: note.title,
                content: note.content,
                dateText: note.dateText,
                tags: note.tags,
                todoStatus: note.todoStatus,
                imagePath: note.imagePath
              })
            }, (note: SearchNoteItem) => note.title + note.dateText)
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
