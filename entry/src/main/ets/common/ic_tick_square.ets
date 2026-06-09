import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_tick_square {
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
      Image($r('app.media.Vector21'))
      .height(toPy(14.6))
      .width(toPx(14.6))
      .opacity(1)
      .position({ left: toPx(1.95), top: toPy(1.95) })
      Image($r('app.media.Vector20'))
      .height(toPy(4.91))
      .width(toPx(6.55))
      .opacity(1)
      .position({ left: toPx(5.98), top: toPy(6.82) })
    }
    .visibility(this.getUserPropsById('10:1318')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1318')?.width ?? toPx(17))
    .height(this.getUserPropsById('10:1318')?.height ?? toPy(17))
    .opacity(this.getUserPropsById('10:1318')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1318')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1318')?.top ?? toPy(-438),
              left: this.getUserPropsById('10:1318')?.left ?? toPx(6811)
              })
    .backgroundColor(this.getUserPropsById('10:1318')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}