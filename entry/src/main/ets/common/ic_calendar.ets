import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_calendar {
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
    Column() {
      Image($r('app.media.Vector30'))
      .height(toPy(1.5))
      .width(toPx(13.38))
      .opacity(1)
      .position({ left: toPx(2.06), top: toPy(5.95) })
      Image($r('app.media.Vector25'))
      .height(toPy(1.5))
      .width(toPx(1.51))
      .opacity(1)
      .position({ left: toPx(10.66), top: toPy(8.56) })
      Image($r('app.media.Vector22'))
      .height(toPy(1.5))
      .width(toPx(1.51))
      .opacity(1)
      .position({ left: toPx(7.7), top: toPy(8.56) })
      Image($r('app.media.Vector24'))
      .height(toPy(1.5))
      .width(toPx(1.51))
      .opacity(1)
      .position({ left: toPx(4.73), top: toPy(8.56) })
      Image($r('app.media.Vector26'))
      .height(toPy(1.5))
      .width(toPx(1.51))
      .opacity(1)
      .position({ left: toPx(10.66), top: toPy(11.15) })
      Image($r('app.media.Vector31'))
      .height(toPy(1.5))
      .width(toPx(1.51))
      .opacity(1)
      .position({ left: toPx(7.7), top: toPy(11.15) })
      Image($r('app.media.Vector29'))
      .height(toPy(1.5))
      .width(toPx(1.51))
      .opacity(1)
      .position({ left: toPx(4.73), top: toPy(11.15) })
      Image($r('app.media.Vector28'))
      .height(toPy(3.69))
      .width(toPx(1.5))
      .opacity(1)
      .position({ left: toPx(10.39), top: toPy(1.33) })
      Image($r('app.media.Vector27'))
      .height(toPy(3.69))
      .width(toPx(1.5))
      .opacity(1)
      .position({ left: toPx(5), top: toPy(1.33) })
      Image($r('app.media.Vector23'))
      .height(toPy(13.78))
      .width(toPx(13.5))
      .opacity(1)
      .position({ left: toPx(2), top: toPy(2.39) })
    }
    .visibility(this.getUserPropsById('10:1319')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1319')?.width ?? toPx(16))
    .height(this.getUserPropsById('10:1319')?.height ?? toPy(16))
    .opacity(this.getUserPropsById('10:1319')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1319')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1319')?.top ?? toPy(-438),
              left: this.getUserPropsById('10:1319')?.left ?? toPx(6842)
              })
    .backgroundColor(this.getUserPropsById('10:1319')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}