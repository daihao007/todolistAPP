import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { getStyleValue } from "../style/Index"
import { ModeDarkNameHoward } from '../components/ModeDarkNameHoward';
import { Text } from "../style/Index"
import { ModeDark6 } from '../components/ModeDark6';
import { ModeDarkNameHawkins } from '../components/ModeDarkNameHawkins';


@Component
export struct ModeDark5 {
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
        ModeDarkNameHoward({
            propList: [{"componentId":"3:241","pathString":"3:241","fillPaints":this.getUserPropsById('3:241')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:241')?.width ?? toPx(50),"height":this.getUserPropsById('3:241')?.height ?? toPy(50),"left":this.getUserPropsById('3:241')?.left ?? toPx(0),"top":this.getUserPropsById('3:241')?.top ?? toPy(0),"name":this.getUserPropsById('3:241')?.name ?? 'Avatars'},{"componentId":"3:227","pathString":"3:227","width":this.getUserPropsById('3:227')?.width ?? toPx(50),"height":this.getUserPropsById('3:227')?.height ?? toPy(50)},...this.getOverridePropsById('6:472')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Martin Howard`)
          .fontColor('rgba(255, 255, 255, 0.800000011920929)')
          .fontFamily((getStyleValue("text", 'Body / Medium6478') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Medium6478') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Medium6478') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Medium6478') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Design Lead`)
          .fontColor('rgba(173, 174, 181, 0.4000000059604645)')
          .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('6:446')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('6:444')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      ModeDark6({
          propList: [{"componentId":"6:440","pathString":"6:440","fillPaints":this.getUserPropsById('6:440')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('6:440')?.width ?? toPx(178),"height":this.getUserPropsById('6:440')?.height ?? toPy(2),"left":this.getUserPropsById('6:440')?.left ?? toPx(20),"top":this.getUserPropsById('6:440')?.top ?? toPy(90),"name":this.getUserPropsById('6:440')?.name ?? 'Divider'},...this.getOverridePropsById('6:480')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(8)) } }) {
        ModeDarkNameHawkins({
            propList: [{"componentId":"3:234","pathString":"3:234","fillPaints":this.getUserPropsById('3:234')?.fillPaints ?? [{backgroundColor: 'rgba(48, 50, 57, 1)'}],"width":this.getUserPropsById('3:234')?.width ?? toPx(50),"height":this.getUserPropsById('3:234')?.height ?? toPy(50),"left":this.getUserPropsById('3:234')?.left ?? toPx(0),"top":this.getUserPropsById('3:234')?.top ?? toPy(0),"name":this.getUserPropsById('3:234')?.name ?? 'Avatars'},{"componentId":"3:231","pathString":"3:231","width":this.getUserPropsById('3:231')?.width ?? toPx(50),"height":this.getUserPropsById('3:231')?.height ?? toPy(50)},...this.getOverridePropsById('6:475')]
          })
        .flexShrink(0)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
          Text(`Martin Hawkins`)
          .fontColor('rgba(255, 255, 255, 0.800000011920929)')
          .fontFamily((getStyleValue("text", 'Body / Medium6478') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body / Medium6478') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body / Medium6478') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body / Medium6478') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
          Text(`Product Designer`)
          .fontColor('rgba(173, 174, 181, 0.4000000059604645)')
          .fontFamily((getStyleValue("text", 'Body Small / Medium6479') as Text).fontFamily)
          .fontWeight((getStyleValue("text", 'Body Small / Medium6479') as Text).fontStyle)
          .fontSize(toPx((getStyleValue("text", 'Body Small / Medium6479') as Text).fontSize))
          .lineHeight((getStyleValue("text", 'Body Small / Medium6479') as Text).lineHeight)
          .letterSpacing('0%')
          .lineHeight('150%')
        }
        .id('6:452')
        .height('auto')
        .width('auto')
        .opacity(1)
        .flexShrink(0)
      }
      .id('6:450')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('6:513')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:513')?.width ?? toPx(218))
    .height(this.getUserPropsById('6:513')?.height ?? toPy(182))
    .opacity(this.getUserPropsById('6:513')?.opacity ?? 1)
    .position(this.getUserPropsById('6:513')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:513')?.top ?? toPy(20),
              left: this.getUserPropsById('6:513')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(20), top: toPy(20) })
    .borderRadius(this.getUserPropsById('6:513')?.cornerRadius ?? toPx(20))
    .shadow(getStyleValue("dropShadow", 'shadow21881') as ShadowOptions)
    .backgroundColor($r('app.color.DarkmodeLightGray3150'))
  }
  
}