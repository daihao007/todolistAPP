import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLightNameHoward } from '../components/ModeLightNameHoward';
import { ModeLightNameRalph } from '../components/ModeLightNameRalph';
import { ModeLight7 } from '../components/ModeLight7';
import { ModeLight11 } from '../components/ModeLight11';


@Component
export struct ModeLight10 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(24)) } }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(8)) } }) {
          Text(`Design System`)
          .fontColor('rgba(153, 153, 163, 1)')
          .fontFamily('Rubik')
          .fontWeight('SemiBold')
          .fontSize(toPx(14))
          .lineHeight('150%')
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Input fields and Selectors`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily('Rubik')
          .fontWeight('Bold')
          .fontSize(toPx(18))
          .lineHeight('150%')
          .letterSpacing('0%')
          .lineHeight('150%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
            ModeLightNameHoward({
                propList: [{"componentId":"3:233","pathString":"3:233","width":this.getUserPropsById('3:233')?.width ?? toPx(35),"height":this.getUserPropsById('3:233')?.height ?? toPy(35),"left":this.getUserPropsById('3:233')?.left ?? toPx(0),"top":this.getUserPropsById('3:233')?.top ?? toPy(0),"name":this.getUserPropsById('3:233')?.name ?? 'Avatars',"strokeWeight":this.getUserPropsById('3:233')?.strokeWeight ?? toPx(2),"borderColor":this.getUserPropsById('3:233')?.borderColor ?? 'rgba(255, 255, 255, 1)'},{"componentId":"3:211","pathString":"3:211","width":this.getUserPropsById('3:211')?.width ?? toPx(35),"height":this.getUserPropsById('3:211')?.height ?? toPy(35)},...this.getOverridePropsById('10:1408')]
              })
            .flexShrink(0)
            ModeLightNameRalph({
                propList: [{"componentId":"3:237","pathString":"3:237","width":this.getUserPropsById('3:237')?.width ?? toPx(35),"height":this.getUserPropsById('3:237')?.height ?? toPy(35),"left":this.getUserPropsById('3:237')?.left ?? toPx(27),"top":this.getUserPropsById('3:237')?.top ?? toPy(0),"name":this.getUserPropsById('3:237')?.name ?? 'Avatars',"strokeWeight":this.getUserPropsById('3:237')?.strokeWeight ?? toPx(2),"borderColor":this.getUserPropsById('3:237')?.borderColor ?? 'rgba(255, 255, 255, 1)'},{"componentId":"3:219","pathString":"3:219","width":this.getUserPropsById('3:219')?.width ?? toPx(35),"height":this.getUserPropsById('3:219')?.height ?? toPy(35)},...this.getOverridePropsById('10:1410')]
              })
            .flexShrink(0)
          }
          .id('10:1419')
          .height('auto')
          .width('auto')
          .opacity(1)
          .flexShrink(0)
        }
        .id('10:1399')
        .height('auto')
        .width(toPx(370))
        .opacity(1)
        .flexShrink(0)
        ModeLight7({
            propList: [{"componentId":"9:1224","pathString":"9:1224"},{"componentId":"9:1225","pathString":"9:1225"},{"componentId":"9:1228","pathString":"9:1228"},{"componentId":"10:1258","pathString":"10:1258","width":this.getUserPropsById('10:1258')?.width ?? toPx(370),"height":this.getUserPropsById('10:1258')?.height ?? toPy(31),"left":this.getUserPropsById('10:1258')?.left ?? toPx(0),"top":this.getUserPropsById('10:1258')?.top ?? toPy(72),"name":this.getUserPropsById('10:1258')?.name ?? 'Graph'},...this.getOverridePropsById('10:1420')]
          })
        .flexShrink(0)
      }
      .id('10:1452')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeLight11({
          propList: [{"componentId":"10:1322","pathString":"10:1322"},{"componentId":"10:1339","pathString":"10:1339"},{"componentId":"10:1340","pathString":"10:1340"},{"componentId":"10:1341","pathString":"10:1341"},{"componentId":"10:1342","pathString":"10:1342"},{"componentId":"10:1343","pathString":"10:1343"},{"componentId":"10:1350","pathString":"10:1350"},{"componentId":"10:1351","pathString":"10:1351"},{"componentId":"10:1352","pathString":"10:1352"},{"componentId":"10:1397","pathString":"10:1397","width":this.getUserPropsById('10:1397')?.width ?? toPx(347),"height":this.getUserPropsById('10:1397')?.height ?? toPy(21),"left":this.getUserPropsById('10:1397')?.left ?? toPx(30),"top":this.getUserPropsById('10:1397')?.top ?? toPy(159),"name":this.getUserPropsById('10:1397')?.name ?? 'Card Info'},...this.getOverridePropsById('10:1426')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('10:1574')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1574')?.width ?? toPx(430))
    .height(this.getUserPropsById('10:1574')?.height ?? toPy(212))
    .opacity(this.getUserPropsById('10:1574')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1574')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1574')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1574')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('10:1574')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}