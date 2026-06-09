import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeLightDoneOn } from '../components/ModeLightDoneOn';
import { ModeLight6 } from '../components/ModeLight6';
import { ModeLightDoneOff } from '../components/ModeLightDoneOff';
import { ModeLightTypeButton } from '../components/ModeLightTypeButton';


@Component
export struct ModeLight3 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(30)) } }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(24)) } }) {
        Stack() {
          Text(`Task list`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Header / Bold6948') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Header / Bold6948') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Header / Bold6948') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Header / Bold6948') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`3/5 done`)
          .fontColor('rgba(153, 153, 163, 1)')
          .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('6:949')
        .height(toPy(27))
        .width(toPx(370))
        .opacity(1)
        .flexShrink(0)
        .backgroundColor('rgba(255, 255, 255, 0)')
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
          ModeLightDoneOn({
              propList: [{"componentId":"6:768","pathString":"6:768","width":this.getUserPropsById('6:768')?.width ?? toPx(314),"height":this.getUserPropsById('6:768')?.height ?? toPy(24)},{"componentId":"6:796","pathString":"6:796"},{"componentId":"6:797","pathString":"6:797"},{"componentId":"6:801","pathString":"6:801","width":this.getUserPropsById('6:801')?.width ?? toPx(370),"height":this.getUserPropsById('6:801')?.height ?? toPy(24),"left":this.getUserPropsById('6:801')?.left ?? toPx(0),"top":this.getUserPropsById('6:801')?.top ?? toPy(0),"name":this.getUserPropsById('6:801')?.name ?? 'To do'},...this.getOverridePropsById('6:803')]
            })
          .flexShrink(0)
          ModeLight6({
              propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(40),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('6:815')]
            })
          .flexShrink(0)
          ModeLightDoneOn({
              propList: [{"componentId":"6:768","pathString":"6:768","width":this.getUserPropsById('6:768')?.width ?? toPx(314),"height":this.getUserPropsById('6:768')?.height ?? toPy(24),"nodeText":this.getUserPropsById('6:768')?.nodeText ?? 'Present ideas and changes to team'},{"componentId":"6:796","pathString":"6:796"},{"componentId":"6:797","pathString":"6:797"},{"componentId":"6:801","pathString":"6:801","width":this.getUserPropsById('6:801')?.width ?? toPx(370),"height":this.getUserPropsById('6:801')?.height ?? toPy(24),"left":this.getUserPropsById('6:801')?.left ?? toPx(0),"top":this.getUserPropsById('6:801')?.top ?? toPy(57),"name":this.getUserPropsById('6:801')?.name ?? 'To do'},...this.getOverridePropsById('6:817')]
            })
          .flexShrink(0)
          ModeLight6({
              propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(97),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('6:829')]
            })
          .flexShrink(0)
          ModeLightDoneOn({
              propList: [{"componentId":"6:768","pathString":"6:768","width":this.getUserPropsById('6:768')?.width ?? toPx(314),"height":this.getUserPropsById('6:768')?.height ?? toPy(24),"nodeText":this.getUserPropsById('6:768')?.nodeText ?? 'Prepare User Flows'},{"componentId":"6:796","pathString":"6:796"},{"componentId":"6:797","pathString":"6:797"},{"componentId":"6:801","pathString":"6:801","width":this.getUserPropsById('6:801')?.width ?? toPx(370),"height":this.getUserPropsById('6:801')?.height ?? toPy(24),"left":this.getUserPropsById('6:801')?.left ?? toPx(0),"top":this.getUserPropsById('6:801')?.top ?? toPy(114),"name":this.getUserPropsById('6:801')?.name ?? 'To do'},...this.getOverridePropsById('6:830')]
            })
          .flexShrink(0)
          ModeLight6({
              propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(154),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('6:844')]
            })
          .flexShrink(0)
          ModeLightDoneOff({
              propList: [{"componentId":"6:781","pathString":"6:781","width":this.getUserPropsById('6:781')?.width ?? toPx(314),"height":this.getUserPropsById('6:781')?.height ?? toPy(24),"nodeText":this.getUserPropsById('6:781')?.nodeText ?? 'Prepare design style guide'},{"componentId":"6:798","pathString":"6:798"},{"componentId":"6:799","pathString":"6:799"},{"componentId":"6:800","pathString":"6:800","width":this.getUserPropsById('6:800')?.width ?? toPx(370),"height":this.getUserPropsById('6:800')?.height ?? toPy(24),"left":this.getUserPropsById('6:800')?.left ?? toPx(0),"top":this.getUserPropsById('6:800')?.top ?? toPy(171),"name":this.getUserPropsById('6:800')?.name ?? 'To do'},...this.getOverridePropsById('6:843')]
            })
          .flexShrink(0)
          ModeLight6({
              propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(211),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('6:868')]
            })
          .flexShrink(0)
          ModeLightDoneOff({
              propList: [{"componentId":"6:781","pathString":"6:781","width":this.getUserPropsById('6:781')?.width ?? toPx(314),"height":this.getUserPropsById('6:781')?.height ?? toPy(24),"nodeText":this.getUserPropsById('6:781')?.nodeText ?? 'Delivery stage: test and release  '},{"componentId":"6:798","pathString":"6:798"},{"componentId":"6:799","pathString":"6:799"},{"componentId":"6:800","pathString":"6:800","width":this.getUserPropsById('6:800')?.width ?? toPx(370),"height":this.getUserPropsById('6:800')?.height ?? toPy(24),"left":this.getUserPropsById('6:800')?.left ?? toPx(0),"top":this.getUserPropsById('6:800')?.top ?? toPy(228),"name":this.getUserPropsById('6:800')?.name ?? 'To do'},...this.getOverridePropsById('6:845')]
            })
          .flexShrink(0)
        }
        .id('6:816')
        .height('auto')
        .width(toPx(370))
        .opacity(1)
        .flexShrink(0)
        .padding({ bottom: toPy(18) })
        .backgroundColor($r('app.color.LightmodeBackground3152'))
      }
      .id('6:950')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      .backgroundColor($r('app.color.LightmodeBackground3152'))
      ModeLightTypeButton({
          propList: [{"componentId":"6:397","pathString":"6:397"},{"componentId":"6:410","pathString":"6:410"},{"componentId":"6:414","pathString":"6:414","width":this.getUserPropsById('6:414')?.width ?? toPx(369),"height":this.getUserPropsById('6:414')?.height ?? toPy(60),"left":this.getUserPropsById('6:414')?.left ?? toPx(30),"top":this.getUserPropsById('6:414')?.top ?? toPy(383),"name":this.getUserPropsById('6:414')?.name ?? 'Button'},...this.getOverridePropsById('6:951')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('7:536')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('7:536')?.width ?? toPx(430))
    .height(this.getUserPropsById('7:536')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('7:536')?.opacity ?? 1)
    .position(this.getUserPropsById('7:536')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('7:536')?.top ?? toPy(20),
              left: this.getUserPropsById('7:536')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('7:536')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}