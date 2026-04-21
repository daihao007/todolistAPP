import common from '@ohos.app.ability.common'
import picker from '@ohos.file.picker'
import { Permissions } from '@ohos.abilityAccessCtrl'
import { Logger } from '../utils/Logger'
import { PermissionUtil } from '../utils/PermissionUtil'

export class ImageService {
  private readonly context: common.UIAbilityContext

  constructor(context: common.UIAbilityContext) {
    this.context = context
  }

  async pickSingleImage(): Promise<string> {
    const granted = await PermissionUtil.checkAndRequestPermissions(this.context, [
      'ohos.permission.READ_IMAGEVIDEO' as Permissions
    ])

    if (!granted) {
      Logger.info('ImageService', 'Image read permission denied')
      return ''
    }

    const photoPicker = new picker.PhotoViewPicker()
    const options = new picker.PhotoSelectOptions()
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    options.maxSelectNumber = 1

    try {
      const result = await photoPicker.select(options)
      if (result.photoUris.length === 0) {
        Logger.info('ImageService', 'Image selection cancelled by user')
        return ''
      }
      return result.photoUris[0]
    } catch (error) {
      const errorCode = JSON.parse(JSON.stringify(error)).code as number | undefined
      if (errorCode === 13900012) {
        Logger.info('ImageService', 'Image selection cancelled')
        return ''
      }
      Logger.error('ImageService', `Image selection failed: ${JSON.stringify(error)}`)
      throw new Error(`Image selection failed: ${JSON.stringify(error)}`)
    }
  }
}
