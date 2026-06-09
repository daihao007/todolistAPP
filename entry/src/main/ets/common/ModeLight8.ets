import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLightNameRobert } from '../components/ModeLightNameRobert';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeLight9 } from '../components/ModeLight9';


@Component
export struct ModeLight8 {
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
        ModeLightNameRobert({
            propList: [{"componentId":"3:245","pathString":"3:245","width":this.getUserPropsById('3:245')?.width ?? toPx(50),"height":this.getUserPropsById('3:245')?.height ?? toPy(50),"left":this.getUserPropsById('3:245')?.left ?? toPx(0),"top":this.getUserPropsById('3:245')?.top ?? toPy(0),"name":this.getUserPropsById('3:245')?.name ?? 'Avatars'},{"componentId":"3:209","pathString":"3:209","width":this.getUserPropsById('3:209')?.width ?? toPx(50),"height":this.getUserPropsById('3:209')?.height ?? toPy(50)},...this.getOverridePropsById('9:1055')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Robert Fox`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / Medium6478') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Medium6478') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Medium6478') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Medium6478') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Product Designer`)
          .fontColor('rgba(0, 1, 24, 0.4000000059604645)')
          .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('9:1056')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('9:1054')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeLight9({
          propList: [{"componentId":"9:930","pathString":"9:930"},{"componentId":"9:931","pathString":"9:931"},{"componentId":"9:932","pathString":"9:932"},{"componentId":"9:933","pathString":"9:933"},{"componentId":"9:934","pathString":"9:934"},{"componentId":"9:935","pathString":"9:935"},{"componentId":"9:936","pathString":"9:936"},{"componentId":"9:937","pathString":"9:937"},{"componentId":"9:938","pathString":"9:938"},{"componentId":"9:939","pathString":"9:939"},{"componentId":"9:940","pathString":"9:940"},{"componentId":"9:941","pathString":"9:941"},{"componentId":"9:942","pathString":"9:942"},{"componentId":"9:943","pathString":"9:943"},{"componentId":"9:944","pathString":"9:944"},{"componentId":"9:945","pathString":"9:945"},{"componentId":"9:946","pathString":"9:946"},{"componentId":"9:947","pathString":"9:947"},{"componentId":"9:948","pathString":"9:948"},{"componentId":"9:949","pathString":"9:949"},{"componentId":"9:950","pathString":"9:950"},{"componentId":"9:951","pathString":"9:951"},{"componentId":"9:952","pathString":"9:952"},{"componentId":"9:953","pathString":"9:953"},{"componentId":"9:954","pathString":"9:954"},{"componentId":"9:955","pathString":"9:955"},{"componentId":"9:956","pathString":"9:956"},{"componentId":"9:957","pathString":"9:957"},{"componentId":"9:958","pathString":"9:958"},{"componentId":"9:959","pathString":"9:959"},{"componentId":"9:1007","pathString":"9:1007"},{"componentId":"9:1044","pathString":"9:1044"},{"componentId":"9:1047","pathString":"9:1047","width":this.getUserPropsById('9:1047')?.width ?? toPx(352),"height":this.getUserPropsById('9:1047')?.height ?? toPy(84),"left":this.getUserPropsById('9:1047')?.left ?? toPx(39),"top":this.getUserPropsById('9:1047')?.top ?? toPy(96),"name":this.getUserPropsById('9:1047')?.name ?? 'Audio Message '},...this.getOverridePropsById('9:1061')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('9:1176')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('9:1176')?.width ?? toPx(430))
    .height(this.getUserPropsById('9:1176')?.height ?? toPy(212))
    .opacity(this.getUserPropsById('9:1176')?.opacity ?? 1)
    .position(this.getUserPropsById('9:1176')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('9:1176')?.top ?? toPy(20),
              left: this.getUserPropsById('9:1176')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(39), right: toPx(39) })
    .borderRadius(this.getUserPropsById('9:1176')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}