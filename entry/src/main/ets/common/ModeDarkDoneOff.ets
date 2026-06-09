import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { Move } from '../components/Move';
import { StateOff } from '../components/StateOff';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeDarkDoneOff {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(8)) } }) {
      Stack() {
        Move({
            propList: [{"componentId":"6:759","pathString":"6:759","strokeWeight":this.getUserPropsById('6:759')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:759')?.borderColor ?? 'rgba(48, 50, 57, 1)'},{"componentId":"6:760","pathString":"6:760","strokeWeight":this.getUserPropsById('6:760')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:760')?.borderColor ?? 'rgba(48, 50, 57, 1)'},{"componentId":"6:761","pathString":"6:761","strokeWeight":this.getUserPropsById('6:761')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:761')?.borderColor ?? 'rgba(48, 50, 57, 1)'},{"componentId":"6:762","pathString":"6:762","width":this.getUserPropsById('6:762')?.width ?? toPx(20),"height":this.getUserPropsById('6:762')?.height ?? toPy(20),"left":this.getUserPropsById('6:762')?.left ?? toPx(0),"top":this.getUserPropsById('6:762')?.top ?? toPy(2)},...this.getOverridePropsById('7:317')]
          })
      }
      .id('7:316')
      .height(toPy(24))
      .width(toPx(20))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 0)')
      Stack() {
        StateOff({
            propList: [{"componentId":"6:743","pathString":"6:743","strokeWeight":this.getUserPropsById('6:743')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:743')?.borderColor ?? 'rgba(31, 87, 231, 1)'},{"componentId":"6:752","pathString":"6:752","width":this.getUserPropsById('6:752')?.width ?? toPx(20),"height":this.getUserPropsById('6:752')?.height ?? toPy(20),"left":this.getUserPropsById('6:752')?.left ?? toPx(0),"top":this.getUserPropsById('6:752')?.top ?? toPy(2),"name":this.getUserPropsById('6:752')?.name ?? 'Checkbox'},...this.getOverridePropsById('7:319')]
          })
      }
      .id('7:318')
      .height(toPy(24))
      .width(toPx(20))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 0)')
      Text(`Identify and contextualize the problem`)
      .fontColor('rgba(0, 1, 24, 1)')
      .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
      .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
      .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
      .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('7:315')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('7:315')?.width ?? toPx(350))
    .height(this.getUserPropsById('7:315')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('7:315')?.opacity ?? 1)
    .position(this.getUserPropsById('7:315')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('7:315')?.top ?? toPy(143),
              left: this.getUserPropsById('7:315')?.left ?? toPx(20)
              })
  }
  
}