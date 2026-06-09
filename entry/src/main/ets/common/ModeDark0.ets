import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { CountryUkraine } from '../components/CountryUkraine';
import { _ic_up_arrow } from '../components/_ic_up_arrow';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"


@Component
export struct ModeDark0 {
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
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(12)) } }) {
        CountryUkraine({
            propList: [{"componentId":"10:1715","pathString":"10:1715","width":this.getUserPropsById('10:1715')?.width ?? toPx(32),"height":this.getUserPropsById('10:1715')?.height ?? toPy(32),"left":this.getUserPropsById('10:1715')?.left ?? toPx(0),"top":this.getUserPropsById('10:1715')?.top ?? toPy(0),"name":this.getUserPropsById('10:1715')?.name ?? 'Flags'},...this.getOverridePropsById('10:1731')]
          })
        .flexShrink(0)
        _ic_up_arrow({
            propList: [{"componentId":"10:1703","pathString":"10:1703","strokeWeight":this.getUserPropsById('10:1703')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('10:1703')?.borderColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1708","pathString":"10:1708","width":this.getUserPropsById('10:1708')?.width ?? toPx(10),"height":this.getUserPropsById('10:1708')?.height ?? toPy(24),"left":this.getUserPropsById('10:1708')?.left ?? toPx(44),"top":this.getUserPropsById('10:1708')?.top ?? toPy(4)},...this.getOverridePropsById('10:1732')]
          })
        .flexShrink(0)
      }
      .id('10:1730')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: {  } }) {
        Text(`Phone Number`)
        .fontColor('rgba(153, 153, 163, 1)')
        .fontFamily((getStyleValue("text", 'Body Small / Regular101727') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body Small / Regular101727') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body Small / Regular101727') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body Small / Regular101727') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
        Text(`+380 23 56 784`)
        .fontColor('rgba(0, 1, 24, 1)')
        .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
      }
      .id('10:1733')
      .height('auto')
      .width(toPx(260))
      .opacity(1)
      .flexShrink(0)
    }
    .visibility(this.getUserPropsById('10:1739')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1739')?.width ?? toPx(370))
    .height(this.getUserPropsById('10:1739')?.height ?? toPy(69))
    .opacity(this.getUserPropsById('10:1739')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1739')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1739')?.top ?? toPy(107),
              left: this.getUserPropsById('10:1739')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(12), top: toPy(12), left: toPx(20), right: toPx(20) })
    .borderRadius(this.getUserPropsById('10:1739')?.cornerRadius ?? toPx(20))
    .backgroundColor($r('app.color.DarkmodeLightGray3150'))
  }
  
}