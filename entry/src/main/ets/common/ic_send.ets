import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_send {
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
      Image($r('app.media.Vector33'))
      .height(toPy(20))
      .width(toPx(20))
      .opacity(1)
      .position({ left: toPx(2), top: toPy(2) })
    }
    .visibility(this.getUserPropsById('6:405')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:405')?.width ?? toPx(24))
    .height(this.getUserPropsById('6:405')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('6:405')?.opacity ?? 1)
    .position(this.getUserPropsById('6:405')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:405')?.top ?? toPy(-489),
              left: this.getUserPropsById('6:405')?.left ?? toPx(6819)
              })
    .backgroundColor(this.getUserPropsById('6:405')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}