export enum TodoVisualStatus {
  PENDING = '\u5F85\u5904\u7406',
  COMPLETED = '\u5DF2\u5B8C\u6210',
  DEFERRED = '\u5DF2\u5EF6\u671F'
}

export class UiConstants {
  static readonly PAGE_PADDING: number = 16
  static readonly CARD_RADIUS: number = 20
  static readonly CHIP_RADIUS: number = 12
  static readonly BUTTON_RADIUS: number = 16
  static readonly SECTION_SPACING: number = 16
  static readonly CONTENT_SPACING: number = 12
  static readonly TITLE_SIZE: number = 20
  static readonly SUBTITLE_SIZE: number = 16
  static readonly BODY_SIZE: number = 14
  static readonly CAPTION_SIZE: number = 12
  static readonly CARD_SHADOW_RADIUS: number = 18
}

export class UiPalette {
  static readonly PAGE_BACKGROUND: string = '#F6F7FB'
  static readonly SURFACE: string = '#FFFFFF'
  static readonly SURFACE_MUTED: string = '#F0F3FA'
  static readonly PRIMARY: string = '#2F6BFF'
  static readonly PRIMARY_SOFT: string = '#E8EEFF'
  static readonly ACCENT: string = '#23B18A'
  static readonly TEXT_PRIMARY: string = '#1F2430'
  static readonly TEXT_SECONDARY: string = '#667085'
  static readonly TEXT_MUTED: string = '#98A2B3'
  static readonly BORDER: string = '#E4E7EC'
  static readonly WARNING: string = '#FFB020'
  static readonly WARNING_SOFT: string = '#FFF3D6'
  static readonly SUCCESS: string = '#12B76A'
  static readonly SUCCESS_SOFT: string = '#DCFCE7'
  static readonly DANGER: string = '#F04438'
  static readonly DANGER_SOFT: string = '#FEE4E2'
  static readonly TAG_WORK: string = '#EEF4FF'
  static readonly TAG_STUDY: string = '#ECFDF3'
  static readonly TAG_LIFE: string = '#FFF1F3'
}

export class UiCopywriting {
  static readonly DESIGN_TITLE: string = '\u7075\u611F\u7B14\u8BB0'
  static readonly DESIGN_SUBTITLE: string = '\u7EDF\u4E00\u7EC4\u4EF6\u548C\u89C6\u89C9\u89C4\u8303\u793A\u4F8B'
  static readonly NOTE_PREVIEW_TITLE: string = '\u7528\u4E00\u5F20\u5361\u7247\u627F\u63A5\u7075\u611F\u548C\u4EFB\u52A1'
  static readonly NOTE_PREVIEW_BODY: string =
    '\u652F\u6301\u6807\u9898\u3001\u6B63\u6587\u6458\u8981\u3001\u6807\u7B7E\u3001\u56FE\u7247\u7F29\u7565\u4FE1\u606F\u548C\u5F85\u529E\u72B6\u6001\uFF0C\u8BA9\u9996\u9875\u5217\u8868\u770B\u8D77\u6765\u7EDF\u4E00\u3001\u6E05\u723D\u3001\u53EF\u626B\u63CF\u3002'
}
