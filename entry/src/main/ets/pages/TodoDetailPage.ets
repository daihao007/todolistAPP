import { NoteCard } from '../components/NoteCard'
import { TodoStatusSwitch } from '../components/TodoStatusSwitch'
import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'

@Entry
@Component
export struct TodoDetailPage {
  @State todoStatus: TodoVisualStatus = TodoVisualStatus.PENDING

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        Column({ space: 6 }) {
          Text('\u5F85\u529E\u8BE6\u60C5')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('\u72B6\u6001\u5207\u6362\u7EC4\u4EF6\u5DF2\u63A5\u5165\u8BE6\u60C5\u9875\uFF0C\u53EF\u4EE5\u76F4\u63A5\u7ED9 C \u540C\u5B66\u590D\u7528\u3002')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Column({ space: 12 }) {
          Text('\u5F53\u524D\u8FDB\u5EA6')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          TodoStatusSwitch({ currentStatus: $todoStatus })
        }
        .alignItems(HorizontalAlign.Start)
        .padding(16)
        .width('100%')
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        NoteCard({
          title: '\u51C6\u5907\u6F14\u793A\u7248\u5F85\u529E\u9879',
          content: '\u628A\u72B6\u6001\u5207\u6362\u3001\u5361\u7247\u5C55\u793A\u548C\u9875\u9762\u89C6\u89C9\u7EDF\u4E00\u8D77\u6765\uFF0C\u65B9\u4FBF\u7EC4\u5185\u8054\u8C03\u3002',
          dateText: '2026-04-21',
          tags: ['\u5DE5\u4F5C'],
          todoStatus: this.todoStatus
        })
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
