import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_plus {
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
      Image($r('app.media.Stroke5'))
      .height(toPy(2.5))
      .width(toPx(12.5))
      .opacity(1)
      .position({ left: toPx(7), top: toPy(10.98) })
      Image($r('app.media.Stroke7'))
      .height(toPy(7.4))
      .width(toPx(2.5))
      .opacity(1)
      .position({ left: toPx(12), top: toPy(7) })
    }
    .visibility(this.getUserPropsById('6:409')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:409')?.width ?? toPx(24))
    .height(this.getUserPropsById('6:409')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('6:409')?.opacity ?? 1)
    .position(this.getUserPropsById('6:409')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:409')?.top ?? toPy(-489),
              left: this.getUserPropsById('6:409')?.left ?? toPx(6781)
              })
    .backgroundColor(this.getUserPropsById('6:409')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}