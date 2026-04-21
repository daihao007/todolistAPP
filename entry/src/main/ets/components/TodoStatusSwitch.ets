import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'

/* 待办状态切换组件。通过 @Link 与父组件双向绑定，点击状态后会直接回写父组件中的状态值。 */
@Component
export struct TodoStatusSwitch {
  /* 当前待办状态，由父组件维护真实数据。 */ @Link currentStatus: TodoVisualStatus

  /* 统一维护三个状态的展示顺序，避免每个页面重复写一遍。 */
  private getOptions(): TodoVisualStatus[] {
    return [
      TodoVisualStatus.PENDING,
      TodoVisualStatus.COMPLETED,
      TodoVisualStatus.DEFERRED
    ]
  }

  /* 根据状态返回对应的高亮文字颜色。 */
  private getActiveForeground(status: TodoVisualStatus): string {
    switch (status) {
      case TodoVisualStatus.COMPLETED:
        return UiPalette.SUCCESS
      case TodoVisualStatus.DEFERRED:
        return UiPalette.WARNING
      default:
        return UiPalette.PRIMARY
    }
  }

  /* 根据状态返回对应的高亮背景色。 */
  private getActiveBackground(status: TodoVisualStatus): string {
    switch (status) {
      case TodoVisualStatus.COMPLETED:
        return UiPalette.SUCCESS_SOFT
      case TodoVisualStatus.DEFERRED:
        return UiPalette.WARNING_SOFT
      default:
        return UiPalette.PRIMARY_SOFT
    }
  }

  build() {
    Row({ space: 8 }) {
      ForEach(this.getOptions(), (status: TodoVisualStatus) => {
        Text(status)
          .fontSize(UiConstants.CAPTION_SIZE)
          .fontWeight(this.currentStatus === status ? FontWeight.Medium : FontWeight.Regular)
          .fontColor(this.currentStatus === status ? this.getActiveForeground(status) : UiPalette.TEXT_SECONDARY)
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .backgroundColor(this.currentStatus === status ? this.getActiveBackground(status) : UiPalette.SURFACE_MUTED)
          .borderRadius(UiConstants.BUTTON_RADIUS)
          .onClick(() => {
            /* 点击后直接同步到父组件，父页面会立刻刷新对应状态。 */ this.currentStatus = status
          })
      }, (status: TodoVisualStatus) => status)
    }
  }
}
