import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';


@Component
export struct ModeLightStateOff {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(10)) } }) {
      Text(`People (7)`)
      .fontColor('rgba(0, 1, 24, 0.800000011920929)')
      .fontFamily('Rubik')
      .fontWeight('Regular')
      .fontSize(toPx(16))
      .lineHeight('150%')
      .letterSpacing('0%')
      .lineHeight('150%')
    }
    .visibility(this.getUserPropsById('8:517')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:517')?.width ?? toPx(74))
    .height(this.getUserPropsById('8:517')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('8:517')?.opacity ?? 1)
    .position(this.getUserPropsById('8:517')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:517')?.top ?? toPy(30),
              left: this.getUserPropsById('8:517')?.left ?? toPx(109)
              })
    .backgroundColor(this.getUserPropsById('8:517')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}