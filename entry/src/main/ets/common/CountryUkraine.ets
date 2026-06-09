import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct CountryUkraine {
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
  @Prop instance_10_1715: string
  build() {
    Column() {
      Row()
      .id('10:1709')
      .height(toPy(32))
      .width(toPx(32))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.1ff9cbb19c25f0cdecdfbabcb1c5aa073a0f9e74'))
    }
    .visibility(this.getUserPropsById('10:1715')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1715')?.width ?? toPx(32))
    .height(this.getUserPropsById('10:1715')?.height ?? toPy(32))
    .opacity(this.getUserPropsById('10:1715')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1715')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1715')?.top ?? toPy(20),
              left: this.getUserPropsById('10:1715')?.left ?? toPx(20)
              })
    .backgroundColor(this.getUserPropsById('10:1715')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}