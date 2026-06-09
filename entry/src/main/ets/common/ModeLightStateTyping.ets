import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeLightStateTyping {
  private getUserPropsById(id: string): PixArkUIInterface | undefined {
          const matches = this.propList?.filter(n => n.componentId === id)
          if (matches.length === 0) {
            return undefined;
          }
          const merged: PixArkUIInterface = {
            componentId: ""
          };
          for (const item of matches) {
            for (const key of Object.keys(item)) {
              Reflect.set(merged, key, Reflect.get(item, key))
            }
          }
          return merged
        }
  private getOverridePropsById(id: string): PixArkUIInterface[] {
          if(!this.propList){
            return [];
          }
          const prefix = new RegExp( `${id}(/)?`);
          const overrideProps = this.propList.filter(prop => prop.pathString?.startsWith(id));
          overrideProps.forEach(n=>n.pathString = n.pathString?.replace(prefix, ""))
          return overrideProps
        }
  @Prop propList: PixArkUIInterface[];
  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(8)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(4)) } }) {
        Image($r('app.media.Ellipse20'))
        .height(toPy(6))
        .width(toPx(6))
        .opacity(1)
        .flexShrink(0)
        Image($r('app.media.Ellipse30'))
        .height(toPy(8))
        .width(toPx(8))
        .opacity(1)
        .flexShrink(0)
        Image($r('app.media.Ellipse40'))
        .height(toPy(6))
        .width(toPx(6))
        .opacity(1)
        .flexShrink(0)
      }
      .id('3:257')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      Text(`Ralph is typing`)
      .fontColor('rgba(239, 241, 247, 1)')
      .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('3:256')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:256')?.width ?? toPx(146))
    .height(this.getUserPropsById('3:256')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('3:256')?.opacity ?? 1)
    .position(this.getUserPropsById('3:256')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:256')?.top ?? toPy(392),
              left: this.getUserPropsById('3:256')?.left ?? toPx(16)
              })
  }
  
}