import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDarkNameHoward } from '../components/ModeDarkNameHoward';
import { ModeDarkNameRalph } from '../components/ModeDarkNameRalph';
import { ModeDark7 } from '../components/ModeDark7';
import { ModeDark11 } from '../components/ModeDark11';


@Component
export struct ModeDark10 {
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
            ModeDarkNameHoward({
                propList: [{"componentId":"3:241","pathString":"3:241","fillPaints":this.getUserPropsById('3:241')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:241')?.width ?? toPx(35),"height":this.getUserPropsById('3:241')?.height ?? toPy(35),"left":this.getUserPropsById('3:241')?.left ?? toPx(0),"top":this.getUserPropsById('3:241')?.top ?? toPy(0),"name":this.getUserPropsById('3:241')?.name ?? 'Avatars',"strokeWeight":this.getUserPropsById('3:241')?.strokeWeight ?? toPx(2),"borderColor":this.getUserPropsById('3:241')?.borderColor ?? 'rgba(15, 14, 19, 1)'},{"componentId":"3:227","pathString":"3:227","width":this.getUserPropsById('3:227')?.width ?? toPx(35),"height":this.getUserPropsById('3:227')?.height ?? toPy(35)},...this.getOverridePropsById('10:1505')]
              })
            .flexShrink(0)
            ModeDarkNameRalph({
                propList: [{"componentId":"3:244","pathString":"3:244","fillPaints":this.getUserPropsById('3:244')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:244')?.width ?? toPx(35),"height":this.getUserPropsById('3:244')?.height ?? toPy(35),"left":this.getUserPropsById('3:244')?.left ?? toPx(27),"top":this.getUserPropsById('3:244')?.top ?? toPy(0),"name":this.getUserPropsById('3:244')?.name ?? 'Avatars',"strokeWeight":this.getUserPropsById('3:244')?.strokeWeight ?? toPx(2),"borderColor":this.getUserPropsById('3:244')?.borderColor ?? 'rgba(15, 14, 19, 1)'},{"componentId":"3:229","pathString":"3:229","width":this.getUserPropsById('3:229')?.width ?? toPx(35),"height":this.getUserPropsById('3:229')?.height ?? toPy(35)},...this.getOverridePropsById('10:1506')]
              })
            .flexShrink(0)
          }
          .id('10:1504')
          .height('auto')
          .width('auto')
          .opacity(1)
          .flexShrink(0)
        }
        .id('10:1501')
        .height('auto')
        .width(toPx(370))
        .opacity(1)
        .flexShrink(0)
        ModeDark7({
            propList: [{"componentId":"10:1266","pathString":"10:1266"},{"componentId":"10:1267","pathString":"10:1267"},{"componentId":"10:1270","pathString":"10:1270"},{"componentId":"10:1271","pathString":"10:1271","width":this.getUserPropsById('10:1271')?.width ?? toPx(370),"height":this.getUserPropsById('10:1271')?.height ?? toPy(31),"left":this.getUserPropsById('10:1271')?.left ?? toPx(0),"top":this.getUserPropsById('10:1271')?.top ?? toPy(72),"name":this.getUserPropsById('10:1271')?.name ?? 'Graph'},...this.getOverridePropsById('10:1507')]
          })
        .flexShrink(0)
      }
      .id('10:1500')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeDark11({
          propList: [{"componentId":"10:1369","pathString":"10:1369"},{"componentId":"10:1370","pathString":"10:1370"},{"componentId":"10:1371","pathString":"10:1371"},{"componentId":"10:1372","pathString":"10:1372"},{"componentId":"10:1373","pathString":"10:1373"},{"componentId":"10:1374","pathString":"10:1374"},{"componentId":"10:1375","pathString":"10:1375"},{"componentId":"10:1376","pathString":"10:1376"},{"componentId":"10:1377","pathString":"10:1377"},{"componentId":"10:1396","pathString":"10:1396","width":this.getUserPropsById('10:1396')?.width ?? toPx(347),"height":this.getUserPropsById('10:1396')?.height ?? toPy(21),"left":this.getUserPropsById('10:1396')?.left ?? toPx(30),"top":this.getUserPropsById('10:1396')?.top ?? toPy(159),"name":this.getUserPropsById('10:1396')?.name ?? 'Card Info'},...this.getOverridePropsById('10:1508')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('10:1573')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1573')?.width ?? toPx(430))
    .height(this.getUserPropsById('10:1573')?.height ?? toPy(212))
    .opacity(this.getUserPropsById('10:1573')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1573')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1573')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1573')?.left ?? toPx(470)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('10:1573')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}