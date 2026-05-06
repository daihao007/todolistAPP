import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { CommonConstants, TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { DateUtil } from '../utils/DateUtil'
import common from '@ohos.app.ability.common'

class DateRangeFilter {
  startDate: string
  endDate: string
  message: string

  constructor(startDate: string, endDate: string, message: string) {
    this.startDate = startDate
    this.endDate = endDate
    this.message = message
  }
}

@Entry
@Component
export struct SearchResultPage {
  // 搜索条件状态
  @State keyword: string = ''
  @State startDate: string = ''
  @State endDate: string = ''
  @State customTagKeyword: string = ''
  @State selectedTags: string[] = []
  @State filterTags: string[] = ['全部'].concat(CommonConstants.DEFAULT_TAGS)
  @State dateHelperText: string = '日期支持 2026-05-06、2026/5/6、20260506、5月6日、今天、昨天。'

  // 数据库查询结果
  @State filteredNotes: Note[] = []

  // 初始化数据库管理器
  private db: RdbStoreManager = RdbStoreManager.getInstance(getContext(this) as common.Context)

  // 页面进入时初始化并首查
  async aboutToAppear() {
    await this.db.initDb()
    await this.handleSearch()
  }

  /**
   * 核心业务逻辑：组合关键词搜索与日期过滤
   */
  async handleSearch() {
    // 1. 从数据库获取模糊匹配关键词的结果 (这里内部查询的是 TABLE_NOTES)
    let dbResults = await this.db.searchNotes(this.keyword)
    const dateRange = this.buildDateRangeFilter()
    const tagKeywords = this.getActiveTagKeywords()
    this.dateHelperText = dateRange.message.length > 0 ?
      dateRange.message :
      '日期支持 2026-05-06、2026/5/6、20260506、5月6日、今天、昨天。'

    // 2. 在内存中进一步组合日期范围和标签过滤
    this.filteredNotes = dbResults.filter((note: Note) => {
      const noteDate = DateUtil.formatDate(note.createTime)
      const tags = note.tags ? note.tags.split(',') : []
      const matchedDate = (dateRange.startDate.length === 0 || noteDate >= dateRange.startDate) &&
        (dateRange.endDate.length === 0 || noteDate <= dateRange.endDate)
      const matchedTag = tagKeywords.length === 0 || tags.some((tag: string) => tagKeywords.indexOf(tag) >= 0)
      return matchedDate && matchedTag
    })
  }

  private async toggleTagFilter(tag: string): Promise<void> {
    if (tag === '全部') {
      this.selectedTags = []
      await this.handleSearch()
      return
    }
    if (this.selectedTags.indexOf(tag) >= 0) {
      this.selectedTags = this.selectedTags.filter((item: string) => item !== tag)
    } else {
      this.selectedTags = [...this.selectedTags, tag]
    }
    await this.handleSearch()
  }

  private isTagSelected(tag: string): boolean {
    return tag === '全部' ? this.selectedTags.length === 0 : this.selectedTags.indexOf(tag) >= 0
  }

  private getActiveTagKeywords(): string[] {
    const result: string[] = []
    this.selectedTags.forEach((tag: string) => this.appendTagKeyword(result, tag))
    this.customTagKeyword
      .split(',')
      .join(' ')
      .split('，')
      .join(' ')
      .split(' ')
      .forEach((tag: string) => this.appendTagKeyword(result, tag))
    return result
  }

  private appendTagKeyword(tags: string[], label: string): void {
    const tag = label.trim()
    if (tag.length > 0 && tags.indexOf(tag) < 0) {
      tags.push(tag)
    }
  }

  private buildDateRangeFilter(): DateRangeFilter {
    const startResult = this.normalizeDateInput(this.startDate)
    const endResult = this.normalizeDateInput(this.endDate)
    let message = ''
    if (this.startDate.trim().length > 0 && startResult.length === 0) {
      message = '开始日期格式未识别，已忽略。'
    }
    if (this.endDate.trim().length > 0 && endResult.length === 0) {
      message = message.length > 0 ? `${message} 结束日期格式未识别，已忽略。` : '结束日期格式未识别，已忽略。'
    }
    if (startResult.length > 0 && endResult.length > 0 && startResult > endResult) {
      return new DateRangeFilter(endResult, startResult, '开始日期晚于结束日期，已自动交换范围。')
    }
    return new DateRangeFilter(startResult, endResult, message)
  }

  private normalizeDateInput(value: string): string {
    const rawValue = value.trim()
    if (rawValue.length === 0) {
      return ''
    }

    const lowerValue = rawValue.toLowerCase()
    if (lowerValue === 'today' || rawValue === '今天') {
      return DateUtil.formatDate(Date.now())
    }
    if (lowerValue === 'yesterday' || rawValue === '昨天') {
      return DateUtil.formatDate(Date.now() - 86400000)
    }
    if (rawValue === '前天') {
      return DateUtil.formatDate(Date.now() - 172800000)
    }

    const compactValue = rawValue.split(' ').join('')
    if (/^\d{8}$/.test(compactValue)) {
      return this.normalizeDateParts(
        Number(compactValue.substring(0, 4)),
        Number(compactValue.substring(4, 6)),
        Number(compactValue.substring(6, 8))
      )
    }

    const normalizedValue = rawValue
      .split('年').join('-')
      .split('月').join('-')
      .split('日').join('')
      .split('/').join('-')
      .split('.').join('-')
      .split(' ').join('-')
    const segments = normalizedValue
      .split('-')
      .filter((segment: string) => segment.trim().length > 0)

    if (segments.length === 3) {
      const first = Number(segments[0])
      const second = Number(segments[1])
      const third = Number(segments[2])
      if (segments[0].length === 4) {
        return this.normalizeDateParts(first, second, third)
      }
      if (segments[2].length === 4) {
        return this.normalizeDateParts(third, first, second)
      }
    }

    if (segments.length === 2) {
      const currentYear = new Date().getFullYear()
      return this.normalizeDateParts(currentYear, Number(segments[0]), Number(segments[1]))
    }
    return ''
  }

  private normalizeDateParts(year: number, month: number, day: number): string {
    if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) {
      return ''
    }
    if (year < 1900 || month < 1 || month > 12 || day < 1 || day > 31) {
      return ''
    }
    const date = new Date(year, month - 1, day)
    if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) {
      return ''
    }
    return DateUtil.formatDate(date.getTime())
  }

  private setTodayRange(): void {
    const today = DateUtil.formatDate(Date.now())
    this.startDate = today
    this.endDate = today
    void this.handleSearch()
  }

  private setRecentDaysRange(days: number): void {
    const now = Date.now()
    this.startDate = DateUtil.formatDate(now - (days - 1) * 86400000)
    this.endDate = DateUtil.formatDate(now)
    void this.handleSearch()
  }

  private clearFilters(): void {
    this.keyword = ''
    this.startDate = ''
    this.endDate = ''
    this.customTagKeyword = ''
    this.selectedTags = []
    void this.handleSearch()
  }

  /**
   * C 同学追加逻辑：更新笔记勾选状态并同步数据库
   * @param noteId 笔记ID
   * @param isDone 是否勾选
   */
  async handleToggleStatus(noteId: string, isDone: boolean) {
    await this.db.updateNoteCompleteStatus(noteId, isDone)
    await this.handleSearch()
  }

  async handleStatusChange(noteId: string, status: TodoVisualStatus) {
    await this.db.updateNoteTodoStatus(noteId, status)
    await this.handleSearch()
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        // 头部标题区
        Column({ space: 6 }) {
          Text('搜索结果')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('可按关键字、日期范围和标签筛选，待办三态会实时同步至 RDB。')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        // 搜索筛选控制区
        Column({ space: 12 }) {
          Stack({ alignContent: Alignment.End }) {
            TextInput({ placeholder: '输入关键字搜索...', text: this.keyword })
              .width('100%')
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding({ left: 14, right: 40 })
              .onChange((value: string) => {
                this.keyword = value
                void this.handleSearch()
              })

            if (this.keyword.length > 0) {
              Image($r('app.media.ic_clear'))
                .width(20)
                .height(20)
                .margin({ right: 12 })
                .fillColor(UiPalette.TEXT_SECONDARY)
                .onClick(() => {
                  this.keyword = ''
                  void this.handleSearch()
                })
            }
          }

          Row({ space: 10 }) {
            TextInput({ placeholder: '开始日期：2026-05-06 / 5月6日 / 今天', text: this.startDate })
              .layoutWeight(1)
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .onChange((value: string) => {
                this.startDate = value
                void this.handleSearch()
              })

            TextInput({ placeholder: '结束日期：20260506 / 2026.5.6 / 昨天', text: this.endDate })
              .layoutWeight(1)
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .onChange((value: string) => {
                this.endDate = value
                void this.handleSearch()
              })
          }

          Text(this.dateHelperText)
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(UiPalette.TEXT_MUTED)

          Row({ space: 8 }) {
            Button('今天')
              .layoutWeight(1)
              .height(36)
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_PRIMARY)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.BUTTON_RADIUS)
              .onClick(() => {
                this.setTodayRange()
              })

            Button('近7天')
              .layoutWeight(1)
              .height(36)
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_PRIMARY)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.BUTTON_RADIUS)
              .onClick(() => {
                this.setRecentDaysRange(7)
              })

            Button('清空筛选')
              .layoutWeight(1)
              .height(36)
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(Color.White)
              .backgroundColor(UiPalette.PRIMARY)
              .borderRadius(UiConstants.BUTTON_RADIUS)
              .onClick(() => {
                this.clearFilters()
              })
          }
          .width('100%')

          Text('默认标签可多选')
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(UiPalette.TEXT_MUTED)

          Scroll() {
            Row({ space: 8 }) {
              ForEach(this.filterTags, (tag: string) => {
                Row() {
                  TagChip({
                    label: tag,
                    selected: this.isTagSelected(tag),
                    fillColor: UiPalette.SURFACE_MUTED,
                    textColor: tag === '全部' ? UiPalette.PRIMARY : UiPalette.TEXT_PRIMARY
                  })
                }
                .onClick(() => {
                  void this.toggleTagFilter(tag)
                })
              }, (tag: string) => tag)
            }
          }
          .width('100%')
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)

          TextInput({ placeholder: '输入自定义标签搜索，多个用空格或逗号分隔', text: this.customTagKeyword })
            .width('100%')
            .height(44)
            .fontSize(UiConstants.BODY_SIZE)
            .backgroundColor(UiPalette.SURFACE_MUTED)
            .borderRadius(14)
            .padding({ left: 14, right: 14 })
            .onChange((value: string) => {
              this.customTagKeyword = value
              void this.handleSearch()
            })

          Text(`${this.filteredNotes.length} 条结果`)
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(UiPalette.SUCCESS)
        }
        .padding(16)
        .width('100%')
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        // 结果展示区
        if (this.filteredNotes.length === 0) {
          Column({ space: 8 }) {
            Text('未找到匹配笔记').fontSize(UiConstants.SUBTITLE_SIZE).fontWeight(FontWeight.Medium)
            Text('尝试调整筛选条件').fontSize(UiConstants.BODY_SIZE).fontColor(UiPalette.TEXT_SECONDARY)
          }
          .padding(40).width('100%').backgroundColor(UiPalette.SURFACE).borderRadius(UiConstants.CARD_RADIUS).alignItems(HorizontalAlign.Center)
        } else {
          Column({ space: 12 }) {
            ForEach(this.filteredNotes, (note: Note) => {
              NoteCard({
                title: note.title,
                content: note.content,
                dateText: DateUtil.formatDate(note.createTime),
                tags: note.tags ? note.tags.split(',') : [],
                todoStatus: note.todoStatus,
                imagePath: note.imagePath,
                // 这里是核心：将勾选动作回调给 handleToggleStatus
                onCheckboxChange: (isDone: boolean) => {
                  void this.handleToggleStatus(note.id, isDone)
                },
                onTodoStatusChange: (status: TodoVisualStatus) => {
                  void this.handleStatusChange(note.id, status)
                }
              })
            }, (note: Note) => note.id + "_" + note.todoStatus)
          }
          .width('100%')
        }
      }
      .padding(UiConstants.PAGE_PADDING)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(UiPalette.PAGE_BACKGROUND)
  }
}
