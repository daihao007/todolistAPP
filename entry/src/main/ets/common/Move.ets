import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct Move {
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
      Image($r('app.media.Vector9'))
      .height(toPy(1.5))
      .width(toPx(11.5))
      .opacity(1)
      .position({ left: toPx(5), top: toPy(6) })
      Image($r('app.media.Vector8'))
      .height(toPy(1.5))
      .width(toPx(11.5))
      .opacity(1)
      .position({ left: toPx(5), top: toPy(9) })
      Image($r('app.media.Vector7'))
      .height(toPy(1.5))
      .width(toPx(11.5))
      .opacity(1)
      .position({ left: toPx(5), top: toPy(12) })
    }
    .visibility(this.getUserPropsById('6:762')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:762')?.width ?? toPx(20))
    .height(this.getUserPropsById('6:762')?.height ?? toPy(20))
    .opacity(this.getUserPropsById('6:762')?.opacity ?? 1)
    .position(this.getUserPropsById('6:762')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:762')?.top ?? toPy(-487),
              left: this.getUserPropsById('6:762')?.left ?? toPx(6857)
              })
    .backgroundColor(this.getUserPropsById('6:762')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}