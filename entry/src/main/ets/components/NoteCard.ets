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

  // --- C 同学新增：勾选回调接口 ---
  onCheckboxChange?: (isDone: boolean) => void

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
        // --- 1. 新增左侧勾选框 ---
        Checkbox({ name: 'noteCheck', group: 'notes' })
          .select(this.todoStatus === TodoVisualStatus.COMPLETED) // 根据传入状态决定是否勾选
          .selectedColor(UiPalette.SUCCESS)
          .width(20)
          .height(20)
          .margin({ right: 12, top: 2 }) // 微调对齐
          .onChange((value: boolean) => {
            if (this.onCheckboxChange) {
              this.onCheckboxChange(value)
            }
          })

        Column({ space: 8 }) {
          /* 标题：新增删除线逻辑 */
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.todoStatus === TodoVisualStatus.COMPLETED ? UiPalette.TEXT_MUTED : UiPalette.TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            // 关键：已完成状态显示删除线
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

        // 右上角状态胶囊（保留 D 同学的视觉设计）
        Text(this.todoStatus)
          .fontSize(UiConstants.CAPTION_SIZE)
          .fontColor(this.getStatusTextColor())
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor(this.getStatusBackgroundColor())
          .borderRadius(UiConstants.CHIP_RADIUS)
          .margin({ left: 8 })
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      // --- 下方的图片预览和标签区保持原样 ---
      if (this.imagePath.length > 0) {
        Row({ space: 10 }) {
          Stack() {
            Row().width(54).height(54).borderRadius(14).backgroundColor(UiPalette.PRIMARY_SOFT)
            Text('IMG').fontSize(UiConstants.CAPTION_SIZE).fontColor(UiPalette.PRIMARY)
          }
          Column({ space: 4 }) {
            Text('已插入本地图片').fontSize(UiConstants.CAPTION_SIZE).fontColor(UiPalette.TEXT_PRIMARY)
            Text(this.imagePath).fontSize(UiConstants.CAPTION_SIZE).fontColor(UiPalette.TEXT_MUTED).maxLines(1)
          }.alignItems(HorizontalAlign.Start).layoutWeight(1)
        }
        .padding(12).backgroundColor(UiPalette.SURFACE_MUTED).borderRadius(16).width('100%')
      }

      Row() {
        Row({ space: 8 }) {
          ForEach(this.tags, (tag: string) => {
            TagChip({ label: tag, fillColor: this.getTagFillColor(tag), textColor: UiPalette.TEXT_PRIMARY })
          }, (tag: string) => tag)
        }.layoutWeight(1)
        Text(this.dateText).fontSize(UiConstants.CAPTION_SIZE).fontColor(UiPalette.TEXT_MUTED)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(UiPalette.SURFACE)
    .borderRadius(UiConstants.CARD_RADIUS)
    .shadow({ radius: 8, color: '#140F172A', offsetY: 4 })
  }
}