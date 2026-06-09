import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { CountryUkraine } from '../components/CountryUkraine';
import { CountryUnitedStates } from '../components/CountryUnitedStates';
import { CountryUnitedKingdom } from '../components/CountryUnitedKingdom';
import { CountryCanada } from '../components/CountryCanada';
import { getStyleValue } from "../style/Index"
import { Text } from "../style/Index"
import { ModeLight6 } from '../components/ModeLight6';
import { ModeDark6 } from '../components/ModeDark6';


@Component
export struct ModeLightSelectedOff {
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
  @Prop instance_10_1750: string
  @Prop instance_10_1749: string
  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        Column() {
          if(this.instance_10_1750 === 'CountryUkraine'){
            CountryUkraine({
                propList: [{"componentId":"10:1715","pathString":"10:1715","width":this.getUserPropsById('10:1715')?.width ?? toPx(32),"height":this.getUserPropsById('10:1715')?.height ?? toPy(32),"left":this.getUserPropsById('10:1715')?.left ?? toPx(0),"top":this.getUserPropsById('10:1715')?.top ?? toPy(0),"name":this.getUserPropsById('10:1715')?.name ?? 'Flags'},...this.getOverridePropsById('10:1750')]
              })
            .flexShrink(0)
          }
          if(this.instance_10_1750 === 'CountryUnitedStates'){
            CountryUnitedStates({
                propList: [{"componentId":"10:1713","pathString":"10:1715","width":this.getUserPropsById('10:1713')?.width ?? toPx(32),"height":this.getUserPropsById('10:1713')?.height ?? toPy(32),"left":this.getUserPropsById('10:1713')?.left ?? toPx(0),"top":this.getUserPropsById('10:1713')?.top ?? toPy(0),"name":this.getUserPropsById('10:1713')?.name ?? 'Flags',"componentNormName":"CountryUnitedStates"},...this.getOverridePropsById('10:1750')]
              })
            .flexShrink(0)
          }
          if(this.instance_10_1750 === 'CountryUnitedKingdom'){
            CountryUnitedKingdom({
                propList: [{"componentId":"10:1714","pathString":"10:1715","width":this.getUserPropsById('10:1714')?.width ?? toPx(32),"height":this.getUserPropsById('10:1714')?.height ?? toPy(32),"left":this.getUserPropsById('10:1714')?.left ?? toPx(0),"top":this.getUserPropsById('10:1714')?.top ?? toPy(0),"name":this.getUserPropsById('10:1714')?.name ?? 'Flags',"componentNormName":"CountryUnitedKingdom"},...this.getOverridePropsById('10:1750')]
              })
            .flexShrink(0)
          }
          if(this.instance_10_1750 === 'CountryCanada'){
            CountryCanada({
                propList: [{"componentId":"10:1716","pathString":"10:1715","width":this.getUserPropsById('10:1716')?.width ?? toPx(32),"height":this.getUserPropsById('10:1716')?.height ?? toPy(32),"left":this.getUserPropsById('10:1716')?.left ?? toPx(0),"top":this.getUserPropsById('10:1716')?.top ?? toPy(0),"name":this.getUserPropsById('10:1716')?.name ?? 'Flags',"componentNormName":"CountryCanada"},...this.getOverridePropsById('10:1750')]
              })
            .flexShrink(0)
          }
        }
        Text(`United States (+1)`)
        .fontColor('rgba(0, 1, 24, 1)')
        .fontFamily((getStyleValue("text", 'Body / Regular3136') as Text).fontFamily)
        .fontWeight((getStyleValue("text", 'Body / Regular3136') as Text).fontStyle)
        .fontSize(toPx((getStyleValue("text", 'Body / Regular3136') as Text).fontSize))
        .lineHeight((getStyleValue("text", 'Body / Regular3136') as Text).lineHeight)
        .letterSpacing('0%')
        .lineHeight('150%')
      }
      .id('10:1744')
      .height('auto')
      .width('auto')
      .opacity(1)
      .flexShrink(0)
      Column() {
        if(this.instance_10_1749 === 'ModeLight6'){
          ModeLight6({
              propList: [{"componentId":"6:439","pathString":"6:439","width":this.getUserPropsById('6:439')?.width ?? toPx(280),"height":this.getUserPropsById('6:439')?.height ?? toPy(1),"left":this.getUserPropsById('6:439')?.left ?? toPx(20),"top":this.getUserPropsById('6:439')?.top ?? toPy(64),"name":this.getUserPropsById('6:439')?.name ?? 'Divider'},...this.getOverridePropsById('10:1749')]
            })
          .flexShrink(0)
        }
        if(this.instance_10_1749 === 'ModeDark6'){
          ModeDark6({
              propList: [{"componentId":"6:440","pathString":"6:439","width":this.getUserPropsById('6:440')?.width ?? toPx(280),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"left":this.getUserPropsById('6:440')?.left ?? toPx(20),"top":this.getUserPropsById('6:440')?.top ?? toPy(64),"name":this.getUserPropsById('6:440')?.name ?? 'Divider',"componentNormName":"ModeDark"},...this.getOverridePropsById('10:1749')]
            })
          .flexShrink(0)
        }
      }
    }
    .visibility(this.getUserPropsById('10:1801')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1801')?.width ?? toPx(320))
    .height(this.getUserPropsById('10:1801')?.height ?? toPy(65))
    .opacity(this.getUserPropsById('10:1801')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1801')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1801')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1801')?.left ?? toPx(20)
              })
    .padding({ top: toPy(16) })
    .backgroundColor(this.getUserPropsById('10:1801')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 1)')
  }
  
}