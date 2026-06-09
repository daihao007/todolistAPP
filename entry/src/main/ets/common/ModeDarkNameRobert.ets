import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeDarkNameRobert {
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
      .id('3:223')
      .height(toPy(40))
      .width(toPx(40))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.e11d0914c45ac2e8efc4a64e09d9e8e523b8a6c8'))
    }
    .visibility(this.getUserPropsById('3:240')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:240')?.width ?? toPx(40))
    .height(this.getUserPropsById('3:240')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:240')?.opacity ?? 1)
    .clip(this.getUserPropsById('3:240')?.clip ?? true)
    .position(this.getUserPropsById('3:240')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:240')?.top ?? toPy(260),
              left: this.getUserPropsById('3:240')?.left ?? toPx(20)
              })
    .borderRadius(this.getUserPropsById('3:240')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeGray6474'))
  }
  
}