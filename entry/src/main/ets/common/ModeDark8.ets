import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDarkNameRobert } from '../components/ModeDarkNameRobert';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeDark9 } from '../components/ModeDark9';


@Component
export struct ModeDark8 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(14)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(8)) } }) {
        ModeDarkNameRobert({
            propList: [{"componentId":"3:240","pathString":"3:240","fillPaints":this.getUserPropsById('3:240')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:240')?.width ?? toPx(50),"height":this.getUserPropsById('3:240')?.height ?? toPy(50),"left":this.getUserPropsById('3:240')?.left ?? toPx(0),"top":this.getUserPropsById('3:240')?.top ?? toPy(0),"name":this.getUserPropsById('3:240')?.name ?? 'Avatars'},{"componentId":"3:223","pathString":"3:223","width":this.getUserPropsById('3:223')?.width ?? toPx(50),"height":this.getUserPropsById('3:223')?.height ?? toPy(50)},...this.getOverridePropsById('9:1050')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Robert Fox`)
          .fontColor('rgba(190, 190, 190, 1)')
          .fontFamily((getStyleValue("text", 'Body / Medium6478') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Medium6478') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Medium6478') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Medium6478') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Product Designer`)
          .fontColor('rgba(190, 190, 190, 1)')
          .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('9:1051')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('9:1049')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeDark9({
          propList: [{"componentId":"9:1011","pathString":"9:1011"},{"componentId":"9:1012","pathString":"9:1012"},{"componentId":"9:1013","pathString":"9:1013"},{"componentId":"9:1014","pathString":"9:1014"},{"componentId":"9:1015","pathString":"9:1015"},{"componentId":"9:1016","pathString":"9:1016"},{"componentId":"9:1017","pathString":"9:1017"},{"componentId":"9:1018","pathString":"9:1018"},{"componentId":"9:1019","pathString":"9:1019"},{"componentId":"9:1020","pathString":"9:1020"},{"componentId":"9:1021","pathString":"9:1021"},{"componentId":"9:1022","pathString":"9:1022"},{"componentId":"9:1023","pathString":"9:1023"},{"componentId":"9:1024","pathString":"9:1024"},{"componentId":"9:1025","pathString":"9:1025"},{"componentId":"9:1026","pathString":"9:1026"},{"componentId":"9:1027","pathString":"9:1027"},{"componentId":"9:1028","pathString":"9:1028"},{"componentId":"9:1029","pathString":"9:1029"},{"componentId":"9:1030","pathString":"9:1030"},{"componentId":"9:1031","pathString":"9:1031"},{"componentId":"9:1032","pathString":"9:1032"},{"componentId":"9:1033","pathString":"9:1033"},{"componentId":"9:1034","pathString":"9:1034"},{"componentId":"9:1035","pathString":"9:1035"},{"componentId":"9:1036","pathString":"9:1036"},{"componentId":"9:1037","pathString":"9:1037"},{"componentId":"9:1038","pathString":"9:1038"},{"componentId":"9:1039","pathString":"9:1039"},{"componentId":"9:1040","pathString":"9:1040"},{"componentId":"9:1041","pathString":"9:1041"},{"componentId":"9:1045","pathString":"9:1045"},{"componentId":"9:1046","pathString":"9:1046","width":this.getUserPropsById('9:1046')?.width ?? toPx(352),"height":this.getUserPropsById('9:1046')?.height ?? toPy(84),"left":this.getUserPropsById('9:1046')?.left ?? toPx(39),"top":this.getUserPropsById('9:1046')?.top ?? toPy(96),"name":this.getUserPropsById('9:1046')?.name ?? 'Audio Message '},...this.getOverridePropsById('9:1104')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('9:1175')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('9:1175')?.width ?? toPx(430))
    .height(this.getUserPropsById('9:1175')?.height ?? toPy(212))
    .opacity(this.getUserPropsById('9:1175')?.opacity ?? 1)
    .position(this.getUserPropsById('9:1175')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('9:1175')?.top ?? toPy(20),
              left: this.getUserPropsById('9:1175')?.left ?? toPx(470)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(39), right: toPx(39) })
    .borderRadius(this.getUserPropsById('9:1175')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}