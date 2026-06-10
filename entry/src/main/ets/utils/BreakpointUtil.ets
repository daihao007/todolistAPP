import { Breakpoint, ResponsiveConstants } from '../common/Constants'

export class BreakpointUtil {
  static readonly STORAGE_KEY: string = 'currentBreakpoint'

  static init(): void {
    AppStorage.SetOrCreate<Breakpoint>(BreakpointUtil.STORAGE_KEY, Breakpoint.SM)
  }

  static updateByWidth(width: number | string): Breakpoint {
    const nextBreakpoint = BreakpointUtil.resolveBreakpoint(BreakpointUtil.normalizeWidth(width))
    AppStorage.SetOrCreate<Breakpoint>(BreakpointUtil.STORAGE_KEY, nextBreakpoint)
    return nextBreakpoint
  }

  static normalizeWidth(width: number | string): number {
    if (typeof width === 'number') {
      return width
    }
    const normalizedWidth = parseFloat(width)
    return isNaN(normalizedWidth) ? 0 : normalizedWidth
  }

  static resolveBreakpoint(widthVp: number): Breakpoint {
    if (widthVp >= ResponsiveConstants.BREAKPOINT_LG) {
      return Breakpoint.LG
    }
    if (widthVp >= ResponsiveConstants.BREAKPOINT_MD) {
      return Breakpoint.MD
    }
    return Breakpoint.SM
  }

  static getCurrentBreakpoint(): Breakpoint {
    const currentBreakpoint = AppStorage.Get<Breakpoint>(BreakpointUtil.STORAGE_KEY)
    return currentBreakpoint === undefined ? Breakpoint.SM : currentBreakpoint
  }

  static getPagePadding(breakpoint: Breakpoint): number {
    switch (breakpoint) {
      case Breakpoint.LG:
        return ResponsiveConstants.LG_PAGE_PADDING
      case Breakpoint.MD:
        return ResponsiveConstants.MD_PAGE_PADDING
      default:
        return ResponsiveConstants.SM_PAGE_PADDING
    }
  }

  static getColumns(breakpoint: Breakpoint): number {
    switch (breakpoint) {
      case Breakpoint.LG:
        return ResponsiveConstants.LG_COLUMNS
      case Breakpoint.MD:
        return ResponsiveConstants.MD_COLUMNS
      default:
        return ResponsiveConstants.SM_COLUMNS
    }
  }

  static getGridSpan(breakpoint: Breakpoint): number {
    switch (breakpoint) {
      case Breakpoint.LG:
        return 4
      case Breakpoint.MD:
        return 6
      default:
        return 12
    }
  }

  static getImageHeight(breakpoint: Breakpoint): number {
    switch (breakpoint) {
      case Breakpoint.LG:
        return ResponsiveConstants.LG_IMAGE_HEIGHT
      case Breakpoint.MD:
        return ResponsiveConstants.MD_IMAGE_HEIGHT
      default:
        return ResponsiveConstants.SM_IMAGE_HEIGHT
    }
  }

  static getContentLines(breakpoint: Breakpoint): number {
    switch (breakpoint) {
      case Breakpoint.LG:
        return ResponsiveConstants.LG_CONTENT_LINES
      case Breakpoint.MD:
        return ResponsiveConstants.MD_CONTENT_LINES
      default:
        return ResponsiveConstants.SM_CONTENT_LINES
    }
  }

  static isWide(breakpoint: Breakpoint): boolean {
    return breakpoint !== Breakpoint.SM
  }
}
