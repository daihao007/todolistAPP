import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeDark7 {
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
          .fontColor('rgba(31, 87, 231, 1)')
          .fontFamily('Rubik')
          .fontWeight('Bold')
          .fontSize(toPx(12))
          Span(` of 100% done`)
          .fontColor('rgba(190, 190, 190, 1)')
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
        .id('10:1268')
        .height(toPy(5))
        .width(toPx(370))
        .opacity(0.20000000298023224)
        .clip(true)
        .position({ left: toPx(0), top: toPy(0) })
        .borderRadius(toPx(10))
        .backgroundColor($r('app.color.DarkmodeBlue2239'))
        Stack()
        .id('10:1269')
        .height(toPy(5))
        .width(toPx(276))
        .opacity(1)
        .clip(true)
        .position({ left: toPx(0), top: toPy(0) })
        .borderRadius(toPx(10))
        .backgroundColor($r('app.color.DarkmodeBlue2239'))
      }
      .id('10:1267')
      .height(toPy(5))
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 0)')
      Text(`3 days left`)
      .fontColor('rgba(190, 190, 190, 1)')
      .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('10:1271')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1271')?.width ?? toPx(370))
    .height(this.getUserPropsById('10:1271')?.height ?? toPy(31))
    .opacity(this.getUserPropsById('10:1271')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1271')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1271')?.top ?? toPy(72),
              left: this.getUserPropsById('10:1271')?.left ?? toPx(20)
              })
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}