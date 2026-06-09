import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ic_chat {
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
      Image($r('app.media.Vector19'))
      .height(toPy(14.83))
      .width(toPx(14.83))
      .opacity(1)
      .position({ left: toPx(1.33), top: toPy(1.33) })
      Image($r('app.media.Vector18'))
      .height(toPy(2))
      .width(toPx(2.01))
      .opacity(1)
      .position({ left: toPx(10.3), top: toPy(7.94) })
      Image($r('app.media.Vector16'))
      .height(toPy(2))
      .width(toPx(2.01))
      .opacity(1)
      .position({ left: toPx(7.62), top: toPy(7.94) })
      Image($r('app.media.Vector17'))
      .height(toPy(2))
      .width(toPx(2.01))
      .opacity(1)
      .position({ left: toPx(4.95), top: toPy(7.94) })
    }
    .visibility(this.getUserPropsById('10:1317')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1317')?.width ?? toPx(16))
    .height(this.getUserPropsById('10:1317')?.height ?? toPy(16))
    .opacity(this.getUserPropsById('10:1317')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1317')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1317')?.top ?? toPy(-438),
              left: this.getUserPropsById('10:1317')?.left ?? toPx(6781)
              })
    .backgroundColor(this.getUserPropsById('10:1317')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}