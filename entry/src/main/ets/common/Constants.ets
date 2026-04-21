export class CommonConstants {
  static readonly RDB_NAME: string = 'InspirationNote.db'
  static readonly TABLE_NOTES: string = 'notes'
  static readonly TABLE_TODOS: string = 'todos'

  static readonly COL_ID: string = 'id'
  static readonly COL_TITLE: string = 'title'
  static readonly COL_CONTENT: string = 'content'
  static readonly COL_IMAGE_PATH: string = 'imagePath'
  static readonly COL_TAGS: string = 'tags'
  static readonly COL_CREATE_TIME: string = 'createTime'
  static readonly COL_IS_TODO: string = 'isTodo'
  static readonly COL_TODO_STATUS: string = 'todoStatus'

  static readonly PAGE_INDEX: string = 'pages/Index'
  static readonly PAGE_EDIT: string = 'pages/NoteEditPage'
  static readonly PAGE_SEARCH: string = 'pages/SearchResultPage'

  static readonly DEFAULT_TAGS: string[] = ['工作', '学习', '生活']
}

export enum TodoVisualStatus {
  PENDING = '待处理',
  COMPLETED = '已完成',
  DEFERRED = '已延期'
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
  static readonly DESIGN_TITLE: string = '灵感笔记'
  static readonly DESIGN_SUBTITLE: string = '记录标题、正文、图片与待办状态，首页会自动读取数据库中的真实笔记。'
  static readonly NOTE_PREVIEW_TITLE: string = '用一张卡片承载灵感和任务'
  static readonly NOTE_PREVIEW_BODY: string = '支持标题、正文摘要、标签、图片预览和待办状态，让首页列表更统一、更易读。'
}
