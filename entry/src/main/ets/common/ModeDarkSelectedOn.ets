import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { CountryUkraine } from '../components/CountryUkraine';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ic_tick } from '../components/ic_tick';


@Component
export struct ModeDarkSelectedOn {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        CountryUkraine({
            propList: [{"componentId":"10:1715","pathString":"10:1715","width":this.getUserPropsById('10:1715')?.width ?? toPx(32),"height":this.getUserPropsById('10:1715')?.height ?? toPy(32),"left":this.getUserPropsById('10:1715')?.left ?? toPx(0),"top":this.getUserPropsById('10:1715')?.top ?? toPy(0),"name":this.getUserPropsById('10:1715')?.name ?? 'Flags'},...this.getOverridePropsById('10:1789')]
          })
        .flexShrink(0)
        Text(`United States (+1)`)
        .fontColor('rgba(0, 1, 24, 1)')
        .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
      }
      .id('10:1788')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ic_tick({
          propList: [{"componentId":"10:1761","pathString":"10:1761","fillPaints":this.getUserPropsById('10:1761')?.fillPaints ?? [{backgroundColor: 'rgba(31, 87, 231, 1)'}],"width":this.getUserPropsById('10:1761')?.width ?? toPx(14.78),"height":this.getUserPropsById('10:1761')?.height ?? toPy(10.66),"left":this.getUserPropsById('10:1761')?.left ?? toPx(12.61),"top":this.getUserPropsById('10:1761')?.top ?? toPy(14.35)},{"componentId":"10:1764","pathString":"10:1764","width":this.getUserPropsById('10:1764')?.width ?? toPx(40),"height":this.getUserPropsById('10:1764')?.height ?? toPy(39.38),"left":this.getUserPropsById('10:1764')?.left ?? toPx(260),"top":this.getUserPropsById('10:1764')?.top ?? toPy(11.82)},{"componentId":"10:1762","pathString":"10:1762","width":this.getUserPropsById('10:1762')?.width ?? toPx(14.78),"height":this.getUserPropsById('10:1762')?.height ?? toPy(10.66)},{"componentId":"10:1763","pathString":"10:1763","width":this.getUserPropsById('10:1763')?.width ?? toPx(33.33),"height":this.getUserPropsById('10:1763')?.height ?? toPy(32.82),"left":this.getUserPropsById('10:1763')?.left ?? toPx(-9.27),"top":this.getUserPropsById('10:1763')?.top ?? toPy(-11.07)},...this.getOverridePropsById('10:1792')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('10:1799')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1799')?.width ?? toPx(320))
    .height(this.getUserPropsById('10:1799')?.height ?? toPy(64))
    .opacity(this.getUserPropsById('10:1799')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1799')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1799')?.top ?? toPy(105),
              left: this.getUserPropsById('10:1799')?.left ?? toPx(380)
              })
    .padding({ left: toPx(20), right: toPx(20) })
    .borderRadius(this.getUserPropsById('10:1799')?.cornerRadius ?? toPx(20))
    .backgroundColor($r('app.color.DarkmodeGray6474'))
  }
  
}