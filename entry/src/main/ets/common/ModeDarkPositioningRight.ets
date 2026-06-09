import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeDarkNameJenny } from '../components/ModeDarkNameJenny';


@Component
export struct ModeDarkPositioningRight {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(12)) } }) {
      Text(`21 min ago`)
      .fontColor('rgba(173, 174, 181, 1)')
      .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
      Text(`Ralph Edwards`)
      .fontColor('rgba(255, 255, 255, 1)')
      .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
      ModeDarkNameJenny({
          propList: [{"componentId":"3:239","pathString":"3:239","fillPaints":this.getUserPropsById('3:239')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:239')?.width ?? toPx(40),"height":this.getUserPropsById('3:239')?.height ?? toPy(40),"left":this.getUserPropsById('3:239')?.left ?? toPx(221),"top":this.getUserPropsById('3:239')?.top ?? toPy(0),"name":this.getUserPropsById('3:239')?.name ?? 'Avatars'},...this.getOverridePropsById('3:270')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('3:279')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:279')?.width ?? toPx(261))
    .height(this.getUserPropsById('3:279')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:279')?.opacity ?? 1)
    .position(this.getUserPropsById('3:279')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:279')?.top ?? toPy(107),
              left: this.getUserPropsById('3:279')?.left ?? toPx(20)
              })
  }
  
}