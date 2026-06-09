import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeDarkStateYourReply {
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
      .fontColor('rgba(190, 190, 190, 1)')
      .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('3:147')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:147')?.width ?? toPx(177))
    .height(this.getUserPropsById('3:147')?.height ?? toPy(48))
    .opacity(this.getUserPropsById('3:147')?.opacity ?? 1)
    .position(this.getUserPropsById('3:147')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:147')?.top ?? toPy(256),
              left: this.getUserPropsById('3:147')?.left ?? toPx(16)
              })
    .padding({ bottom: toPy(12), top: toPy(12), left: toPx(16), right: toPx(16) })
    .borderRadius({ bottomLeft: this.getUserPropsById('3:147')?.BLCRadius ?? toPx(24), bottomRight: this.getUserPropsById('3:147')?.BRCRadius ?? toPx(24), topLeft: this.getUserPropsById('3:147')?.TLCRadius ?? toPx(24), topRight: this.getUserPropsById('3:147')?.TRCRadius ?? toPx(undefined) })
    .backgroundColor($r('app.color.DarkmodeLightGray3150'))
  }
  
}