import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'
import { TagChip } from './TagChip'

/* 笔记卡片组件。统一承载标题、摘要、标签、日期、图片信息和待办状态，可用于首页、搜索页和详情预览。 */
@Component
export struct NoteCard {
  /* 笔记标题。 */ @Prop title: string = ''
  /* 笔记正文摘要。 */ @Prop content: string = ''
  /* 日期文本，建议传入格式化后的字符串，例如 2026-04-21。 */ @Prop dateText: string = ''
  /* 图片路径。当前版本用于展示“已插入图片”的占位信息。 */ @Prop imagePath: string = ''
  /* 标签列表，例如 ['工作', '学习']。 */ @Prop tags: string[] = []
  /* 待办状态，用于右上角状态胶囊显示。 */ @Prop todoStatus: TodoVisualStatus = TodoVisualStatus.PENDING

  /* 根据待办状态返回对应的文字色。 */
  private getStatusTextColor(): string {
    switch (this.todoStatus) {
      case TodoVisualStatus.COMPLETED:
        return UiPalette.SUCCESS
      case TodoVisualStatus.DEFERRED:
        return UiPalette.WARNING
      default:
        return UiPalette.PRIMARY
    }
  }

  /* 根据待办状态返回对应的浅色背景，方便状态展示更柔和。 */
  private getStatusBackgroundColor(): string {
    switch (this.todoStatus) {
      case TodoVisualStatus.COMPLETED:
        return UiPalette.SUCCESS_SOFT
      case TodoVisualStatus.DEFERRED:
        return UiPalette.WARNING_SOFT
      default:
        return UiPalette.PRIMARY_SOFT
    }
  }

  /* 对常用标签使用固定配色，保证全组页面风格一致。 */
  private getTagFillColor(tag: string): string {
    switch (tag) {
      case '\u5DE5\u4F5C':
        return UiPalette.TAG_WORK
      case '\u5B66\u4E60':
        return UiPalette.TAG_STUDY
      case '\u751F\u6D3B':
        return UiPalette.TAG_LIFE
      default:
        return UiPalette.SURFACE_MUTED
    }
  }

  build() {
    Column({ space: UiConstants.CONTENT_SPACING }) {
      Row() {
        Column({ space: 8 }) {
          /* 标题限制为一行，避免列表中的卡片高度不统一。 */ Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          /* 正文摘要最多展示三行，兼顾信息量和可读性。 */ Text(this.content)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
            .lineHeight(22)
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text(this.todoStatus)
          .fontSize(UiConstants.CAPTION_SIZE)
          .fontColor(this.getStatusTextColor())
          .padding({ left: 10, right: 10, top: 6, bottom: 6 })
          .backgroundColor(this.getStatusBackgroundColor())
          .borderRadius(UiConstants.CHIP_RADIUS)
          .margin({ left: 12 })
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      if (this.imagePath.length > 0) {
        /* 后续如果接入真实缩略图，这一块可以直接替换成 Image 组件。 */
        Row({ space: 10 }) {
          Stack() {
            Row()
              .width(54)
              .height(54)
              .borderRadius(14)
              .backgroundColor(UiPalette.PRIMARY_SOFT)

            Text('IMG')
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.PRIMARY)
              .fontWeight(FontWeight.Medium)
          }

          Column({ space: 4 }) {
            Text('\u5DF2\u63D2\u5165\u672C\u5730\u56FE\u7247')
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_PRIMARY)

            Text(this.imagePath)
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_MUTED)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .padding(12)
        .backgroundColor(UiPalette.SURFACE_MUTED)
        .borderRadius(16)
        .width('100%')
      }

      Row() {
        Row({ space: 8 }) {
          /* 标签区复用 TagChip，减少重复样式代码。 */
          ForEach(this.tags, (tag: string) => {
            TagChip({
              label: tag,
              fillColor: this.getTagFillColor(tag),
              textColor: UiPalette.TEXT_PRIMARY
            })
          }, (tag: string) => tag)
        }
        .layoutWeight(1)

        Text(this.dateText)
          .fontSize(UiConstants.CAPTION_SIZE)
          .fontColor(UiPalette.TEXT_MUTED)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(UiPalette.SURFACE)
    .borderRadius(UiConstants.CARD_RADIUS)
    .shadow({
      radius: UiConstants.CARD_SHADOW_RADIUS,
      color: '#140F172A',
      offsetX: 0,
      offsetY: 8
    })
  }
}
