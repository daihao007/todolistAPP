import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLightStateOn } from '../components/ModeLightStateOn';
import { ModeLightStateOff } from '../components/ModeLightStateOff';


@Component
export struct ModeLight2 {
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
      ModeLightStateOn({
          propList: [{"componentId":"8:509","pathString":"8:509"},{"componentId":"8:516","pathString":"8:516","width":this.getUserPropsById('8:516')?.width ?? toPx(73),"height":this.getUserPropsById('8:516')?.height ?? toPy(44),"left":this.getUserPropsById('8:516')?.left ?? toPx(0),"top":this.getUserPropsById('8:516')?.top ?? toPy(0),"name":this.getUserPropsById('8:516')?.name ?? 'Tab'},...this.getOverridePropsById('8:519')]
        })
      .flexShrink(0)
      ModeLightStateOff({
          propList: [{"componentId":"8:510","pathString":"8:510"},{"componentId":"8:517","pathString":"8:517","width":this.getUserPropsById('8:517')?.width ?? toPx(74),"height":this.getUserPropsById('8:517')?.height ?? toPy(24),"left":this.getUserPropsById('8:517')?.left ?? toPx(89),"top":this.getUserPropsById('8:517')?.top ?? toPy(10),"name":this.getUserPropsById('8:517')?.name ?? 'Tab'},...this.getOverridePropsById('8:521')]
        })
      .flexShrink(0)
      ModeLightStateOff({
          propList: [{"componentId":"8:510","pathString":"8:510","nodeText":this.getUserPropsById('8:510')?.nodeText ?? 'Files (5)'},{"componentId":"8:517","pathString":"8:517","width":this.getUserPropsById('8:517')?.width ?? toPx(74),"height":this.getUserPropsById('8:517')?.height ?? toPy(24),"left":this.getUserPropsById('8:517')?.left ?? toPx(179),"top":this.getUserPropsById('8:517')?.top ?? toPy(10),"name":this.getUserPropsById('8:517')?.name ?? 'Tab'},...this.getOverridePropsById('8:524')]
        })
      .flexShrink(0)
      ModeLightStateOff({
          propList: [{"componentId":"8:510","pathString":"8:510","width":this.getUserPropsById('8:510')?.width ?? toPx(98),"height":this.getUserPropsById('8:510')?.height ?? toPy(24),"nodeText":this.getUserPropsById('8:510')?.nodeText ?? 'Messages (0)'},{"componentId":"8:517","pathString":"8:517","width":this.getUserPropsById('8:517')?.width ?? toPx(98),"height":this.getUserPropsById('8:517')?.height ?? toPy(24),"left":this.getUserPropsById('8:517')?.left ?? toPx(269),"top":this.getUserPropsById('8:517')?.top ?? toPy(10),"name":this.getUserPropsById('8:517')?.name ?? 'Tab'},...this.getOverridePropsById('8:526')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('8:549')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:549')?.width ?? toPx(367))
    .height(this.getUserPropsById('8:549')?.height ?? toPy(44))
    .opacity(this.getUserPropsById('8:549')?.opacity ?? 1)
    .position(this.getUserPropsById('8:549')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:549')?.top ?? toPy(20),
              left: this.getUserPropsById('8:549')?.left ?? toPx(20)
              })
  }
  
}