import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeDarkNameArchie {
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
      .id('3:213')
      .height(toPy(40))
      .width(toPx(40))
      .opacity(1)
      .position({ left: toPx(0), top: toPy(0) })
      .backgroundImageSize(ImageSize.FILL)
      .backgroundImage($r('app.media.36a2055d6eb22801e6652b385975543e90768a3f'))
    }
    .visibility(this.getUserPropsById('3:235')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('3:235')?.width ?? toPx(40))
    .height(this.getUserPropsById('3:235')?.height ?? toPy(40))
    .opacity(this.getUserPropsById('3:235')?.opacity ?? 1)
    .clip(this.getUserPropsById('3:235')?.clip ?? true)
    .position(this.getUserPropsById('3:235')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('3:235')?.top ?? toPy(320),
              left: this.getUserPropsById('3:235')?.left ?? toPx(20)
              })
    .borderRadius(this.getUserPropsById('3:235')?.cornerRadius ?? toPx(50))
    .backgroundColor($r('app.color.DarkmodeGray6474'))
  }
  
}