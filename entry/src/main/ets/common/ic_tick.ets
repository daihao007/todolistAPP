import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_tick {
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
      Image($r('app.media.Vector32'))
      .height(toPy(10.83))
      .width(toPx(14.78))
      .opacity(1)
      .position({ left: toPx(12.61), top: toPy(14.57) })
    }
    .visibility(this.getUserPropsById('10:1764')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1764')?.width ?? toPx(40))
    .height(this.getUserPropsById('10:1764')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('10:1764')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1764')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1764')?.top ?? toPy(-442),
              left: this.getUserPropsById('10:1764')?.left ?? toPx(6891)
              })
    .backgroundColor(this.getUserPropsById('10:1764')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}