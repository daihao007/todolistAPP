import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeLightNameHoward {
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
      .id('3:211')
      .height(toPy(40))
      .width(toPx(40))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.0591ef88c173c93df864b4c4e832f064d220c82d'))
    }
    .visibility(this.getUserPropsById('3:233')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:233')?.width ?? toPx(40))
    .height(this.getUserPropsById('3:233')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:233')?.opacity ?? 1)
    .clip(this.getUserPropsById('3:233')?.clip ?? true)
    .position(this.getUserPropsById('3:233')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:233')?.top ?? toPy(140),
              left: this.getUserPropsById('3:233')?.left ?? toPx(80)
              })
    .borderRadius(this.getUserPropsById('3:233')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.LightmodeLightGray3144'))
  }
  
}