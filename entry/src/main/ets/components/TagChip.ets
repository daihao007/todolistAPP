import { UiConstants, UiPalette } from '../common/Constants'

/* 标签胶囊组件。统一展示标签文字和选中态，适合用于标签分类、筛选条件、卡片标签。 */
@Component
export struct TagChip {
  /* 标签显示文本，例如“工作”“学习”“生活”。 */ @Prop label: string = ''
  /* 是否为选中态。选中后会使用更明显的颜色表现。 */ @Prop selected: boolean = false
  /* 未选中时的背景色。 */ @Prop fillColor: string = UiPalette.PRIMARY_SOFT
  /* 文字颜色，同时也会作为选中态的背景色。 */ @Prop textColor: string = UiPalette.PRIMARY

  build() {
    Text(this.label)
      /* 选中时使用更强的字重和反白文字，便于快速识别当前状态。 */ .fontSize(UiConstants.CAPTION_SIZE)
      .fontWeight(this.selected ? FontWeight.Medium : FontWeight.Regular)
      .fontColor(this.selected ? Color.White : this.textColor)
      .padding({ left: 10, right: 10, top: 6, bottom: 6 })
      .backgroundColor(this.selected ? this.textColor : this.fillColor)
      .borderRadius(UiConstants.CHIP_RADIUS)
  }
}
