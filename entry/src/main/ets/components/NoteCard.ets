import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'
import { TagChip } from './TagChip'

@Component
export struct NoteCard {
  @Prop title: string = ''
  @Prop content: string = ''
  @Prop dateText: string = ''
  @Prop imagePath: string = ''
  @Prop tags: string[] = []
  @Prop todoStatus: TodoVisualStatus = TodoVisualStatus.PENDING

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

  private getTagFillColor(tag: string): string {
    switch (tag) {
      case '工作':
        return UiPalette.TAG_WORK
      case '学习':
        return UiPalette.TAG_STUDY
      case '生活':
        return UiPalette.TAG_LIFE
      default:
        return UiPalette.SURFACE_MUTED
    }
  }

  build() {
    Column({ space: UiConstants.CONTENT_SPACING }) {
      Row() {
        Column({ space: 8 }) {
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.content)
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
        Column({ space: 8 }) {
          Image(this.imagePath)
            .width('100%')
            .height(160)
            .borderRadius(16)
            .objectFit(ImageFit.Cover)

          Text('已插入图片')
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(UiPalette.TEXT_MUTED)
        }
        .width('100%')
      }

      Row() {
        Row({ space: 8 }) {
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
