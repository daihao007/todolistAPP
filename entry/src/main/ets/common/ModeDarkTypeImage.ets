import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeDarkTypeImage {
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
      Image($r('app.media.Vector14'))
      .height(toPy(20))
      .width(toPx(20))
      .opacity(1)
      .position({ left: toPx(2), top: toPy(2) })
    }
    .visibility(this.getUserPropsById('6:340')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:340')?.width ?? toPx(24))
    .height(this.getUserPropsById('6:340')?.height ?? toPy(24))
    .opacity(this.getUserPropsById('6:340')?.opacity ?? 0.800000011920929)
    .position(this.getUserPropsById('6:340')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:340')?.top ?? toPy(20),
              left: this.getUserPropsById('6:340')?.left ?? toPx(108)
              })
    .backgroundColor(this.getUserPropsById('6:340')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}