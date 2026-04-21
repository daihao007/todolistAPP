import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { TodoStatusSwitch } from '../components/TodoStatusSwitch'
import { TodoVisualStatus, UiConstants, UiCopywriting, UiPalette } from '../common/Constants'
import router from '@ohos.router'

@Entry
@Component
struct Index {
  @State currentStatus: TodoVisualStatus = TodoVisualStatus.PENDING

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
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Row({ space: 8 }) {
          TagChip({ label: '\u5DE5\u4F5C', selected: true, fillColor: UiPalette.TAG_WORK, textColor: UiPalette.PRIMARY })
          TagChip({ label: '\u5B66\u4E60', fillColor: UiPalette.TAG_STUDY, textColor: UiPalette.ACCENT })
          TagChip({ label: '\u751F\u6D3B', fillColor: UiPalette.TAG_LIFE, textColor: UiPalette.DANGER })
        }
        .width('100%')

        Row({ space: 10 }) {
          Button('\u6253\u5F00\u7F16\u8F91\u9875')
            .layoutWeight(1)
            .height(46)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(Color.White)
            .backgroundColor(UiPalette.PRIMARY)
            .borderRadius(UiConstants.BUTTON_RADIUS)
            .onClick(() => {
              router.pushUrl({ url: 'pages/NoteEditPage' })
            })

          Button('\u6253\u5F00\u641C\u7D22\u9875')
            .layoutWeight(1)
            .height(46)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_PRIMARY)
            .backgroundColor(UiPalette.SURFACE)
            .borderRadius(UiConstants.BUTTON_RADIUS)
            .onClick(() => {
              router.pushUrl({ url: 'pages/SearchResultPage' })
            })
        }
        .width('100%')

        Column({ space: 10 }) {
          Text('\u5F85\u529E\u72B6\u6001\u7EC4\u4EF6')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          TodoStatusSwitch({ currentStatus: $currentStatus })
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(16)
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        Column({ space: 10 }) {
          Text(UiCopywriting.NOTE_PREVIEW_TITLE)
            .fontSize(UiConstants.TITLE_SIZE)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text(UiCopywriting.NOTE_PREVIEW_BODY)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
            .lineHeight(22)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        NoteCard({
          title: '\u8F6F\u4EF6\u5DE5\u7A0B\u5C0F\u7EC4\u5206\u5DE5\u540C\u6B65',
          content: '\u7B2C\u56DB\u90E8\u5206\u8D1F\u8D23\u7EDF\u4E00\u89C6\u89C9\u57FA\u8C03\uFF0C\u4EA7\u51FA NoteCard\u3001\u6807\u7B7E\u7EC4\u4EF6\u548C\u5F85\u529E\u72B6\u6001\u5207\u6362\u7EC4\u4EF6\uFF0C\u786E\u4FDD\u9875\u9762\u4E4B\u95F4\u7684\u6837\u5F0F\u4E00\u81F4\u3002',
          dateText: '2026-04-21',
          imagePath: '/storage/media/100/local/sample-note.png',
          tags: ['\u5DE5\u4F5C', '\u5B66\u4E60'],
          todoStatus: this.currentStatus
        })

        NoteCard({
          title: '\u751F\u6D3B\u7075\u611F\u8BB0\u5F55',
          content: '\u5468\u672B\u60F3\u505A\u4E00\u4E2A\u5E26\u56FE\u7247\u7F29\u7565\u4FE1\u606F\u7684\u7075\u611F\u5361\u7247\uFF0C\u5217\u8868\u91CC\u65E2\u80FD\u770B\u6458\u8981\uFF0C\u4E5F\u80FD\u4E00\u773C\u770B\u51FA\u6807\u7B7E\u548C\u5F85\u529E\u72B6\u6001\u3002',
          dateText: '2026-04-20',
          tags: ['\u751F\u6D3B'],
          todoStatus: TodoVisualStatus.COMPLETED
        })

        Column({ space: 8 }) {
          Text('\u89C6\u89C9\u89C4\u8303\u5EFA\u8BAE')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('1. \u9875\u9762\u5DE6\u53F3\u8FB9\u8DDD\u7EDF\u4E00 16vp\uFF0C\u5361\u7247\u5706\u89D2\u7EDF\u4E00 20vp\u3002')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)

          Text('2. \u4E00\u7EA7\u6807\u9898\u5EFA\u8BAE 20fp\uFF0C\u6B63\u6587 14fp\uFF0C\u8F85\u52A9\u4FE1\u606F 12fp\u3002')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)

          Text('3. \u4E3B\u8272\u4F7F\u7528\u6E05\u723D\u84DD\uFF0C\u5B8C\u6210\u6001\u7528\u7EFF\u8272\uFF0C\u5EF6\u671F\u6001\u7528\u6A59\u8272\u3002')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(16)
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        Button('\u6253\u5F00\u5F85\u529E\u8BE6\u60C5\u793A\u4F8B')
          .width('100%')
          .height(48)
          .fontSize(UiConstants.BODY_SIZE)
          .fontColor(UiPalette.TEXT_PRIMARY)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.BUTTON_RADIUS)
          .onClick(() => {
            router.pushUrl({ url: 'pages/TodoDetailPage' })
          })
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
