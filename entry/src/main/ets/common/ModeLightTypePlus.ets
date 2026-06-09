import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeLightTypePlus {
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
      Image($r('app.media.Vector10'))
      .height(toPy(20))
      .width(toPx(17))
      .opacity(1)
      .position({ left: toPx(3.5), top: toPy(2) })
    }
    .visibility(this.getUserPropsById('6:376')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:376')?.width ?? toPx(24))
    .height(this.getUserPropsById('6:376')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('6:376')?.opacity ?? 1)
    .position(this.getUserPropsById('6:376')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:376')?.top ?? toPy(20),
              left: this.getUserPropsById('6:376')?.left ?? toPx(152)
              })
    .backgroundColor(this.getUserPropsById('6:376')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}