import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeDark6 {
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
    Column()
    .visibility(this.getUserPropsById('6:440')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:440')?.width ?? toPx(665))
    .height(this.getUserPropsById('6:440')?.height ?? toPy(1))
    .opacity(this.getUserPropsById('6:440')?.opacity ?? 1)
    .clip(this.getUserPropsById('6:440')?.clip ?? true)
    .position(this.getUserPropsById('6:440')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:440')?.top ?? toPy(20),
              left: this.getUserPropsById('6:440')?.left ?? toPx(20)
              })
    .backgroundColor($r('app.color.DarkmodeGray6474'))
  }
  
}