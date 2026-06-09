import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_play {
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
      Image($r('app.media.Stroke1'))
      .height(toPy(20.5))
      .width(toPx(20.5))
      .opacity(1)
      .position({ left: toPx(2.5), top: toPy(2.5) })
      Image($r('app.media.Stroke3'))
      .height(toPy(7.5))
      .width(toPx(6.5))
      .opacity(1)
      .position({ left: toPx(10), top: toPy(9) })
    }
    .visibility(this.getUserPropsById('9:1006')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('9:1006')?.width ?? toPx(24))
    .height(this.getUserPropsById('9:1006')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('9:1006')?.opacity ?? 1)
    .position(this.getUserPropsById('9:1006')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('9:1006')?.top ?? toPy(-489),
              left: this.getUserPropsById('9:1006')?.left ?? toPx(6929)
              })
    .backgroundColor(this.getUserPropsById('9:1006')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}