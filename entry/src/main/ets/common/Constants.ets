export class CommonConstants {
  static readonly RDB_NAME: string = 'InspirationNote.db'
  static readonly TABLE_NOTES: string = 'notes'
  static readonly TABLE_TODOS: string = 'todos'

  static readonly COL_ID: string = 'id'
  static readonly COL_TITLE: string = 'title'
  static readonly COL_CONTENT: string = 'content'
  static readonly COL_IMAGE_PATH: string = 'imagePath'
  static readonly COL_TAGS: string = 'tags'
  static readonly COL_SUMMARY: string = 'summary'
  static readonly COL_ACTION_ITEMS: string = 'actionItems'
  static readonly COL_AI_TAGS: string = 'aiTags'
  static readonly COL_PRIORITY: string = 'priority'
  static readonly COL_CREATE_TIME: string = 'createTime'
  static readonly COL_IS_TODO: string = 'isTodo'
  static readonly COL_TODO_STATUS: string = 'todoStatus'

  static readonly PAGE_INDEX: string = 'pages/Index'
  static readonly PAGE_EDIT: string = 'pages/NoteEditPage'
  static readonly PAGE_SEARCH: string = 'pages/SearchResultPage'

  static readonly DEFAULT_TAGS: string[] = ['工作', '学习', '生活']
  static readonly AI_CLOUD_API_URL: string = 'https://token-plan-cn.xiaomimimo.com/v1/chat/completions'
  static readonly AI_CLOUD_API_KEY: string = 'tp-c9cqps25t5rt2s647ass0ceje248scgexi3967it5zq862cs'
  static readonly AI_CLOUD_MODEL: string = 'mimo-v2-omni'
}

export enum TodoVisualStatus {
  NONE = '无状态',
  PENDING = '待处理',
  COMPLETED = '已完成',
  DEFERRED = '已延期'
}

export class UiConstants {
  static readonly PAGE_PADDING: number = 20
  static readonly CARD_RADIUS: number = 24
  static readonly CHIP_RADIUS: number = 12
  static readonly BUTTON_RADIUS: number = 999
  static readonly SECTION_SPACING: number = 24
  static readonly CONTENT_SPACING: number = 12
  static readonly TITLE_SIZE: number = 28
  static readonly SUBTITLE_SIZE: number = 18
  static readonly BODY_SIZE: number = 15
  static readonly BODY_LARGE_SIZE: number = 16
  static readonly CAPTION_SIZE: number = 12
  static readonly LABEL_SIZE: number = 14
  static readonly CONTROL_HEIGHT: number = 56
  static readonly COMPACT_CONTROL_HEIGHT: number = 44
  static readonly CARD_PADDING: number = 16
  static readonly FORM_PADDING: number = 30
  static readonly FIELD_RADIUS: number = 14
  static readonly MEDIA_RADIUS: number = 16
  static readonly ICON_SIZE: number = 20
  static readonly CARD_SHADOW_RADIUS: number = 24
}

export enum Breakpoint {
  SM = 'sm',
  MD = 'md',
  LG = 'lg'
}

export class ResponsiveConstants {
  static readonly BREAKPOINT_MD: number = 600
  static readonly BREAKPOINT_LG: number = 840

  static readonly SM_PAGE_PADDING: number = 20
  static readonly MD_PAGE_PADDING: number = 24
  static readonly LG_PAGE_PADDING: number = 32

  static readonly SM_COLUMNS: number = 1
  static readonly MD_COLUMNS: number = 2
  static readonly LG_COLUMNS: number = 3

  static readonly SM_IMAGE_HEIGHT: number = 160
  static readonly MD_IMAGE_HEIGHT: number = 180
  static readonly LG_IMAGE_HEIGHT: number = 200

  static readonly SM_CONTENT_LINES: number = 3
  static readonly MD_CONTENT_LINES: number = 4
  static readonly LG_CONTENT_LINES: number = 5

  static readonly FORM_MAX_WIDTH: number = 760
  static readonly SEARCH_MAX_WIDTH: number = 960
}

export class UiPalette {
  static readonly PAGE_BACKGROUND: string = '#FDFBFA' // 奶泡白
  static readonly SURFACE: string = '#FFFFFF'
  static readonly SURFACE_MUTED: string = '#F8F3F0' // 燕麦色
  static readonly PRIMARY: string = '#FFB7C5' // 樱花奶冻粉
  static readonly PRIMARY_SOFT: string = '#FFECF0' 
  static readonly ACCENT: string = '#D1C4E9' // 香芋奶紫
  static readonly TEXT_PRIMARY: string = '#5C5454' // 摩卡深褐
  static readonly TEXT_SECONDARY: string = '#A39E9E' // 奶茶灰
  static readonly TEXT_MUTED: string = '#CABFBF' 
  static readonly BORDER: string = '#E8E2D9' // 浅杏色
  static readonly WARNING: string = '#FFB885' // 芝士橙
  static readonly WARNING_SOFT: string = '#FFF2E8'
  static readonly SUCCESS: string = '#B5D5C5' // 薄荷海盐绿
  static readonly SUCCESS_SOFT: string = '#E6F2EC'
  static readonly DANGER: string = '#FAACA8' // 西柚红
  static readonly DANGER_SOFT: string = '#FDEAE9'
  static readonly TAG_WORK: string = '#E3F2FD' // 冰蓝底色
  static readonly TAG_STUDY: string = '#F3E5F5' // 香芋底色
  static readonly TAG_LIFE: string = '#FFF3E0' // 芝士黄底色
}

export class UiCopywriting {
  static readonly DESIGN_TITLE: string = '灵感笔记'
  static readonly DESIGN_SUBTITLE: string = '记录标题、正文、图片与待办状态，首页会自动读取数据库里的真实笔记。'
  static readonly NOTE_PREVIEW_TITLE: string = '用一张卡片承载灵感和任务'
  static readonly NOTE_PREVIEW_BODY: string = '支持标题、正文摘要、标签、图片预览和待办状态，让首页列表更统一、更易读。'
}
