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

  // --- C 同学保留：逻辑回调 ---
  onCheckboxChange?: (isDone: boolean) => void
  onTodoStatusChange?: (status: TodoVisualStatus) => void

  private getStatusOptions(): TodoVisualStatus[] {
    return [
      TodoVisualStatus.PENDING,
      TodoVisualStatus.COMPLETED,
      TodoVisualStatus.DEFERRED
    ]
  }

  private dispatchStatusChange(status: TodoVisualStatus): void {
    if (this.onTodoStatusChange) {
      this.onTodoStatusChange(status)
      return
    }
    if (this.onCheckboxChange) {
      this.onCheckboxChange(status === TodoVisualStatus.COMPLETED)
    }
  }

  private getStatusTextColor(): string {
    switch (this.todoStatus) {
      case TodoVisualStatus.COMPLETED: return UiPalette.SUCCESS
      case TodoVisualStatus.DEFERRED: return UiPalette.WARNING
      default: return UiPalette.PRIMARY
    }
  }

  private getStatusBackgroundColor(): string {
    switch (this.todoStatus) {
      case TodoVisualStatus.COMPLETED: return UiPalette.SUCCESS_SOFT
      case TodoVisualStatus.DEFERRED: return UiPalette.WARNING_SOFT
      default: return UiPalette.PRIMARY_SOFT
    }
  }

  private getTagFillColor(tag: string): string {
    switch (tag) {
      case '工作': return UiPalette.TAG_WORK
      case '学习': return UiPalette.TAG_STUDY
      case '生活': return UiPalette.TAG_LIFE
      default: return UiPalette.SURFACE_MUTED
    }
  }

  build() {
    Column({ space: UiConstants.CONTENT_SPACING }) {
      Row() {
        // --- C 同学保留：交互 Checkbox ---
        if (this.todoStatus !== TodoVisualStatus.NONE) {
          Checkbox({ name: 'noteCheck', group: 'notes' })
            .select(this.todoStatus === TodoVisualStatus.COMPLETED)
            .selectedColor(UiPalette.SUCCESS)
            .width(20)
            .height(20)
            .margin({ right: 12, top: 2 })
            .onChange((value: boolean) => {
              this.dispatchStatusChange(value ? TodoVisualStatus.COMPLETED : TodoVisualStatus.PENDING)
            })
        }

        Column({ space: 8 }) {
          /* 标题：保留删除线逻辑 */
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.todoStatus === TodoVisualStatus.COMPLETED ? UiPalette.TEXT_MUTED : UiPalette.TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .decoration({
              type: this.todoStatus === TodoVisualStatus.COMPLETED ? TextDecorationType.LineThrough : TextDecorationType.None,
              color: UiPalette.TEXT_MUTED
            })

          Text(this.content)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
            .lineHeight(22)
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 右上角状态胶囊：采用 B 同学微调后的内边距
        if (this.todoStatus !== TodoVisualStatus.NONE) {
          Text(this.todoStatus)
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(this.getStatusTextColor())
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(this.getStatusBackgroundColor())
            .borderRadius(UiConstants.CHIP_RADIUS)
            .margin({ left: 12 })
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      if (this.todoStatus !== TodoVisualStatus.NONE) {
        Row({ space: 8 }) {
          ForEach(this.getStatusOptions(), (status: TodoVisualStatus) => {
            Text(status)
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontWeight(this.todoStatus === status ? FontWeight.Medium : FontWeight.Regular)
              .fontColor(this.todoStatus === status ? this.getStatusTextColor() : UiPalette.TEXT_SECONDARY)
              .padding({ left: 10, right: 10, top: 6, bottom: 6 })
              .backgroundColor(this.todoStatus === status ? this.getStatusBackgroundColor() : UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.CHIP_RADIUS)
              .onClick(() => {
                this.dispatchStatusChange(status)
              })
          }, (status: TodoVisualStatus) => status)
        }
        .width('100%')
      }

      // --- B 同学贡献：真实的图片展示组件 ---
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
    .borderWidth(1)
    .borderColor(UiPalette.BORDER)
    .shadow({
      radius: UiConstants.CARD_SHADOW_RADIUS,
      color: '#105C5454',
      offsetX: 0,
      offsetY: 6
    })
  }
}
