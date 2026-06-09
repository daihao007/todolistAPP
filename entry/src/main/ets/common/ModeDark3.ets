import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeDarkDoneOn } from '../components/ModeDarkDoneOn';
import { ModeDark6 } from '../components/ModeDark6';
import { ModeDarkDoneOff } from '../components/ModeDarkDoneOff';
import { ModeDarkTypeButton } from '../components/ModeDarkTypeButton';


@Component
export struct ModeDark3 {
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
        .id('7:404')
        .height(toPy(27))
        .width(toPx(370))
        .opacity(1)
        .flexShrink(0)
        .backgroundColor('rgba(255, 255, 255, 0)')
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
          ModeDarkDoneOn({
              propList: [{"componentId":"7:309","pathString":"7:309","width":this.getUserPropsById('7:309')?.width ?? toPx(370),"height":this.getUserPropsById('7:309')?.height ?? toPy(24),"left":this.getUserPropsById('7:309')?.left ?? toPx(0),"top":this.getUserPropsById('7:309')?.top ?? toPy(0),"name":this.getUserPropsById('7:309')?.name ?? 'To do'},{"componentId":"7:310","pathString":"7:310"},{"componentId":"7:312","pathString":"7:312"},{"componentId":"7:314","pathString":"7:314","width":this.getUserPropsById('7:314')?.width ?? toPx(314),"height":this.getUserPropsById('7:314')?.height ?? toPy(24)},...this.getOverridePropsById('7:408')]
            })
          .flexShrink(0)
          ModeDark6({
              propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(40),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('7:409')]
            })
          .flexShrink(0)
          ModeDarkDoneOn({
              propList: [{"componentId":"7:309","pathString":"7:309","width":this.getUserPropsById('7:309')?.width ?? toPx(370),"height":this.getUserPropsById('7:309')?.height ?? toPy(24),"left":this.getUserPropsById('7:309')?.left ?? toPx(0),"top":this.getUserPropsById('7:309')?.top ?? toPy(57),"name":this.getUserPropsById('7:309')?.name ?? 'To do'},{"componentId":"7:310","pathString":"7:310"},{"componentId":"7:312","pathString":"7:312"},{"componentId":"7:314","pathString":"7:314","width":this.getUserPropsById('7:314')?.width ?? toPx(314),"height":this.getUserPropsById('7:314')?.height ?? toPy(24),"nodeText":this.getUserPropsById('7:314')?.nodeText ?? 'Present ideas and changes to team',"fontColor":this.getUserPropsById('7:314')?.fontColor ?? 'rgba(190, 190, 190, 1)'},...this.getOverridePropsById('7:410')]
            })
          .flexShrink(0)
          ModeDark6({
              propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(97),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('7:411')]
            })
          .flexShrink(0)
          ModeDarkDoneOn({
              propList: [{"componentId":"7:309","pathString":"7:309","width":this.getUserPropsById('7:309')?.width ?? toPx(370),"height":this.getUserPropsById('7:309')?.height ?? toPy(24),"left":this.getUserPropsById('7:309')?.left ?? toPx(0),"top":this.getUserPropsById('7:309')?.top ?? toPy(114),"name":this.getUserPropsById('7:309')?.name ?? 'To do'},{"componentId":"7:310","pathString":"7:310"},{"componentId":"7:312","pathString":"7:312"},{"componentId":"7:314","pathString":"7:314","width":this.getUserPropsById('7:314')?.width ?? toPx(314),"height":this.getUserPropsById('7:314')?.height ?? toPy(24),"nodeText":this.getUserPropsById('7:314')?.nodeText ?? 'Prepare User Flows'},...this.getOverridePropsById('7:412')]
            })
          .flexShrink(0)
          ModeDark6({
              propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(154),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('7:413')]
            })
          .flexShrink(0)
          ModeDarkDoneOff({
              propList: [{"componentId":"7:315","pathString":"7:315","width":this.getUserPropsById('7:315')?.width ?? toPx(370),"height":this.getUserPropsById('7:315')?.height ?? toPy(24),"left":this.getUserPropsById('7:315')?.left ?? toPx(0),"top":this.getUserPropsById('7:315')?.top ?? toPy(171),"name":this.getUserPropsById('7:315')?.name ?? 'To do'},{"componentId":"7:316","pathString":"7:316"},{"componentId":"7:318","pathString":"7:318"},{"componentId":"7:320","pathString":"7:320","width":this.getUserPropsById('7:320')?.width ?? toPx(314),"height":this.getUserPropsById('7:320')?.height ?? toPy(24),"nodeText":this.getUserPropsById('7:320')?.nodeText ?? 'Prepare design style guide'},...this.getOverridePropsById('7:414')]
            })
          .flexShrink(0)
          ModeDark6({
              propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(370),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(0),"top":this.getUserPropsById('6:440')?.top ?? toPy(211),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('7:415')]
            })
          .flexShrink(0)
          ModeDarkDoneOff({
              propList: [{"componentId":"7:315","pathString":"7:315","width":this.getUserPropsById('7:315')?.width ?? toPx(370),"height":this.getUserPropsById('7:315')?.height ?? toPy(24),"left":this.getUserPropsById('7:315')?.left ?? toPx(0),"top":this.getUserPropsById('7:315')?.top ?? toPy(228),"name":this.getUserPropsById('7:315')?.name ?? 'To do'},{"componentId":"7:316","pathString":"7:316"},{"componentId":"7:318","pathString":"7:318"},{"componentId":"7:320","pathString":"7:320","width":this.getUserPropsById('7:320')?.width ?? toPx(314),"height":this.getUserPropsById('7:320')?.height ?? toPy(24),"nodeText":this.getUserPropsById('7:320')?.nodeText ?? 'Delivery stage: test and release  '},...this.getOverridePropsById('7:416')]
            })
          .flexShrink(0)
        }
        .id('7:407')
        .height('auto')
        .width(toPx(370))
        .opacity(1)
        .flexShrink(0)
        .padding({ bottom: toPy(18) })
        .backgroundColor($r('app.color.DarkmodeBackground2168'))
      }
      .id('7:403')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      .backgroundColor($r('app.color.DarkmodeBackground2168'))
      ModeDarkTypeButton({
          propList: [{"componentId":"6:428","pathString":"6:428","fillPaints":this.getUserPropsById('6:428')?.fillPaints ?? [{backgroundColor: 'rgba(47, 105, 254, 1)'}],"width":this.getUserPropsById('6:428')?.width ?? toPx(369),"height":this.getUserPropsById('6:428')?.height ?? toPy(60),"left":this.getUserPropsById('6:428')?.left ?? toPx(30),"top":this.getUserPropsById('6:428')?.top ?? toPy(383),"name":this.getUserPropsById('6:428')?.name ?? 'Button'},{"componentId":"6:429","pathString":"6:429"},{"componentId":"6:430","pathString":"6:430"},...this.getOverridePropsById('7:417')]
        })
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('7:537')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('7:537')?.width ?? toPx(430))
    .height(this.getUserPropsById('7:537')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('7:537')?.opacity ?? 1)
    .position(this.getUserPropsById('7:537')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('7:537')?.top ?? toPy(20),
              left: this.getUserPropsById('7:537')?.left ?? toPx(499)
              })
    .padding({ bottom: toPy(32), top: toPy(32), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('7:537')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}