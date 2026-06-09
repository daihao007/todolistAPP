import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ic_chat } from '../components/ic_chat';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ic_tick_square } from '../components/ic_tick_square';
import { ic_calendar } from '../components/ic_calendar';


@Component
export struct ModeDark11 {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(24)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(4)) } }) {
        ic_chat({
            propList: [{"componentId":"10:1313","pathString":"10:1313","strokeWeight":this.getUserPropsById('10:1313')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1313')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1314","pathString":"10:1314","strokeWeight":this.getUserPropsById('10:1314')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1314')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1315","pathString":"10:1315","strokeWeight":this.getUserPropsById('10:1315')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1315')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1316","pathString":"10:1316","strokeWeight":this.getUserPropsById('10:1316')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1316')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1317","pathString":"10:1317","width":this.getUserPropsById('10:1317')?.width ?? toPx(16),"height":this.getUserPropsById('10:1317')?.height ?? toPy(16),"left":this.getUserPropsById('10:1317')?.left ?? toPx(0),"top":this.getUserPropsById('10:1317')?.top ?? toPy(2.5)},...this.getOverridePropsById('10:1370')]
          })
        .flexShrink(0)
        Text(`3 comments `)
        .fontColor('rgba(153, 153, 163, 1)')
        .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
      }
      .id('10:1369')
      .height('auto')
      .width('auto')
      .opacity(0.800000011920929)
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(4)) } }) {
        ic_tick_square({
            propList: [{"componentId":"10:1309","pathString":"10:1309","strokeWeight":this.getUserPropsById('10:1309')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1309')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1310","pathString":"10:1310","strokeWeight":this.getUserPropsById('10:1310')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1310')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1318","pathString":"10:1318","width":this.getUserPropsById('10:1318')?.width ?? toPx(17),"height":this.getUserPropsById('10:1318')?.height ?? toPy(17),"left":this.getUserPropsById('10:1318')?.left ?? toPx(0),"top":this.getUserPropsById('10:1318')?.top ?? toPy(2)},...this.getOverridePropsById('10:1373')]
          })
        .flexShrink(0)
        Text(`5 subtasks`)
        .fontColor('rgba(153, 153, 163, 1)')
        .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
      }
      .id('10:1372')
      .height('auto')
      .width('auto')
      .opacity(0.800000011920929)
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(4)) } }) {
        ic_calendar({
            propList: [{"componentId":"10:1297","pathString":"10:1297","strokeWeight":this.getUserPropsById('10:1297')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1297')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1298","pathString":"10:1298","strokeWeight":this.getUserPropsById('10:1298')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1298')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1299","pathString":"10:1299","strokeWeight":this.getUserPropsById('10:1299')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1299')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1300","pathString":"10:1300","strokeWeight":this.getUserPropsById('10:1300')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1300')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1301","pathString":"10:1301","strokeWeight":this.getUserPropsById('10:1301')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1301')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1302","pathString":"10:1302","strokeWeight":this.getUserPropsById('10:1302')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1302')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1303","pathString":"10:1303","strokeWeight":this.getUserPropsById('10:1303')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1303')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1304","pathString":"10:1304","strokeWeight":this.getUserPropsById('10:1304')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1304')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1305","pathString":"10:1305","strokeWeight":this.getUserPropsById('10:1305')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1305')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1306","pathString":"10:1306","strokeWeight":this.getUserPropsById('10:1306')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1306')?.borderColor ?? 'rgba(186, 42, 0, 1)'},{"componentId":"10:1319","pathString":"10:1319","width":this.getUserPropsById('10:1319')?.width ?? toPx(16),"height":this.getUserPropsById('10:1319')?.height ?? toPy(16),"left":this.getUserPropsById('10:1319')?.left ?? toPx(0),"top":this.getUserPropsById('10:1319')?.top ?? toPy(2.5)},...this.getOverridePropsById('10:1376')]
          })
        .flexShrink(0)
        Text(`Due: Jul, 20`)
        .fontColor('rgba(186, 42, 0, 1)')
        .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
      }
      .id('10:1375')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('10:1396')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1396')?.width ?? toPx(347))
    .height(this.getUserPropsById('10:1396')?.height ?? toPy(21))
    .opacity(this.getUserPropsById('10:1396')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1396')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1396')?.top ?? toPy(57),
              left: this.getUserPropsById('10:1396')?.left ?? toPx(20)
              })
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}