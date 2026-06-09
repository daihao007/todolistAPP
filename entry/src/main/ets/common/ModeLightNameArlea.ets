import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeLightNameArlea {
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
      .id('3:196')
      .height(toPy(40))
      .width(toPx(40))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.c53224ba61e3d3b2200bc54e63185308f42c7b54'))
    }
    .visibility(this.getUserPropsById('3:236')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:236')?.width ?? toPx(40))
    .height(this.getUserPropsById('3:236')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:236')?.opacity ?? 1)
    .position(this.getUserPropsById('3:236')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:236')?.top ?? toPy(385),
              left: this.getUserPropsById('3:236')?.left ?? toPx(80)
              })
    .borderRadius(this.getUserPropsById('3:236')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeLightGray3144'))
  }
  
}