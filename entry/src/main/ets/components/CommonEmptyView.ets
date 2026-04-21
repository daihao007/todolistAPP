import { UiConstants, UiPalette } from '../common/Constants'

@Component
export struct CommonEmptyView {
  @Prop title: string = '还没有内容'
  @Prop description: string = '去新建一条笔记，首页会自动显示出来。'

  build() {
    Column({ space: 10 }) {
      Text(this.title)
        .fontSize(UiConstants.SUBTITLE_SIZE)
        .fontWeight(FontWeight.Medium)
        .fontColor(UiPalette.TEXT_PRIMARY)

      Text(this.description)
        .fontSize(UiConstants.BODY_SIZE)
        .fontColor(UiPalette.TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
        .lineHeight(22)
    }
    .width('100%')
    .padding(24)
    .backgroundColor(UiPalette.SURFACE)
    .borderRadius(UiConstants.CARD_RADIUS)
  }
}
