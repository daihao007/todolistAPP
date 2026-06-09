import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDarkNameArchie } from '../components/ModeDarkNameArchie';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeDark6 } from '../components/ModeDark6';
import { ModeDarkNameArlea } from '../components/ModeDarkNameArlea';


@Component
export struct ModeDark12 {
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
        ModeDarkNameArchie({
            propList: [{"componentId":"3:235","pathString":"3:235","fillPaints":this.getUserPropsById('3:235')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:235')?.width ?? toPx(40),"height":this.getUserPropsById('3:235')?.height ?? toPy(40),"left":this.getUserPropsById('3:235')?.left ?? toPx(0),"top":this.getUserPropsById('3:235')?.top ?? toPy(1),"name":this.getUserPropsById('3:235')?.name ?? 'Avatars'},...this.getOverridePropsById('8:696')]
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
            Image($r('app.media.Ellipse5'))
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
          .id('8:699')
          .height('auto')
          .width(toPx(314))
          .opacity(1)
          .flexShrink(0)
        }
        .id('8:697')
        .height('auto')
        .width(toPx(314))
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:695')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      ModeDark6({
          propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(58),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('8:702')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        ModeDarkNameArlea({
            propList: [{"componentId":"3:232","pathString":"3:232","fillPaints":this.getUserPropsById('3:232')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:232')?.width ?? toPx(40),"height":this.getUserPropsById('3:232')?.height ?? toPy(40),"left":this.getUserPropsById('3:232')?.left ?? toPx(0),"top":this.getUserPropsById('3:232')?.top ?? toPy(1),"name":this.getUserPropsById('3:232')?.name ?? 'Avatars'},...this.getOverridePropsById('8:704')]
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
            Image($r('app.media.Ellipse50'))
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
          .id('8:707')
          .height('auto')
          .width(toPx(314))
          .opacity(1)
          .flexShrink(0)
        }
        .id('8:705')
        .height('auto')
        .width(toPx(314))
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:703')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      ModeDark6({
          propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(133),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('8:710')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Stack() {
          Row()
          .id('8:713')
          .height(toPy(24))
          .width(toPx(24))
          .opacity(1)
          .position({ left: toPx(8), top: toPy(8) })
          .backgroundImageSize(ImageSize.FILL)
          .backgroundImage($r('app.media.e36c16a0709981ae6387c2862d8054dd23aad282'))
        }
        .id('8:712')
        .height(toPy(40))
        .width(toPx(40))
        .opacity(1)
        .flexShrink(0)
        .borderRadius(toPx(50))
        .backgroundColor($r('app.color.DarkmodeGray6474'))
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
          .fontColor('rgba(153, 153, 163, 1)')
          .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('8:714')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:711')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeDark6({
          propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(208),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('8:717')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Stack() {
          Stack() {
            Image($r('app.media.Folder'))
            .height(toPy(16.67))
            .width(toPx(16.67))
            .opacity(1)
            .position({ left: toPx(1.67), top: toPy(1.67) })
          }
          .id('8:720')
          .height(toPy(20))
          .width(toPx(20))
          .opacity(1)
          .position({ left: toPx(10), top: toPy(10) })
          .backgroundColor('rgba(255, 255, 255, 0)')
        }
        .id('8:719')
        .height(toPy(40))
        .width(toPx(40))
        .opacity(1)
        .flexShrink(0)
        .borderRadius(toPx(50))
        .backgroundColor($r('app.color.DarkmodeGray6474'))
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
            .fontColor('rgba(153, 153, 163, 1)')
            .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
            .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
            .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
            .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
            .letterSpacing('0%')
            .lineHeight('150%')
            Image($r('app.media.Smalldivider'))
            .height(toPy(2))
            .width(toPx(2))
            .opacity(1)
            .flexShrink(0)
            Text(`Edited 12 min`)
            .fontColor('rgba(153, 153, 163, 1)')
            .fontFamily((getStyleValue("text", 'Label 8675') as Text).fontFamily)
            .fontWeight((getStyleValue("text", 'Label 8675') as Text).fontStyle)
            .fontSize(toPx((getStyleValue("text", 'Label 8675') as Text).fontSize))
            .lineHeight((getStyleValue("text", 'Label 8675') as Text).lineHeight)
            .letterSpacing('0%')
            .lineHeight('150%')
          }
          .id('8:726')
          .height('auto')
          .width(toPx(314))
          .opacity(0.4000000059604645)
          .flexShrink(0)
        }
        .id('8:724')
        .height('auto')
        .width(toPx(314))
        .opacity(1)
        .flexShrink(0)
      }
      .id('8:718')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('8:735')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:735')?.width ?? toPx(370))
    .height(this.getUserPropsById('8:735')?.height ?? toPy(283))
    .opacity(this.getUserPropsById('8:735')?.opacity ?? 1)
    .position(this.getUserPropsById('8:735')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:735')?.top ?? toPy(20),
              left: this.getUserPropsById('8:735')?.left ?? toPx(436)
              })
    .padding({ bottom: toPy(16) })
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}