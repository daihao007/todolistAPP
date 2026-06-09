import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLight1 } from '../components/ModeLight1';
import { ModeLight2 } from '../components/ModeLight2';
import { ModeLight12 } from '../components/ModeLight12';


@Component
export struct ModeLight13 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.End, space: { main: LengthMetrics.vp(toPx(30)) } }) {
      ModeLight1({
          propList: [{"componentId":"8:591","pathString":"8:591"},{"componentId":"8:592","pathString":"8:592"},{"componentId":"8:593","pathString":"8:593"},{"componentId":"8:620","pathString":"8:620"},{"componentId":"8:621","pathString":"8:621","width":this.getUserPropsById('8:621')?.width ?? toPx(370),"height":this.getUserPropsById('8:621')?.height ?? toPy(24),"left":this.getUserPropsById('8:621')?.left ?? toPx(30),"top":this.getUserPropsById('8:621')?.top ?? toPy(32),"name":this.getUserPropsById('8:621')?.name ?? 'Search Input'},...this.getOverridePropsById('8:738')]
        })
      .flexShrink(0)
      ModeLight2({
          propList: [{"componentId":"8:519","pathString":"8:519"},{"componentId":"8:521","pathString":"8:521"},{"componentId":"8:524","pathString":"8:524"},{"componentId":"8:526","pathString":"8:526"},{"componentId":"8:549","pathString":"8:549","width":this.getUserPropsById('8:549')?.width ?? toPx(367),"height":this.getUserPropsById('8:549')?.height ?? toPy(44),"left":this.getUserPropsById('8:549')?.left ?? toPx(33),"top":this.getUserPropsById('8:549')?.top ?? toPy(86),"name":this.getUserPropsById('8:549')?.name ?? 'Search Tab'},{"componentId":"8:509","pathString":"8:519/8:509"},{"componentId":"8:510","pathString":"8:521/8:510"},{"componentId":"8:510","pathString":"8:524/8:510"},{"componentId":"8:510","pathString":"8:526/8:510"},...this.getOverridePropsById('8:753')]
        })
      .flexShrink(0)
      ModeLight12({
          propList: [{"componentId":"8:634","pathString":"8:634"},{"componentId":"8:637","pathString":"8:637"},{"componentId":"8:638","pathString":"8:638"},{"componentId":"8:650","pathString":"8:650"},{"componentId":"8:652","pathString":"8:652"},{"componentId":"8:653","pathString":"8:653"},{"componentId":"8:655","pathString":"8:655"},{"componentId":"8:658","pathString":"8:658"},{"componentId":"8:660","pathString":"8:660"},{"componentId":"8:663","pathString":"8:663"},{"componentId":"8:664","pathString":"8:664"},{"componentId":"8:665","pathString":"8:665"},{"componentId":"8:671","pathString":"8:671"},{"componentId":"8:679","pathString":"8:679"},{"componentId":"8:680","pathString":"8:680"},{"componentId":"8:683","pathString":"8:683"},{"componentId":"8:684","pathString":"8:684"},{"componentId":"8:736","pathString":"8:736","width":this.getUserPropsById('8:736')?.width ?? toPx(370),"height":this.getUserPropsById('8:736')?.height ?? toPy(283),"left":this.getUserPropsById('8:736')?.left ?? toPx(30),"top":this.getUserPropsById('8:736')?.top ?? toPy(160),"name":this.getUserPropsById('8:736')?.name ?? 'Search Results'},...this.getOverridePropsById('8:762')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('8:924')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:924')?.width ?? toPx(430))
    .height(this.getUserPropsById('8:924')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('8:924')?.opacity ?? 1)
    .position(this.getUserPropsById('8:924')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:924')?.top ?? toPy(20),
              left: this.getUserPropsById('8:924')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('8:924')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}