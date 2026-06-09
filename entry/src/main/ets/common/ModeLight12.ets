import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLightNameArchie } from '../components/ModeLightNameArchie';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeLight6 } from '../components/ModeLight6';
import { ModeLightNameArlea } from '../components/ModeLightNameArlea';


@Component
export struct ModeLight12 {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        ModeLightNameArchie({
            propList: [{"componentId":"3:243","pathString":"3:243","width":this.getUserPropsById('3:243')?.width ?? toPx(40),"height":this.getUserPropsById('3:243')?.height ?? toPy(40),"left":this.getUserPropsById('3:243')?.left ?? toPx(0),"top":this.getUserPropsById('3:243')?.top ?? toPy(1),"name":this.getUserPropsById('3:243')?.name ?? 'Avatars'},...this.getOverridePropsById('8:671')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Archi Fox`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(5)) } }) {
            Image($r('app.media.Ellipse51'))
            .height(toPy(8))
            .width(toPx(8))
            .opacity(1)
            .flexShrink(0)
            Text(`Active now`)
            .fontColor('rgba(0, 1, 24, 0.4000000059604645)')
            .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
            .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
            .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
            .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
            .letterSpacing('0%')
            .lineHeight('150%')
          }
          .id('8:636')
          .height('auto')
          .width(toPx(314))
          .opacity(1)
          .flexShrink(0)
        }
        .id('8:634')
        .height('auto')
        .width(toPx(314))
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:632')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      ModeLight6({
          propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(58),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('8:677')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        ModeLightNameArlea({
            propList: [{"componentId":"3:236","pathString":"3:236","width":this.getUserPropsById('3:236')?.width ?? toPx(40),"height":this.getUserPropsById('3:236')?.height ?? toPy(40),"left":this.getUserPropsById('3:236')?.left ?? toPx(0),"top":this.getUserPropsById('3:236')?.top ?? toPy(1),"name":this.getUserPropsById('3:236')?.name ?? 'Avatars'},...this.getOverridePropsById('8:679')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Arlea Fisher`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(5)) } }) {
            Image($r('app.media.Ellipse52'))
            .height(toPy(8))
            .width(toPx(8))
            .opacity(1)
            .flexShrink(0)
            Text(`Active now`)
            .fontColor('rgba(153, 153, 163, 1)')
            .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
            .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
            .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
            .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
            .letterSpacing('0%')
            .lineHeight('150%')
          }
          .id('8:682')
          .height('auto')
          .width(toPx(314))
          .opacity(1)
          .flexShrink(0)
        }
        .id('8:680')
        .height('auto')
        .width(toPx(314))
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:678')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      ModeLight6({
          propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(133),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('8:692')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Stack() {
          Row()
          .id('8:651')
          .height(toPy(24))
          .width(toPx(24))
          .opacity(1)
          .position({ left: toPx(8), top: toPy(8) })
          .backgroundImageSize(ImageSize.FILL)
          .backgroundImage($r('app.media.e36c16a0709981ae6387c2862d8054dd23aad282'))
        }
        .id('8:650')
        .height(toPy(40))
        .width(toPx(40))
        .opacity(1)
        .flexShrink(0)
        .borderRadius(toPx(50))
        .backgroundColor($r('app.color.LightmodeLightGray3144'))
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`AR Design file`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Figma file`)
          .fontColor('rgba(0, 1, 24, 0.4000000059604645)')
          .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('8:652')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:649')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeLight6({
          propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(370),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(208),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('8:693')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Stack() {
          Stack() {
            Image($r('app.media.Folder0'))
            .height(toPy(16.67))
            .width(toPx(16.67))
            .opacity(1)
            .position({ left: toPx(1.67), top: toPy(1.67) })
          }
          .id('8:687')
          .height(toPy(20))
          .width(toPx(20))
          .opacity(1)
          .position({ left: toPx(10), top: toPy(10) })
          .backgroundColor('rgba(255, 255, 255, 0)')
        }
        .id('8:658')
        .height(toPy(40))
        .width(toPx(40))
        .opacity(1)
        .flexShrink(0)
        .borderRadius(toPx(50))
        .backgroundColor('rgba(239, 241, 247, 1)')
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`AR Conceptualization`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / SemiBold3269') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / SemiBold3269') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / SemiBold3269') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / SemiBold3269') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(5)) } }) {
            Text(`Folder`)
            .fontColor('rgba(0, 1, 24, 0.4000000059604645)')
            .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
            .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
            .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
            .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
            .letterSpacing('0%')
            .lineHeight('150%')
            Image($r('app.media.Smalldivider0'))
            .height(toPy(2))
            .width(toPx(2))
            .opacity(1)
            .flexShrink(0)
            Text(`Edited 12 min`)
            .fontColor('rgba(0, 1, 24, 0.4000000059604645)')
            .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
            .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
            .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
            .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
            .letterSpacing('0%')
            .lineHeight('150%')
          }
          .id('8:662')
          .height('auto')
          .width(toPx(314))
          .opacity(1)
          .flexShrink(0)
        }
        .id('8:660')
        .height('auto')
        .width(toPx(314))
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:657')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('8:736')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:736')?.width ?? toPx(370))
    .height(this.getUserPropsById('8:736')?.height ?? toPy(283))
    .opacity(this.getUserPropsById('8:736')?.opacity ?? 1)
    .position(this.getUserPropsById('8:736')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:736')?.top ?? toPy(20),
              left: this.getUserPropsById('8:736')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(16) })
    .backgroundColor(this.getUserPropsById('8:736')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 1)')
  }
  
}