import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct CountryCanada {
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
      Row()
      .id('10:1712')
      .height(toPy(32))
      .width(toPx(32))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.e149d025a92984e8c994bc66bc5d69ba6f99f73f'))
    }
    .visibility(this.getUserPropsById('10:1716')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('10:1716')?.width ?? toPx(32))
    .height(this.getUserPropsById('10:1716')?.height ?? toPy(32))
    .opacity(this.getUserPropsById('10:1716')?.opacity ?? 1)
    .position(this.getUserPropsById('10:1716')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('10:1716')?.top ?? toPy(146),
              left: this.getUserPropsById('10:1716')?.left ?? toPx(20)
              })
    .backgroundColor(this.getUserPropsById('10:1716')?.fillPaints?.[0]?.backgroundColor ?? 'rgba(255, 255, 255, 0)')
  }
  
}