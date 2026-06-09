import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { Custom_Search } from '../components/Custom_Search';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeLight1 {
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
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Custom_Search({
            propList: [{"componentId":"8:587","pathString":"8:587","width":this.getUserPropsById('8:587')?.width ?? toPx(24),"height":this.getUserPropsById('8:587')?.height ?? toPy(24),"left":this.getUserPropsById('8:587')?.left ?? toPx(0),"top":this.getUserPropsById('8:587')?.top ?? toPy(0)},...this.getOverridePropsById('8:620')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(4)) } }) {
          Text(`Ar`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Stack()
          .id('8:593')
          .height(toPy(20))
          .width(toPx(2))
          .opacity(1)
          .clip(true)
          .flexShrink(0)
          .backgroundColor($r('app.color.LightmodeBlue3140'))
        }
        .id('8:591')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:589')
      .height(toPy(24))
      .width(toPx(65))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      Text(`Clear`)
      .fontColor('rgba(47, 105, 254, 1)')
      .fontFamily('Rubik')
      .fontWeight('SemiBold')
      .fontSize(toPx(16))
      .lineHeight('150%')
      .letterSpacing('0%')
      .position({ left: toPx(328), top: toPy(0) })
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('8:621')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:621')?.width ?? toPx(370))
    .height(this.getUserPropsById('8:621')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('8:621')?.opacity ?? 1)
    .position(this.getUserPropsById('8:621')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:621')?.top ?? toPy(20),
              left: this.getUserPropsById('8:621')?.left ?? toPx(20)
              })
    .backgroundColor(this.getUserPropsById('8:621')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 1)')
  }
  
}