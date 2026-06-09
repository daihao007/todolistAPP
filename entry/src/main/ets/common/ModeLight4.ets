import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLightPositioningLeft } from '../components/ModeLightPositioningLeft';
import { ModeLightStateMessage } from '../components/ModeLightStateMessage';
import { ModeLightPositioningRight } from '../components/ModeLightPositioningRight';
import { ModeLightStateYourReply } from '../components/ModeLightStateYourReply';
import { ModeLightStateTyping } from '../components/ModeLightStateTyping';
import { ModeLight6 } from '../components/ModeLight6';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeLightTypePlus } from '../components/ModeLightTypePlus';
import { ModeLightTypeVoice } from '../components/ModeLightTypeVoice';
import { ModeLightTypeImage } from '../components/ModeLightTypeImage';
import { ModeLightTypeIcon } from '../components/ModeLightTypeIcon';
import { ModeLight5 } from '../components/ModeLight5';


@Component
export struct ModeLight4 {
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
            ModeLightPositioningLeft({
                propList: [{"componentId":"3:168","pathString":"3:168"},{"componentId":"3:169","pathString":"3:169"},{"componentId":"3:272","pathString":"3:272"},{"componentId":"3:280","pathString":"3:280","width":this.getUserPropsById('3:280')?.width ?? toPx(261),"height":this.getUserPropsById('3:280')?.height ?? toPy(40),"left":this.getUserPropsById('3:280')?.left ?? toPx(0),"top":this.getUserPropsById('3:280')?.top ?? toPy(0),"name":this.getUserPropsById('3:280')?.name ?? 'Reply'},...this.getOverridePropsById('6:517')]
              })
            .flexShrink(0)
            ModeLightStateMessage({
                propList: [{"componentId":"2:1883","pathString":"2:1883","width":this.getUserPropsById('2:1883')?.width ?? toPx(570),"height":this.getUserPropsById('2:1883')?.height ?? toPy(72),"left":this.getUserPropsById('2:1883')?.left ?? toPx(0),"top":this.getUserPropsById('2:1883')?.top ?? toPy(56),"name":this.getUserPropsById('2:1883')?.name ?? 'Сonversation bubble'},{"componentId":"2:1884","pathString":"2:1884","width":this.getUserPropsById('2:1884')?.width ?? toPx(538),"height":this.getUserPropsById('2:1884')?.height ?? toPy(48),"nodeText":this.getUserPropsById('2:1884')?.nodeText ?? 'Hey, fellas! I think we can share part of our Design system with Dribble community. What do you think?'},...this.getOverridePropsById('6:515')]
              })
            .flexShrink(0)
          }
          .id('6:526')
          .height(toPy(128))
          .width(toPx(570))
          .opacity(1)
          .position({ left: toPx(0), top: toPy(0) })
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.End, space: { main: LengthMetrics.vp(toPx(16)) } }) {
            ModeLightPositioningRight({
                propList: [{"componentId":"3:173","pathString":"3:173","nodeText":this.getUserPropsById('3:173')?.nodeText ?? '15 min ago'},{"componentId":"3:174","pathString":"3:174","width":this.getUserPropsById('3:174')?.width ?? toPx(103),"height":this.getUserPropsById('3:174')?.height ?? toPy(24),"nodeText":this.getUserPropsById('3:174')?.nodeText ?? 'Jenny Wilson'},{"componentId":"3:275","pathString":"3:275","left":this.getUserPropsById('3:275')?.left ?? toPx(207),"top":this.getUserPropsById('3:275')?.top ?? toPy(0)},{"componentId":"3:281","pathString":"3:281","width":this.getUserPropsById('3:281')?.width ?? toPx(247),"height":this.getUserPropsById('3:281')?.height ?? toPy(40),"left":this.getUserPropsById('3:281')?.left ?? toPx(153),"top":this.getUserPropsById('3:281')?.top ?? toPy(0),"name":this.getUserPropsById('3:281')?.name ?? 'Reply'},...this.getOverridePropsById('6:528')]
              })
            .flexShrink(0)
            ModeLightStateYourReply({
                propList: [{"componentId":"2:1885","pathString":"2:1885","width":this.getUserPropsById('2:1885')?.width ?? toPx(400),"height":this.getUserPropsById('2:1885')?.height ?? toPy(72),"left":this.getUserPropsById('2:1885')?.left ?? toPx(0),"top":this.getUserPropsById('2:1885')?.top ?? toPy(56),"name":this.getUserPropsById('2:1885')?.name ?? 'Сonversation bubble'},{"componentId":"2:1886","pathString":"2:1886","width":this.getUserPropsById('2:1886')?.width ?? toPx(368),"height":this.getUserPropsById('2:1886')?.height ?? toPy(48),"nodeText":this.getUserPropsById('2:1886')?.nodeText ?? 'Hi! I think this is brilliant idea 😍 Do you have any specific components you want to share?'},...this.getOverridePropsById('6:529')]
              })
            .flexShrink(0)
          }
          .id('6:527')
          .height(toPy(128))
          .width(toPx(400))
          .opacity(1)
          .position({ left: toPx(418), top: toPy(138) })
          ModeLightStateTyping({
              propList: [{"componentId":"3:256","pathString":"3:256","width":this.getUserPropsById('3:256')?.width ?? toPx(146),"height":this.getUserPropsById('3:256')?.height ?? toPy(24),"left":this.getUserPropsById('3:256')?.left ?? toPx(0),"top":this.getUserPropsById('3:256')?.top ?? toPy(276),"name":this.getUserPropsById('3:256')?.name ?? 'Сonversation bubble'},{"componentId":"3:257","pathString":"3:257"},{"componentId":"3:258","pathString":"3:258"},{"componentId":"3:259","pathString":"3:259"},{"componentId":"3:260","pathString":"3:260"},{"componentId":"3:261","pathString":"3:261"},...this.getOverridePropsById('6:552')]
            })
        }
        .id('6:559')
        .height(toPy(300))
        .width(toPx(818))
        .opacity(1)
        .flexShrink(0)
        .backgroundColor('rgba(255, 255, 255, 0)')
        ModeLight6({
            propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(818),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(0),"top":this.getUserPropsById('6:439')?.top ?? toPy(320),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('6:561')]
          })
        .flexShrink(0)
      }
      .id('6:562')
      .height('auto')
      .width(toPx(818))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 1)')
      Stack() {
        Stack() {
          Stack()
          .id('6:587')
          .height(toPy(27))
          .width(toPx(68))
          .opacity(1)
          .clip(true)
          .position({ left: toPx(134), top: toPy(0) })
          .borderRadius(toPx(4))
          .backgroundColor($r('app.color.LightmodeLightGray3144'))
          Text(`What do you think @Martin`)
          .fontColor('rgba(0, 1, 24, 1)')
          .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('6:588')
        .height(toPy(27))
        .width(toPx(202))
        .opacity(1)
        .position({ left: toPx(0), top: toPy(17) })
        .backgroundColor('rgba(255, 255, 255, 0)')
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(40)) } }) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(20)) } }) {
            ModeLightTypePlus({
                propList: [{"componentId":"6:376","pathString":"6:376","width":this.getUserPropsById('6:376')?.width ?? toPx(24),"height":this.getUserPropsById('6:376')?.height ?? toPy(24),"left":this.getUserPropsById('6:376')?.left ?? toPx(0),"top":this.getUserPropsById('6:376')?.top ?? toPy(0),"name":this.getUserPropsById('6:376')?.name ?? 'Messenger Icon'},...this.getOverridePropsById('6:563')]
              })
            .flexShrink(0)
            ModeLightTypeVoice({
                propList: [{"componentId":"6:382","pathString":"6:382","width":this.getUserPropsById('6:382')?.width ?? toPx(24),"height":this.getUserPropsById('6:382')?.height ?? toPy(24),"left":this.getUserPropsById('6:382')?.left ?? toPx(44),"top":this.getUserPropsById('6:382')?.top ?? toPy(0),"name":this.getUserPropsById('6:382')?.name ?? 'Messenger Icon'},...this.getOverridePropsById('6:564')]
              })
            .flexShrink(0)
            ModeLightTypeImage({
                propList: [{"componentId":"6:386","pathString":"6:386","width":this.getUserPropsById('6:386')?.width ?? toPx(24),"height":this.getUserPropsById('6:386')?.height ?? toPy(24),"left":this.getUserPropsById('6:386')?.left ?? toPx(88),"top":this.getUserPropsById('6:386')?.top ?? toPy(0),"name":this.getUserPropsById('6:386')?.name ?? 'Messenger Icon'},...this.getOverridePropsById('6:565')]
              })
            .flexShrink(0)
          }
          .id('6:583')
          .height('auto')
          .width('auto')
          .opacity(1)
          .flexShrink(0)
          ModeLightTypeIcon({
              propList: [{"componentId":"6:419","pathString":"6:419","width":this.getUserPropsById('6:419')?.width ?? toPx(60),"height":this.getUserPropsById('6:419')?.height ?? toPy(60),"left":this.getUserPropsById('6:419')?.left ?? toPx(152),"top":this.getUserPropsById('6:419')?.top ?? toPy(0),"name":this.getUserPropsById('6:419')?.name ?? 'Button'},...this.getOverridePropsById('6:579')]
            })
          .flexShrink(0)
        }
        .id('6:585')
        .height(toPy(60))
        .width(toPx(212))
        .opacity(1)
        .position({ left: toPx(606), top: toPy(0) })
      }
      .id('6:589')
      .height(toPy(60))
      .width(toPx(818))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 0)')
      ModeLight5({
          propList: [{"componentId":"6:496","pathString":"6:496"},{"componentId":"6:497","pathString":"6:497"},{"componentId":"6:498","pathString":"6:498"},{"componentId":"6:499","pathString":"6:499"},{"componentId":"6:500","pathString":"6:500"},{"componentId":"6:501","pathString":"6:501"},{"componentId":"6:502","pathString":"6:502"},{"componentId":"6:503","pathString":"6:503"},{"componentId":"6:504","pathString":"6:504"},{"componentId":"6:505","pathString":"6:505"},{"componentId":"6:506","pathString":"6:506"},{"componentId":"6:512","pathString":"6:512","width":this.getUserPropsById('6:512')?.width ?? toPx(218),"height":this.getUserPropsById('6:512')?.height ?? toPy(182),"left":this.getUserPropsById('6:512')?.left ?? toPx(216),"top":this.getUserPropsById('6:512')?.top ?? toPy(196),"name":this.getUserPropsById('6:512')?.name ?? 'Autosuggestion'},...this.getOverridePropsById('6:687')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('6:729')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:729')?.width ?? toPx(910))
    .height(this.getUserPropsById('6:729')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('6:729')?.opacity ?? 1)
    .position(this.getUserPropsById('6:729')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:729')?.top ?? toPy(20),
              left: this.getUserPropsById('6:729')?.left ?? toPx(20)
              })
    .padding({ left: toPx(46), right: toPx(46) })
    .borderRadius(this.getUserPropsById('6:729')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}