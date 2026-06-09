import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDarkPositioningLeft } from '../components/ModeDarkPositioningLeft';
import { ModeDarkStateMessage } from '../components/ModeDarkStateMessage';
import { ModeDarkPositioningRight } from '../components/ModeDarkPositioningRight';
import { ModeDarkStateYourReply } from '../components/ModeDarkStateYourReply';
import { ModeDarkStateTyping } from '../components/ModeDarkStateTyping';
import { ModeDark6 } from '../components/ModeDark6';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeDarkTypePlus } from '../components/ModeDarkTypePlus';
import { ModeDarkTypeVoice } from '../components/ModeDarkTypeVoice';
import { ModeDarkTypeImage } from '../components/ModeDarkTypeImage';
import { ModeDarkTypeIcon } from '../components/ModeDarkTypeIcon';
import { ModeDark5 } from '../components/ModeDark5';


@Component
export struct ModeDark4 {
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
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(20)) } }) {
        Stack() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
            ModeDarkPositioningLeft({
                propList: [{"componentId":"3:156","pathString":"3:156"},{"componentId":"3:157","pathString":"3:157"},{"componentId":"3:267","pathString":"3:267"},{"componentId":"3:278","pathString":"3:278","width":this.getUserPropsById('3:278')?.width ?? toPx(261),"height":this.getUserPropsById('3:278')?.height ?? toPy(40),"left":this.getUserPropsById('3:278')?.left ?? toPx(0),"top":this.getUserPropsById('3:278')?.top ?? toPy(0),"name":this.getUserPropsById('3:278')?.name ?? 'Reply'},...this.getOverridePropsById('6:595')]
              })
            .flexShrink(0)
            ModeDarkStateMessage({
                propList: [{"componentId":"3:145","pathString":"3:145","fillPaints":this.getUserPropsById('3:145')?.fillPaints ?? [{backgroundColor: 'rgba(47, 105, 254, 1)'}],"width":this.getUserPropsById('3:145')?.width ?? toPx(570),"height":this.getUserPropsById('3:145')?.height ?? toPy(72),"left":this.getUserPropsById('3:145')?.left ?? toPx(0),"top":this.getUserPropsById('3:145')?.top ?? toPy(56),"name":this.getUserPropsById('3:145')?.name ?? 'Сonversation bubble'},{"componentId":"3:146","pathString":"3:146","width":this.getUserPropsById('3:146')?.width ?? toPx(538),"height":this.getUserPropsById('3:146')?.height ?? toPy(48),"nodeText":this.getUserPropsById('3:146')?.nodeText ?? 'Hey, fellas! I think we can share part of our Design system with Dribble community. What do you think?'},...this.getOverridePropsById('6:596')]
              })
            .flexShrink(0)
          }
          .id('6:594')
          .height(toPy(128))
          .width(toPx(570))
          .opacity(1)
          .position({ left: toPx(0), top: toPy(0) })
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.End, space: { main: LengthMetrics.vp(toPx(16)) } }) {
            ModeDarkPositioningRight({
                propList: [{"componentId":"3:161","pathString":"3:161","nodeText":this.getUserPropsById('3:161')?.nodeText ?? '15 min ago'},{"componentId":"3:162","pathString":"3:162","width":this.getUserPropsById('3:162')?.width ?? toPx(103),"height":this.getUserPropsById('3:162')?.height ?? toPy(24),"nodeText":this.getUserPropsById('3:162')?.nodeText ?? 'Jenny Wilson'},{"componentId":"3:270","pathString":"3:270","left":this.getUserPropsById('3:270')?.left ?? toPx(207),"top":this.getUserPropsById('3:270')?.top ?? toPy(0)},{"componentId":"3:279","pathString":"3:279","width":this.getUserPropsById('3:279')?.width ?? toPx(247),"height":this.getUserPropsById('3:279')?.height ?? toPy(40),"left":this.getUserPropsById('3:279')?.left ?? toPx(153),"top":this.getUserPropsById('3:279')?.top ?? toPy(0),"name":this.getUserPropsById('3:279')?.name ?? 'Reply'},...this.getOverridePropsById('6:598')]
              })
            .flexShrink(0)
            ModeDarkStateYourReply({
                propList: [{"componentId":"3:147","pathString":"3:147","width":this.getUserPropsById('3:147')?.width ?? toPx(400),"height":this.getUserPropsById('3:147')?.height ?? toPy(72),"left":this.getUserPropsById('3:147')?.left ?? toPx(0),"top":this.getUserPropsById('3:147')?.top ?? toPy(56),"name":this.getUserPropsById('3:147')?.name ?? 'Сonversation bubble'},{"componentId":"3:148","pathString":"3:148","width":this.getUserPropsById('3:148')?.width ?? toPx(368),"height":this.getUserPropsById('3:148')?.height ?? toPy(48),"nodeText":this.getUserPropsById('3:148')?.nodeText ?? 'Hi! I think this is brilliant idea 😍 Do you have any specific components you want to share?'},...this.getOverridePropsById('6:599')]
              })
            .flexShrink(0)
          }
          .id('6:597')
          .height(toPy(128))
          .width(toPx(400))
          .opacity(1)
          .position({ left: toPx(418), top: toPy(138) })
          ModeDarkStateTyping({
              propList: [{"componentId":"3:250","pathString":"3:250"},{"componentId":"3:251","pathString":"3:251"},{"componentId":"3:252","pathString":"3:252"},{"componentId":"3:253","pathString":"3:253"},{"componentId":"3:254","pathString":"3:254"},{"componentId":"3:255","pathString":"3:255","width":this.getUserPropsById('3:255')?.width ?? toPx(146),"height":this.getUserPropsById('3:255')?.height ?? toPy(24),"left":this.getUserPropsById('3:255')?.left ?? toPx(0),"top":this.getUserPropsById('3:255')?.top ?? toPy(276),"name":this.getUserPropsById('3:255')?.name ?? 'Сonversation bubble'},...this.getOverridePropsById('6:600')]
            })
        }
        .id('6:593')
        .height(toPy(300))
        .width(toPx(818))
        .opacity(1)
        .flexShrink(0)
        .backgroundColor('rgba(255, 255, 255, 0)')
        ModeDark6({
            propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(818),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(320),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('6:601')]
          })
        .flexShrink(0)
      }
      .id('6:592')
      .height('auto')
      .width(toPx(818))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor($r('app.color.DarkmodeBackground2168'))
      Stack() {
        Stack() {
          Stack()
          .id('6:604')
          .height(toPy(27))
          .width(toPx(68))
          .opacity(1)
          .clip(true)
          .position({ left: toPx(134), top: toPy(0) })
          .borderRadius(toPx(4))
          .backgroundColor($r('app.color.DarkmodeGray6474'))
          Text(`What do you think @Martin`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('6:603')
        .height(toPy(27))
        .width(toPx(202))
        .opacity(1)
        .position({ left: toPx(0), top: toPy(17) })
        .backgroundColor('rgba(255, 255, 255, 0)')
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(40)) } }) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(20)) } }) {
            ModeDarkTypePlus({
                propList: [{"componentId":"6:342","pathString":"6:342","width":this.getUserPropsById('6:342')?.width ?? toPx(24),"height":this.getUserPropsById('6:342')?.height ?? toPy(24),"left":this.getUserPropsById('6:342')?.left ?? toPx(0),"top":this.getUserPropsById('6:342')?.top ?? toPy(0),"name":this.getUserPropsById('6:342')?.name ?? 'Messenger Icon'},...this.getOverridePropsById('6:608')]
              })
            .flexShrink(0)
            ModeDarkTypeVoice({
                propList: [{"componentId":"6:341","pathString":"6:341","width":this.getUserPropsById('6:341')?.width ?? toPx(24),"height":this.getUserPropsById('6:341')?.height ?? toPy(24),"left":this.getUserPropsById('6:341')?.left ?? toPx(44),"top":this.getUserPropsById('6:341')?.top ?? toPy(0),"name":this.getUserPropsById('6:341')?.name ?? 'Messenger Icon'},...this.getOverridePropsById('6:609')]
              })
            .flexShrink(0)
            ModeDarkTypeImage({
                propList: [{"componentId":"6:340","pathString":"6:340","width":this.getUserPropsById('6:340')?.width ?? toPx(24),"height":this.getUserPropsById('6:340')?.height ?? toPy(24),"left":this.getUserPropsById('6:340')?.left ?? toPx(88),"top":this.getUserPropsById('6:340')?.top ?? toPy(0),"name":this.getUserPropsById('6:340')?.name ?? 'Messenger Icon'},...this.getOverridePropsById('6:610')]
              })
            .flexShrink(0)
          }
          .id('6:607')
          .height('auto')
          .width('auto')
          .opacity(1)
          .flexShrink(0)
          ModeDarkTypeIcon({
              propList: [{"componentId":"6:431","pathString":"6:431","fillPaints":this.getUserPropsById('6:431')?.fillPaints ?? [{backgroundColor: 'rgba(47, 105, 254, 1)'}],"width":this.getUserPropsById('6:431')?.width ?? toPx(60),"height":this.getUserPropsById('6:431')?.height ?? toPy(60),"left":this.getUserPropsById('6:431')?.left ?? toPx(152),"top":this.getUserPropsById('6:431')?.top ?? toPy(0),"name":this.getUserPropsById('6:431')?.name ?? 'Button'},...this.getOverridePropsById('6:611')]
            })
          .flexShrink(0)
        }
        .id('6:606')
        .height(toPy(60))
        .width(toPx(212))
        .opacity(1)
        .position({ left: toPx(606), top: toPy(0) })
      }
      .id('6:602')
      .height(toPy(60))
      .width(toPx(818))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 0)')
      ModeDark5({
          propList: [{"componentId":"6:444","pathString":"6:444"},{"componentId":"6:446","pathString":"6:446"},{"componentId":"6:447","pathString":"6:447"},{"componentId":"6:448","pathString":"6:448"},{"componentId":"6:450","pathString":"6:450"},{"componentId":"6:452","pathString":"6:452"},{"componentId":"6:453","pathString":"6:453"},{"componentId":"6:454","pathString":"6:454"},{"componentId":"6:472","pathString":"6:472"},{"componentId":"6:475","pathString":"6:475"},{"componentId":"6:480","pathString":"6:480"},{"componentId":"6:513","pathString":"6:513","width":this.getUserPropsById('6:513')?.width ?? toPx(218),"height":this.getUserPropsById('6:513')?.height ?? toPy(182),"left":this.getUserPropsById('6:513')?.left ?? toPx(216),"top":this.getUserPropsById('6:513')?.top ?? toPy(196),"name":this.getUserPropsById('6:513')?.name ?? 'Autosuggestion'},...this.getOverridePropsById('6:701')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('6:728')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:728')?.width ?? toPx(910))
    .height(this.getUserPropsById('6:728')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('6:728')?.opacity ?? 1)
    .position(this.getUserPropsById('6:728')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:728')?.top ?? toPy(515),
              left: this.getUserPropsById('6:728')?.left ?? toPx(20)
              })
    .padding({ left: toPx(46), right: toPx(46) })
    .borderRadius(this.getUserPropsById('6:728')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}