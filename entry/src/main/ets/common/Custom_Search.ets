import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct Custom_Search {
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
      Stack() {
        Row()
        .height(toPy(19.48))
        .width(toPx(19.48))
        .opacity(1)
        .position({ left: toPx(0), top: toPy(0) })
        Image($r('app.media.Vector4'))
        .height(toPy(19.48))
        .width(toPx(19.48))
        .opacity(1)
        .position({ left: toPx(0), top: toPy(0) })
      }
      .height(toPy(19.48))
      .width(toPx(19.48))
      .opacity(1)
      .clip(true)
      .position({ left: toPx(2), top: toPy(2) })
      Stack() {
        Row()
        .height(toPy(5.01))
        .width(toPx(5.02))
        .opacity(1)
        .position({ left: toPx(0), top: toPy(0) })
        Image($r('app.media.Vector3'))
        .height(toPy(5.01))
        .width(toPx(5.02))
        .opacity(1)
        .position({ left: toPx(0), top: toPy(0) })
      }
      .height(toPy(5.01))
      .width(toPx(5.02))
      .opacity(1)
      .clip(true)
      .position({ left: toPx(17.24), top: toPy(17.71) })
    }
    .visibility(this.getUserPropsById('8:587')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('8:587')?.width ?? toPx(24))
    .height(this.getUserPropsById('8:587')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('8:587')?.opacity ?? 1)
    .position(this.getUserPropsById('8:587')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('8:587')?.top ?? toPy(-489),
              left: this.getUserPropsById('8:587')?.left ?? toPx(6891)
              })
    .backgroundColor(this.getUserPropsById('8:587')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}