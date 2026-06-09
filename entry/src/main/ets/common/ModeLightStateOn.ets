import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeLightStateOn {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(10)) } }) {
      Text(`All (12)`)
      .fontColor('rgba(0, 1, 24, 1)')
      .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('8:516')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:516')?.width ?? toPx(73))
    .height(this.getUserPropsById('8:516')?.height ?? toPy(44))
    .opacity(this.getUserPropsById('8:516')?.opacity ?? 1)
    .position(this.getUserPropsById('8:516')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:516')?.top ?? toPy(20),
              left: this.getUserPropsById('8:516')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(10), top: toPy(10), left: toPx(10), right: toPx(10) })
    .borderRadius(this.getUserPropsById('8:516')?.cornerRadius ?? toPx(10))
    .backgroundColor($r('app.color.LightmodeLightGray3144'))
  }
  
}