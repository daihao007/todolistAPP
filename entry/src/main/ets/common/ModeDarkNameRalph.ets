import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeDarkNameRalph {
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
      .id('3:229')
      .height(toPy(40))
      .width(toPx(40))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.fdee818f54b8c3fba3690e004d2a4967c796d17d'))
    }
    .visibility(this.getUserPropsById('3:244')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:244')?.width ?? toPx(40))
    .height(this.getUserPropsById('3:244')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:244')?.opacity ?? 1)
    .clip(this.getUserPropsById('3:244')?.clip ?? true)
    .position(this.getUserPropsById('3:244')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:244')?.top ?? toPy(80),
              left: this.getUserPropsById('3:244')?.left ?? toPx(20)
              })
    .borderRadius(this.getUserPropsById('3:244')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeGray6474'))
  }
  
}