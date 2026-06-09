import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeLightStateYourReply {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(8)) } }) {
      Text(`What do you mean?`)
      .fontColor('rgba(0, 1, 24, 1)')
      .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('2:1885')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('2:1885')?.width ?? toPx(177))
    .height(this.getUserPropsById('2:1885')?.height ?? toPy(48))
    .opacity(this.getUserPropsById('2:1885')?.opacity ?? 1)
    .position(this.getUserPropsById('2:1885')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('2:1885')?.top ?? toPy(96),
              left: this.getUserPropsById('2:1885')?.left ?? toPx(16)
              })
    .padding({ bottom: toPy(12), top: toPy(12), left: toPx(16), right: toPx(16) })
    .borderRadius({ bottomLeft: this.getUserPropsById('2:1885')?.BLCRadius ?? toPx(24), bottomRight: this.getUserPropsById('2:1885')?.BRCRadius ?? toPx(24), topLeft: this.getUserPropsById('2:1885')?.TLCRadius ?? toPx(24), topRight: this.getUserPropsById('2:1885')?.TRCRadius ?? toPx(undefined) })
    .backgroundColor($r('app.color.LightmodeLightGray3144'))
  }
  
}