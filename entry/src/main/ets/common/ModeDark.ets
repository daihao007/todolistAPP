import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeDark0 } from '../components/ModeDark0';
import { ModeLightSelectedOff } from '../components/ModeLightSelectedOff';
import { ModeLightSelectedOn } from '../components/ModeLightSelectedOn';


@Component
export struct ModeDark {
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
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(toPx(24)) } }) {
      ModeDark0({
          propList: [{"componentId":"10:1730","pathString":"10:1730"},{"componentId":"10:1731","pathString":"10:1731"},{"componentId":"10:1732","pathString":"10:1732"},{"componentId":"10:1733","pathString":"10:1733"},{"componentId":"10:1739","pathString":"10:1739","width":this.getUserPropsById('10:1739')?.width ?? toPx(370),"height":this.getUserPropsById('10:1739')?.height ?? toPy(69),"left":this.getUserPropsById('10:1739')?.left ?? toPx(30),"top":this.getUserPropsById('10:1739')?.top ?? toPy(38),"name":this.getUserPropsById('10:1739')?.name ?? 'Phone Number'},...this.getOverridePropsById('10:1884')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        ModeLightSelectedOff({
            propList: [{"componentId":"10:1747","pathString":"10:1747","width":this.getUserPropsById('10:1747')?.width ?? toPx(132),"height":this.getUserPropsById('10:1747')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1747')?.nodeText ?? 'United States (+1)',"fontColor":this.getUserPropsById('10:1747')?.fontColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"6:440","pathString":"10:1749","width":this.getUserPropsById('6:440')?.width ?? toPx(330),"height":this.getUserPropsById('6:440')?.height ?? toPy(1),"componentNormName":"ModeDark"},{"componentId":"10:1713","pathString":"10:1750","componentNormName":"CountryUnitedStates"},{"componentId":"10:1801","pathString":"10:1801","fillPaints":this.getUserPropsById('10:1801')?.fillPaints ?? [{backgroundColor: 'rgba(15, 14, 19, 1)'}],"width":this.getUserPropsById('10:1801')?.width ?? toPx(370),"height":this.getUserPropsById('10:1801')?.height ?? toPy(48),"left":this.getUserPropsById('10:1801')?.left ?? toPx(0),"top":this.getUserPropsById('10:1801')?.top ?? toPy(0),"name":this.getUserPropsById('10:1801')?.name ?? 'List Item'},{"componentId":"10:1744","pathString":"10:1744","width":this.getUserPropsById('10:1744')?.width ?? toPx(180),"height":this.getUserPropsById('10:1744')?.height ?? toPy(32)},...this.getOverridePropsById('10:1886')],
            instance_10_1749: "ModeDark",
            instance_10_1750: "CountryUnitedStates"
          })
        .flexShrink(0)
        ModeLightSelectedOff({
            propList: [{"componentId":"10:1747","pathString":"10:1747","width":this.getUserPropsById('10:1747')?.width ?? toPx(164),"height":this.getUserPropsById('10:1747')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1747')?.nodeText ?? 'United Kingdom (+44)',"fontColor":this.getUserPropsById('10:1747')?.fontColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1749","pathString":"10:1749","width":this.getUserPropsById('10:1749')?.width ?? toPx(330),"visibility":this.getUserPropsById('10:1749')?.visibility ?? Visibility.Visible,"height":this.getUserPropsById('10:1749')?.height ?? toPy(1)},{"componentId":"10:1714","pathString":"10:1750","componentNormName":"CountryUnitedKingdom"},{"componentId":"10:1801","pathString":"10:1801","fillPaints":this.getUserPropsById('10:1801')?.fillPaints ?? [{backgroundColor: 'rgba(15, 14, 19, 1)'}],"width":this.getUserPropsById('10:1801')?.width ?? toPx(370),"height":this.getUserPropsById('10:1801')?.height ?? toPy(65),"left":this.getUserPropsById('10:1801')?.left ?? toPx(0),"top":this.getUserPropsById('10:1801')?.top ?? toPy(64),"name":this.getUserPropsById('10:1801')?.name ?? 'List Item'},{"componentId":"10:1744","pathString":"10:1744","width":this.getUserPropsById('10:1744')?.width ?? toPx(212),"height":this.getUserPropsById('10:1744')?.height ?? toPy(32)},...this.getOverridePropsById('10:1887')],
            instance_10_1750: "CountryUnitedKingdom"
          })
        .flexShrink(0)
        ModeLightSelectedOn({
            propList: [{"componentId":"10:1754","pathString":"10:1754"},{"componentId":"10:1756","pathString":"10:1756","width":this.getUserPropsById('10:1756')?.width ?? toPx(118),"height":this.getUserPropsById('10:1756')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1756')?.nodeText ?? 'Ukraine (+380)',"fontColor":this.getUserPropsById('10:1756')?.fontColor ?? 'rgba(255, 255, 255, 1)',"fontFamily":this.getUserPropsById('10:1756')?.fontFamily ?? 'Rubik',"fontWeight":this.getUserPropsById('10:1756')?.fontWeight ?? 'Medium'},{"componentId":"10:1798","pathString":"10:1798","fillPaints":this.getUserPropsById('10:1798')?.fillPaints ?? [{backgroundColor: 'rgba(42, 42, 42, 1)'}],"width":this.getUserPropsById('10:1798')?.width ?? toPx(370),"height":this.getUserPropsById('10:1798')?.height ?? toPy(64),"left":this.getUserPropsById('10:1798')?.left ?? toPx(0),"top":this.getUserPropsById('10:1798')?.top ?? toPy(145),"name":this.getUserPropsById('10:1798')?.name ?? 'List Item'},{"componentId":"10:1753","pathString":"10:1753","width":this.getUserPropsById('10:1753')?.width ?? toPx(166),"height":this.getUserPropsById('10:1753')?.height ?? toPy(32)},{"componentId":"10:1777","pathString":"10:1777","left":this.getUserPropsById('10:1777')?.left ?? toPx(310),"top":this.getUserPropsById('10:1777')?.top ?? toPy(11.82)},...this.getOverridePropsById('10:1888')]
          })
        .flexShrink(0)
        ModeLightSelectedOff({
            propList: [{"componentId":"10:1747","pathString":"10:1747","width":this.getUserPropsById('10:1747')?.width ?? toPx(88),"height":this.getUserPropsById('10:1747')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1747')?.nodeText ?? 'Canada (+1)',"fontColor":this.getUserPropsById('10:1747')?.fontColor ?? 'rgba(190, 190, 190, 1)'},{"componentId":"10:1749","pathString":"10:1749","visibility":this.getUserPropsById('10:1749')?.visibility ?? Visibility.None},{"componentId":"10:1716","pathString":"10:1750","componentNormName":"CountryCanada"},{"componentId":"10:1801","pathString":"10:1801","fillPaints":this.getUserPropsById('10:1801')?.fillPaints ?? [{backgroundColor: 'rgba(15, 14, 19, 1)'}],"width":this.getUserPropsById('10:1801')?.width ?? toPx(370),"height":this.getUserPropsById('10:1801')?.height ?? toPy(48),"left":this.getUserPropsById('10:1801')?.left ?? toPx(0),"top":this.getUserPropsById('10:1801')?.top ?? toPy(225),"name":this.getUserPropsById('10:1801')?.name ?? 'List Item'},{"componentId":"10:1744","pathString":"10:1744","width":this.getUserPropsById('10:1744')?.width ?? toPx(136),"height":this.getUserPropsById('10:1744')?.height ?? toPy(32)},...this.getOverridePropsById('10:1889')],
            instance_10_1750: "CountryCanada"
          })
        .flexShrink(0)
      }
      .id('10:1885')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor($r('app.color.DarkmodeBackground2168'))
    }
    .visibility(this.getUserPropsById('10:1931')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1931')?.width ?? toPx(430))
    .height(this.getUserPropsById('10:1931')?.height ?? toPy(458))
    .opacity(this.getUserPropsById('10:1931')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1931')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1931')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1931')?.left ?? toPx(470)
              })
    .padding({ bottom: toPy(38), top: toPy(38), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('10:1931')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeBackground2168'))
  }
  
}