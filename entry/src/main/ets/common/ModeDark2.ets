import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDarkStateOn } from '../components/ModeDarkStateOn';
import { ModeDarkStateOff } from '../components/ModeDarkStateOff';


@Component
export struct ModeDark2 {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
      ModeDarkStateOn({
          propList: [{"componentId":"8:512","pathString":"8:512"},{"componentId":"8:514","pathString":"8:514","width":this.getUserPropsById('8:514')?.width ?? toPx(73),"height":this.getUserPropsById('8:514')?.height ?? toPy(44),"left":this.getUserPropsById('8:514')?.left ?? toPx(0),"top":this.getUserPropsById('8:514')?.top ?? toPy(0),"name":this.getUserPropsById('8:514')?.name ?? 'Tab'},...this.getOverridePropsById('8:536')]
        })
      .flexShrink(0)
      ModeDarkStateOff({
          propList: [{"componentId":"8:513","pathString":"8:513"},{"componentId":"8:515","pathString":"8:515","width":this.getUserPropsById('8:515')?.width ?? toPx(74),"height":this.getUserPropsById('8:515')?.height ?? toPy(24),"left":this.getUserPropsById('8:515')?.left ?? toPx(89),"top":this.getUserPropsById('8:515')?.top ?? toPy(10),"name":this.getUserPropsById('8:515')?.name ?? 'Tab'},...this.getOverridePropsById('8:537')]
        })
      .flexShrink(0)
      ModeDarkStateOff({
          propList: [{"componentId":"8:513","pathString":"8:513","nodeText":this.getUserPropsById('8:513')?.nodeText ?? 'Files (5)'},{"componentId":"8:515","pathString":"8:515","width":this.getUserPropsById('8:515')?.width ?? toPx(74),"height":this.getUserPropsById('8:515')?.height ?? toPy(24),"left":this.getUserPropsById('8:515')?.left ?? toPx(179),"top":this.getUserPropsById('8:515')?.top ?? toPy(10),"name":this.getUserPropsById('8:515')?.name ?? 'Tab'},...this.getOverridePropsById('8:538')]
        })
      .flexShrink(0)
      ModeDarkStateOff({
          propList: [{"componentId":"8:513","pathString":"8:513","width":this.getUserPropsById('8:513')?.width ?? toPx(98),"height":this.getUserPropsById('8:513')?.height ?? toPy(24),"nodeText":this.getUserPropsById('8:513')?.nodeText ?? 'Messages (0)'},{"componentId":"8:515","pathString":"8:515","width":this.getUserPropsById('8:515')?.width ?? toPx(98),"height":this.getUserPropsById('8:515')?.height ?? toPy(24),"left":this.getUserPropsById('8:515')?.left ?? toPx(269),"top":this.getUserPropsById('8:515')?.top ?? toPy(10),"name":this.getUserPropsById('8:515')?.name ?? 'Tab'},...this.getOverridePropsById('8:539')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('8:548')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:548')?.width ?? toPx(367))
    .height(this.getUserPropsById('8:548')?.height ?? toPy(44))
    .opacity(this.getUserPropsById('8:548')?.opacity ?? 1)
    .position(this.getUserPropsById('8:548')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:548')?.top ?? toPy(84),
              left: this.getUserPropsById('8:548')?.left ?? toPx(20)
              })
  }
  
}