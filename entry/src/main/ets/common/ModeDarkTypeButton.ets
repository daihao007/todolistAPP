import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ic_plus } from '../components/ic_plus';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeDarkTypeButton {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(10)) } }) {
      ic_plus({
          propList: [{"componentId":"6:407","pathString":"6:407","strokeWeight":this.getUserPropsById('6:407')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:407')?.borderColor ?? 'rgba(255, 255, 255, 1)'},{"componentId":"6:408","pathString":"6:408","strokeWeight":this.getUserPropsById('6:408')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:408')?.borderColor ?? 'rgba(255, 255, 255, 1)'},{"componentId":"6:409","pathString":"6:409","width":this.getUserPropsById('6:409')?.width ?? toPx(24),"height":this.getUserPropsById('6:409')?.height ?? toPy(24),"left":this.getUserPropsById('6:409')?.left ?? toPx(133),"top":this.getUserPropsById('6:409')?.top ?? toPy(18)},...this.getOverridePropsById('6:429')]
        })
      .flexShrink(0)
      Text(`Add Task`)
      .fontColor('rgba(255, 255, 255, 1)')
      .fontFamily((getStyleValue("text", 'Body / Medium6478') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Medium6478') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Medium6478') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Medium6478') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('6:428')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:428')?.width ?? toPx(369))
    .height(this.getUserPropsById('6:428')?.height ?? toPy(60))
    .opacity(this.getUserPropsById('6:428')?.opacity ?? 1)
    .position(this.getUserPropsById('6:428')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:428')?.top ?? toPy(96),
              left: this.getUserPropsById('6:428')?.left ?? toPx(20.5)
              })
    .padding({ bottom: toPy(18), top: toPy(18), left: toPx(133), right: toPx(133) })
    .borderRadius(this.getUserPropsById('6:428')?.cornerRadius ?? toPx(20))
    .backgroundColor($r('app.color.DarkmodeBlue2239'))
  }
  
}