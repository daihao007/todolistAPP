import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeLightNameJenny } from '../components/ModeLightNameJenny';


@Component
export struct ModeLightPositioningRight {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(12)) } }) {
      Text(`21 min ago`)
      .fontColor('rgba(0, 1, 24, 0.4000000059604645)')
      .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
      Text(`Ralph Edwards`)
      .fontColor('rgba(0, 1, 24, 1)')
      .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
      ModeLightNameJenny({
          propList: [{"componentId":"3:238","pathString":"3:238","width":this.getUserPropsById('3:238')?.width ?? toPx(40),"height":this.getUserPropsById('3:238')?.height ?? toPy(40),"left":this.getUserPropsById('3:238')?.left ?? toPx(221),"top":this.getUserPropsById('3:238')?.top ?? toPy(0),"name":this.getUserPropsById('3:238')?.name ?? 'Avatars'},...this.getOverridePropsById('3:275')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('3:281')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:281')?.width ?? toPx(261))
    .height(this.getUserPropsById('3:281')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:281')?.opacity ?? 1)
    .position(this.getUserPropsById('3:281')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:281')?.top ?? toPy(272),
              left: this.getUserPropsById('3:281')?.left ?? toPx(20)
              })
  }
  
}