import { PixArkUIInterface } from "../entity"
import { screenAdapter, toPx, toPy } from "../utils/screenAdapter"
import { ic_plus } from '../components/ic_plus';


@Component
export struct ModeLightTypeIcon {
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
      ic_plus({
          propList: [{"componentId":"6:407","pathString":"6:407","strokeWeight":this.getUserPropsById('6:407')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:407')?.borderColor ?? 'rgba(255, 255, 255, 1)'},{"componentId":"6:408","pathString":"6:408","strokeWeight":this.getUserPropsById('6:408')?.strokeWeight ?? toPx(1),"borderColor":this.getUserPropsById('6:408')?.borderColor ?? 'rgba(255, 255, 255, 1)'},{"componentId":"6:409","pathString":"6:409","width":this.getUserPropsById('6:409')?.width ?? toPx(24),"height":this.getUserPropsById('6:409')?.height ?? toPy(24),"left":this.getUserPropsById('6:409')?.left ?? toPx(18),"top":this.getUserPropsById('6:409')?.top ?? toPy(18)},...this.getOverridePropsById('6:415')]
        })
    }
    .visibility(this.getUserPropsById('6:419')?.visibility ?? Visibility.Visible)
    .width(this.getUserPropsById('6:419')?.width ?? toPx(60))
    .height(this.getUserPropsById('6:419')?.height ?? toPy(60))
    .opacity(this.getUserPropsById('6:419')?.opacity ?? 1)
    .clip(this.getUserPropsById('6:419')?.clip ?? true)
    .position(this.getUserPropsById('6:419')?.autoLayoutByParent ?? false ? 
              undefined : {
              top: this.getUserPropsById('6:419')?.top ?? toPy(20),
              left: this.getUserPropsById('6:419')?.left ?? toPx(410)
              })
    .borderRadius(this.getUserPropsById('6:419')?.cornerRadius ?? toPx(20))
    .backgroundColor($r('app.color.LightmodeBlue3140'))
  }
  
}