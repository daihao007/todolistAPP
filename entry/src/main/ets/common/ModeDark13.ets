import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDark1 } from '../components/ModeDark1';
import { ModeDark2 } from '../components/ModeDark2';
import { ModeDark12 } from '../components/ModeDark12';


@Component
export struct ModeDark13 {
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
      ModeDark1({
          propList: [{"componentId":"8:606","pathString":"8:606"},{"componentId":"8:607","pathString":"8:607"},{"componentId":"8:608","pathString":"8:608"},{"componentId":"8:609","pathString":"8:609"},{"componentId":"8:619","pathString":"8:619","width":this.getUserPropsById('8:619')?.width ?? toPx(370),"height":this.getUserPropsById('8:619')?.height ?? toPy(24),"left":this.getUserPropsById('8:619')?.left ?? toPx(30),"top":this.getUserPropsById('8:619')?.top ?? toPy(32),"name":this.getUserPropsById('8:619')?.name ?? 'Search Input'},...this.getOverridePropsById('8:802')]
        })
      .flexShrink(0)
      ModeDark2({
          propList: [{"componentId":"8:536","pathString":"8:536"},{"componentId":"8:537","pathString":"8:537"},{"componentId":"8:538","pathString":"8:538"},{"componentId":"8:539","pathString":"8:539"},{"componentId":"8:548","pathString":"8:548","width":this.getUserPropsById('8:548')?.width ?? toPx(367),"height":this.getUserPropsById('8:548')?.height ?? toPy(44),"left":this.getUserPropsById('8:548')?.left ?? toPx(33),"top":this.getUserPropsById('8:548')?.top ?? toPy(86),"name":this.getUserPropsById('8:548')?.name ?? 'Search Tab'},{"componentId":"8:512","pathString":"8:536/8:512"},{"componentId":"8:513","pathString":"8:537/8:513"},{"componentId":"8:513","pathString":"8:538/8:513"},{"componentId":"8:513","pathString":"8:539/8:513"},...this.getOverridePropsById('8:803')]
        })
      .flexShrink(0)
      ModeDark12({
          propList: [{"componentId":"8:696","pathString":"8:696"},{"componentId":"8:697","pathString":"8:697"},{"componentId":"8:700","pathString":"8:700"},{"componentId":"8:701","pathString":"8:701"},{"componentId":"8:704","pathString":"8:704"},{"componentId":"8:705","pathString":"8:705"},{"componentId":"8:708","pathString":"8:708"},{"componentId":"8:709","pathString":"8:709"},{"componentId":"8:712","pathString":"8:712"},{"componentId":"8:714","pathString":"8:714"},{"componentId":"8:715","pathString":"8:715"},{"componentId":"8:716","pathString":"8:716"},{"componentId":"8:719","pathString":"8:719"},{"componentId":"8:724","pathString":"8:724"},{"componentId":"8:727","pathString":"8:727"},{"componentId":"8:728","pathString":"8:728"},{"componentId":"8:729","pathString":"8:729"},{"componentId":"8:735","pathString":"8:735","width":this.getUserPropsById('8:735')?.width ?? toPx(370),"height":this.getUserPropsById('8:735')?.height ?? toPy(283),"left":this.getUserPropsById('8:735')?.left ?? toPx(30),"top":this.getUserPropsById('8:735')?.top ?? toPy(160),"name":this.getUserPropsById('8:735')?.name ?? 'Search Results'},...this.getOverridePropsById('8:804')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('8:923')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:923')?.width ?? toPx(430))
    .height(this.getUserPropsById('8:923')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('8:923')?.opacity ?? 1)
    .position(this.getUserPropsById('8:923')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:923')?.top ?? toPy(20),
              left: this.getUserPropsById('8:923')?.left ?? toPx(491)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('8:923')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}