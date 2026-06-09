import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeLight7 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(8)) } }) {
      Column() {
        Text() {
          Span(`75`)
          .fontColor('rgba(47, 105, 254, 1)')
          .fontFamily('Rubik')
          .fontWeight('Bold')
          .fontSize(toPx(12))
          Span(` of 100% done`)
          .fontColor('rgba(153, 153, 163, 1)')
          .fontFamily('Rubik')
          .fontWeight('Regular')
          .fontSize(toPx(12))
        }
        .width('auto')
        .lineHeight(toPy(18))
        .margin({ left: toPx(0), bottom: toPy(0), right: toPx(0), top: toPy(0) })
      }
      .width('auto')
      .height(toPy(18))
      .opacity(1)
      .flexShrink(0)
      Stack() {
        Stack()
        .id('9:1226')
        .height(toPy(5))
        .width(toPx(370))
        .opacity(0.20000000298023224)
        .clip(true)
        .position({ left: toPx(0), top: toPy(0) })
        .borderRadius(toPx(10))
        .backgroundColor($r('app.color.LightmodeBlue3140'))
        Stack()
        .id('9:1227')
        .height(toPy(5))
        .width(toPx(276))
        .opacity(1)
        .clip(true)
        .position({ left: toPx(0), top: toPy(0) })
        .borderRadius(toPx(10))
        .backgroundColor($r('app.color.LightmodeBlue3140'))
      }
      .id('9:1225')
      .height(toPy(5))
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 0)')
      Text(`3 days left`)
      .fontColor('rgba(153, 153, 163, 1)')
      .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('10:1258')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1258')?.width ?? toPx(370))
    .height(this.getUserPropsById('10:1258')?.height ?? toPy(31))
    .opacity(this.getUserPropsById('10:1258')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1258')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1258')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1258')?.left ?? toPx(20)
              })
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}