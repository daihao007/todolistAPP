import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { LengthMetrics } from '@kit.ArkUI';
import { ModeLight0 } from '../components/ModeLight0';
import { ModeLightSelectedOff } from '../components/ModeLightSelectedOff';
import { ModeLightSelectedOn } from '../components/ModeLightSelectedOn';


@Component
export struct ModeLight {
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
      ModeLight0({
          propList: [{"componentId":"10:1669","pathString":"10:1669"},{"componentId":"10:1672","pathString":"10:1672"},{"componentId":"10:1722","pathString":"10:1722"},{"componentId":"10:1724","pathString":"10:1724"},{"componentId":"10:1740","pathString":"10:1740","fillPaints":this.getUserPropsById('10:1740')?.fillPaints ?? [{backgroundColor: 'rgba(239, 241, 247, 0.4000000059604645)'}],"width":this.getUserPropsById('10:1740')?.width ?? toPx(370),"height":this.getUserPropsById('10:1740')?.height ?? toPy(69),"left":this.getUserPropsById('10:1740')?.left ?? toPx(30),"top":this.getUserPropsById('10:1740')?.top ?? toPy(38),"name":this.getUserPropsById('10:1740')?.name ?? 'Phone Number'},...this.getOverridePropsById('10:1841')]
        })
      .flexShrink(0)
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start, space: { main: LengthMetrics.vp(toPx(16)) } }) {
        ModeLightSelectedOff({
            propList: [{"componentId":"10:1747","pathString":"10:1747"},{"componentId":"10:1749","pathString":"10:1749","width":this.getUserPropsById('10:1749')?.width ?? toPx(330),"height":this.getUserPropsById('10:1749')?.height ?? toPy(1)},{"componentId":"10:1713","pathString":"10:1750","componentNormName":"CountryUnitedStates"},{"componentId":"10:1801","pathString":"10:1801","width":this.getUserPropsById('10:1801')?.width ?? toPx(370),"height":this.getUserPropsById('10:1801')?.height ?? toPy(65),"left":this.getUserPropsById('10:1801')?.left ?? toPx(0),"top":this.getUserPropsById('10:1801')?.top ?? toPy(0),"name":this.getUserPropsById('10:1801')?.name ?? 'List Item'},...this.getOverridePropsById('10:1803')],
            instance_10_1750: "CountryUnitedStates"
          })
        .flexShrink(0)
        ModeLightSelectedOff({
            propList: [{"componentId":"10:1747","pathString":"10:1747","width":this.getUserPropsById('10:1747')?.width ?? toPx(164),"height":this.getUserPropsById('10:1747')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1747')?.nodeText ?? 'United Kingdom (+44)'},{"componentId":"10:1749","pathString":"10:1749","width":this.getUserPropsById('10:1749')?.width ?? toPx(330),"visibility":this.getUserPropsById('10:1749')?.visibility ?? Visibility.Visible,"height":this.getUserPropsById('10:1749')?.height ?? toPy(1)},{"componentId":"10:1714","pathString":"10:1750","componentNormName":"CountryUnitedKingdom"},{"componentId":"10:1801","pathString":"10:1801","width":this.getUserPropsById('10:1801')?.width ?? toPx(370),"height":this.getUserPropsById('10:1801')?.height ?? toPy(65),"left":this.getUserPropsById('10:1801')?.left ?? toPx(0),"top":this.getUserPropsById('10:1801')?.top ?? toPy(81),"name":this.getUserPropsById('10:1801')?.name ?? 'List Item'},{"componentId":"10:1744","pathString":"10:1744","width":this.getUserPropsById('10:1744')?.width ?? toPx(212),"height":this.getUserPropsById('10:1744')?.height ?? toPy(32)},...this.getOverridePropsById('10:1810')],
            instance_10_1750: "CountryUnitedKingdom"
          })
        .flexShrink(0)
        ModeLightSelectedOn({
            propList: [{"componentId":"10:1754","pathString":"10:1754"},{"componentId":"10:1756","pathString":"10:1756","width":this.getUserPropsById('10:1756')?.width ?? toPx(118),"height":this.getUserPropsById('10:1756')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1756')?.nodeText ?? 'Ukraine (+380)',"fontFamily":this.getUserPropsById('10:1756')?.fontFamily ?? 'Rubik',"fontWeight":this.getUserPropsById('10:1756')?.fontWeight ?? 'Medium'},{"componentId":"10:1798","pathString":"10:1798","fillPaints":this.getUserPropsById('10:1798')?.fillPaints ?? [{backgroundColor: 'rgba(239, 241, 247, 0.4000000059604645)'}],"width":this.getUserPropsById('10:1798')?.width ?? toPx(370),"height":this.getUserPropsById('10:1798')?.height ?? toPy(64),"left":this.getUserPropsById('10:1798')?.left ?? toPx(0),"top":this.getUserPropsById('10:1798')?.top ?? toPy(162),"name":this.getUserPropsById('10:1798')?.name ?? 'List Item'},{"componentId":"10:1753","pathString":"10:1753","width":this.getUserPropsById('10:1753')?.width ?? toPx(166),"height":this.getUserPropsById('10:1753')?.height ?? toPy(32)},{"componentId":"10:1777","pathString":"10:1777","left":this.getUserPropsById('10:1777')?.left ?? toPx(310),"top":this.getUserPropsById('10:1777')?.top ?? toPy(11.82)},...this.getOverridePropsById('10:1817')]
          })
        .flexShrink(0)
        ModeLightSelectedOff({
            propList: [{"componentId":"10:1747","pathString":"10:1747","width":this.getUserPropsById('10:1747')?.width ?? toPx(88),"height":this.getUserPropsById('10:1747')?.height ?? toPy(24),"nodeText":this.getUserPropsById('10:1747')?.nodeText ?? 'Canada (+1)'},{"componentId":"10:1749","pathString":"10:1749","visibility":this.getUserPropsById('10:1749')?.visibility ?? Visibility.None},{"componentId":"10:1716","pathString":"10:1750","componentNormName":"CountryCanada"},{"componentId":"10:1801","pathString":"10:1801","width":this.getUserPropsById('10:1801')?.width ?? toPx(370),"height":this.getUserPropsById('10:1801')?.height ?? toPy(48),"left":this.getUserPropsById('10:1801')?.left ?? toPx(0),"top":this.getUserPropsById('10:1801')?.top ?? toPy(242),"name":this.getUserPropsById('10:1801')?.name ?? 'List Item'},{"componentId":"10:1744","pathString":"10:1744","width":this.getUserPropsById('10:1744')?.width ?? toPx(136),"height":this.getUserPropsById('10:1744')?.height ?? toPy(32)},...this.getOverridePropsById('10:1824')],
            instance_10_1750: "CountryCanada"
          })
        .flexShrink(0)
      }
      .id('10:1831')
      .height('auto')
      .width(toPx(370))
      .opacity(1)
      .flexShrink(0)
      .backgroundColor('rgba(255, 255, 255, 1)')
    }
    .visibility(this.getUserPropsById('10:1932')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1932')?.width ?? toPx(430))
    .height(this.getUserPropsById('10:1932')?.height ?? toPy(475))
    .opacity(this.getUserPropsById('10:1932')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1932')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1932')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1932')?.left ?? toPx(20)
              })
    .padding({ bottom: toPy(38), top: toPy(38), left: toPx(30), right: toPx(30) })
    .borderRadius(this.getUserPropsById('10:1932')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeBackground3152'))
  }
  
}