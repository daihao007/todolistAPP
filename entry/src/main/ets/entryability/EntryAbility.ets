import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { window } from '@kit.ArkUI'
import { CommonConstants } from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'

const DOMAIN = 0x0000

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
    } catch (err) {
      hilog.error(DOMAIN, 'EntryAbility', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err))
    }

    void this.initializeDatabase()
    hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onCreate')
  }

  private async initializeDatabase(): Promise<void> {
    try {
      await RdbStoreManager.getInstance(this.context).initDb()
      hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Database initialized')
    } catch (error) {
      hilog.error(DOMAIN, 'EntryAbility', 'Failed to initialize database. Cause: %{public}s', JSON.stringify(error))
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onWindowStageCreate')

    windowStage.loadContent(CommonConstants.PAGE_INDEX, (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'EntryAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err))
        return
      }
      hilog.info(DOMAIN, 'EntryAbility', 'Succeeded in loading the content.')
    })
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onWindowStageDestroy')
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onForeground')
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onBackground')
  }
}
