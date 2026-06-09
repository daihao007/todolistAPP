import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"


@Component
export struct ModeLight6 {
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
  @Prop instance_6_439: string
  build() {
    Column()
    .visibility(this.getUserPropsById('6:439')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:439')?.width ?? toPx(665))
    .height(this.getUserPropsById('6:439')?.height ?? toPy(1))
    .opacity(this.getUserPropsById('6:439')?.opacity ?? 1)
    .clip(this.getUserPropsById('6:439')?.clip ?? true)
    .position(this.getUserPropsById('6:439')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:439')?.top ?? toPy(47),
              left: this.getUserPropsById('6:439')?.left ?? toPx(20)
              })
    .backgroundColor($r('app.color.LightmodeLightGray3144'))
  }
  
}