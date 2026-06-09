import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct _ic_up_arrow {
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
      Image($r('app.media.Vector6'))
      .visibility(Visibility.None)
      .height(toPy(18.5))
      .width(toPx(18.5))
      .opacity(1)
      .position({ left: toPx(-4.25), top: toPy(2.75) })
      Image($r('app.media.Vector5'))
      .height(toPy(5.03))
      .width(toPx(8.45))
      .opacity(1)
      .position({ left: toPx(1.53), top: toPy(9.96) })
    }
    .visibility(this.getUserPropsById('10:1708')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1708')?.width ?? toPx(10))
    .height(this.getUserPropsById('10:1708')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('10:1708')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1708')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1708')?.top ?? toPy(-438),
              left: this.getUserPropsById('10:1708')?.left ?? toPx(6931)
              })
    .backgroundColor(this.getUserPropsById('10:1708')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}