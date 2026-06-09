import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct StateOn {
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
      Image($r('app.media.Vector'))
      .height(toPy(16.67))
      .width(toPx(16.67))
      .opacity(1)
      .position({ left: toPx(1.67), top: toPy(1.67) })
    }
    .visibility(this.getUserPropsById('6:751')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:751')?.width ?? toPx(20))
    .height(this.getUserPropsById('6:751')?.height ?? toPy(20))
    .opacity(this.getUserPropsById('6:751')?.opacity ?? 1)
    .position(this.getUserPropsById('6:751')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:751')?.top ?? toPy(20),
              left: this.getUserPropsById('6:751')?.left ?? toPx(20)
              })
    .backgroundColor(this.getUserPropsById('6:751')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}