import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { ModeLightNameHoward } from '../components/ModeLightNameHoward';
import { Text } from "../style/Index"
import { ModeLight6 } from '../components/ModeLight6';
import { ModeLightNameHawkins } from '../components/ModeLightNameHawkins';


@Component
export struct ModeLight5 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(20)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(8)) } }) {
        ModeLightNameHoward({
            propList: [{"componentId":"3:233","pathString":"3:233","width":this.getUserPropsById('3:233')?.width ?? toPx(50),"height":this.getUserPropsById('3:233')?.height ?? toPy(50),"left":this.getUserPropsById('3:233')?.left ?? toPx(0),"top":this.getUserPropsById('3:233')?.top ?? toPy(0),"name":this.getUserPropsById('3:233')?.name ?? 'Avatars'},{"componentId":"3:211","pathString":"3:211","width":this.getUserPropsById('3:211')?.width ?? toPx(50),"height":this.getUserPropsById('3:211')?.height ?? toPy(50)},...this.getOverridePropsById('6:497')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Martin Howard`)
          .fontColor('rgba(190, 190, 190, 1)')
          .fontFamily((getStyleValue("text", 'Body / Medium6478') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Medium6478') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Medium6478') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Medium6478') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Design Lead`)
          .fontColor('rgba(190, 190, 190, 1)')
          .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('6:498')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('6:496')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeLight6({
          propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(178),"height":this.getUserPropsById('6:439')?.height ?? toPy(2),"left":this.getUserPropsById('6:439')?.left ?? toPx(20),"top":this.getUserPropsById('6:439')?.top ?? toPy(90),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('6:501')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(8)) } }) {
        ModeLightNameHawkins({
            propList: [{"componentId":"3:242","pathString":"3:242","width":this.getUserPropsById('3:242')?.width ?? toPx(50),"height":this.getUserPropsById('3:242')?.height ?? toPy(50),"left":this.getUserPropsById('3:242')?.left ?? toPx(0),"top":this.getUserPropsById('3:242')?.top ?? toPy(0),"name":this.getUserPropsById('3:242')?.name ?? 'Avatars'},{"componentId":"3:215","pathString":"3:215","width":this.getUserPropsById('3:215')?.width ?? toPx(50),"height":this.getUserPropsById('3:215')?.height ?? toPy(50)},...this.getOverridePropsById('6:503')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Martin Hawkins`)
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
        .id('6:504')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('6:502')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('6:512')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:512')?.width ?? toPx(218))
    .height(this.getUserPropsById('6:512')?.height ?? toPy(182))
    .opacity(this.getUserPropsById('6:512')?.opacity ?? 1)
    .position(this.getUserPropsById('6:512')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:512')?.top ?? toPy(20),
              left: this.getUserPropsById('6:512')?.left ?? toPx(258)
              })
    .padding({ bottom: toPy(20), top: toPy(20) })
    .borderRadius(this.getUserPropsById('6:512')?.cornerRadius ?? toPx(20))
    .shadow(getStyleValue("dropShadow", 'shadow21881') as ShadowOptions)
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}