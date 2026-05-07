import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import { CommonConstants, TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'
import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { TodoStatusSwitch } from '../components/TodoStatusSwitch'
import { ImageService } from '../service/ImageService'
import { NoteEditorInput, NoteService } from '../service/NoteService'
import { DateUtil } from '../utils/DateUtil'
import { Logger } from '../utils/Logger'

class TagOption {
  label: string
  color: string

  constructor(label: string, color: string) {
    this.label = label
    this.color = color
  }
}

@Entry
@Component
export struct TodoDetailPage {
  @State titleText: string = ''
  @State contentText: string = ''
  @State imagePath: string = ''
  @State selectedTags: string[] = []
  @State aiTagsText: string = ''
  @State aiKeywordsText: string = ''
  @State aiSummary: string = ''
  @State aiActionItems: string = ''
  @State aiLoading: boolean = false
  @State todoStatus: TodoVisualStatus = TodoVisualStatus.PENDING
  @State helperText: string = ''
  @State showError: boolean = false
  @State loading: boolean = true
  @State saving: boolean = false
  @State pageTitle: string = '新建待办事项'
  private noteId: string = ''
  private createTime: number = Date.now()
  private noteService: NoteService | null = null
  private imageService: ImageService | null = null
  private readonly tagOptions: TagOption[] = [
    new TagOption('工作', UiPalette.TAG_WORK),
    new TagOption('学习', UiPalette.TAG_STUDY),
    new TagOption('生活', UiPalette.TAG_LIFE)
  ]

  aboutToAppear(): void {
    this.ensureServices()
    void this.loadInitialState()
  }

  private ensureServices(): void {
    if (this.noteService !== null && this.imageService !== null) {
      return
    }
    const context = getContext(this) as common.UIAbilityContext
    this.noteService = new NoteService(context)
    this.imageService = new ImageService(context)
  }

  private async loadInitialState(): Promise<void> {
    this.loading = true
    this.noteId = this.readRouteNoteId()
    if (this.noteId.length === 0) {
      this.pageTitle = '新建待办事项'
      this.createTime = Date.now()
      this.contentText = '在这里记录待办事项，保存后会自动刷新。'
      this.selectedTags = ['学习']
      this.helperText = ''
      this.loading = false
      return
    }

    this.pageTitle = '编辑'
    const noteService = this.noteService
    if (noteService === null) {
      this.showError = true
      this.helperText = '服务初始化失败。'
      this.loading = false
      return
    }
    try {
      const note = await noteService.getNoteDetail(this.noteId)
      if (note === null) {
        this.showError = true
        this.helperText = '未找到要编辑的待办事项。'
      } else {
        this.titleText = note.title
        this.contentText = note.content
        this.imagePath = note.imagePath
        this.selectedTags = noteService.parseTags(note.tags)
        this.aiTagsText = note.aiTags || ''
        this.aiSummary = note.summary || ''
        this.aiActionItems = note.actionItems || ''
        this.aiKeywordsText = ''
        this.todoStatus = noteService.normalizeTodoStatus(note.todoStatus)
        this.createTime = note.createTime
        this.helperText = ''
        this.showError = false
      }
    } catch (error) {
      this.showError = true
      this.helperText = '加载失败，请稍后重试。'
      Logger.error('TodoDetailPage', `Failed to load note detail: ${JSON.stringify(error)}`)
    } finally {
      this.loading = false
    }
  }

  private readRouteNoteId(): string {
    const params = router.getParams() as Record<string, string> | undefined
    if (params === undefined) {
      return ''
    }
    const noteId = params.noteId
    return typeof noteId === 'string' ? noteId : ''
  }

  private toggleTag(label: string): void {
    const exists = this.selectedTags.indexOf(label) >= 0
    if (exists) {
      this.selectedTags = this.selectedTags.filter((item: string) => item !== label)
      return
    }
    this.selectedTags = [...this.selectedTags, label]
  }

  private buildEditorInput(): NoteEditorInput {
    return {
      title: this.titleText,
      content: this.contentText,
      imagePath: this.imagePath,
      tags: [...this.selectedTags, ...this.parseCustomTags()],
      todoStatus: this.todoStatus,
      summary: this.aiSummary,
      actionItems: this.aiActionItems,
      priority: this.aiKeywordsText.length > 0 ? 1 : 0
    }
  }

  private parseCustomTags(): string[] {
    if (this.aiTagsText.trim().length === 0) {
      return []
    }
    return this.aiTagsText
      .split(',')
      .map((tag: string) => tag.trim())
      .filter((tag: string) => tag.length > 0)
  }

  private async applyLocalAi(): Promise<void> {
    this.aiLoading = true
    this.showError = false
    try {
      const noteService = this.noteService
      if (noteService === null) {
        throw new Error('笔记服务未初始化')
      }
      const aiResult = await noteService.generateLocalAiSuggestion(this.titleText, this.contentText)
      this.aiTagsText = aiResult.suggestedTags.join(', ')
      this.aiKeywordsText = aiResult.keywords.join(', ')
      this.aiSummary = aiResult.summary
      this.aiActionItems = aiResult.actionItems.join('；')
      this.todoStatus = aiResult.todoStatus
      this.selectedTags = [...aiResult.suggestedTags]
      this.helperText = '本地 AI 推荐已生成，可以继续编辑后保存。'
    } catch (error) {
      this.showError = true
      this.helperText = '本地 AI 生成失败，请检查内容后重试。'
      Logger.error('TodoDetailPage', `Local AI failed: ${JSON.stringify(error)}`)
    } finally {
      this.aiLoading = false
    }
  }

  private async applyCloudAi(): Promise<void> {
    this.aiLoading = true
    this.showError = false
    try {
      const noteService = this.noteService
      if (noteService === null) {
        throw new Error('笔记服务未初始化')
      }
      const cloudResult = await noteService.requestCloudAiReview(this.titleText, this.contentText)
      this.aiSummary = cloudResult.summary
      this.aiActionItems = cloudResult.actionItems.join('；')
      this.aiTagsText = cloudResult.suggestedTags.join(', ')
      this.helperText = '云端 AI 整理完成，可以编辑后保存。'
    } catch (error) {
      this.showError = true
      this.helperText = '云端 AI 请求失败，请稍后重试。'
      Logger.error('TodoDetailPage', `Cloud AI failed: ${JSON.stringify(error)}`)
    } finally {
      this.aiLoading = false
    }
  }

  private async pickImage(): Promise<void> {
    this.ensureServices()
    const imageService = this.imageService
    if (imageService === null) {
      this.showError = true
      this.helperText = '图片服务初始化失败。'
      return
    }
    try {
      const nextPath = await imageService.pickSingleImage()
      if (nextPath.length > 0) {
        this.imagePath = nextPath
      }
    } catch (error) {
      this.showError = true
      this.helperText = '选择图片失败，请稍后重试。'
      Logger.error('TodoDetailPage', `Failed to pick image: ${JSON.stringify(error)}`)
    }
  }

  private async saveNote(): Promise<void> {
    if (this.titleText.trim().length === 0) {
      this.showError = true
      this.helperText = '标题不能为空。'
      return
    }

    this.saving = true
    this.showError = false
    this.helperText = ''
    const noteService = this.noteService
    if (noteService === null) {
      this.saving = false
      this.showError = true
      this.helperText = '服务初始化失败。'
      return
    }

    try {
      const editorInput = this.buildEditorInput()
      if (this.noteId.length === 0) {
        const note = await noteService.createNote(editorInput)
        this.noteId = note.id
        this.createTime = note.createTime
      } else {
        const note = await noteService.updateNote(this.noteId, editorInput)
        this.createTime = note.createTime
      }
      router.replaceUrl({
        url: CommonConstants.PAGE_INDEX,
        params: {
          refreshAt: Date.now().toString()
        }
      })
    } catch (error) {
      this.showError = true
      this.helperText = '保存失败，请稍后重试。'
      Logger.error('TodoDetailPage', `Failed to save note: ${JSON.stringify(error)}`)
    } finally {
      this.saving = false
    }
  }

  private getPreviewDate(): string {
    return DateUtil.formatDate(this.createTime)
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        Column({ space: 6 }) {
          Text(this.pageTitle)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('支持标题、正文、图片、标签和待办状态。保存成功后会返回首页并自动刷新列表。')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
            .lineHeight(22)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        if (this.loading) {
          Text('正在加载...')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        } else {
          Column({ space: 10 }) {
            Text('标题')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            TextInput({ placeholder: '输入待办事项', text: this.titleText })
              .width('100%')
              .height(52)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.titleText = value
                if (value.trim().length > 0) {
                  this.showError = false
                  if (this.helperText === '标题不能为空。') {
                    this.helperText = ''
                  }
                }
              })

            if (this.showError) {
              Text(this.helperText)
                .fontSize(UiConstants.CAPTION_SIZE)
                .fontColor(UiPalette.DANGER)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(16)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('正文内容')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            TextArea({ placeholder: '输入备注', text: this.contentText })
              .width('100%')
              .height(180)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding(14)
              .onChange((value: string) => {
                this.contentText = value
              })
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(16)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('AI 智能整理')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            Row({ space: 12 }) {
              Button(this.aiLoading ? 'AI 处理中...' : '本地 AI 自动提取')
                .layoutWeight(1)
                .height(44)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(Color.White)
                .backgroundColor(UiPalette.PRIMARY)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  if (!this.aiLoading) {
                    void this.applyLocalAi()
                  }
                })

              Button('云端 AI 整理')
                .layoutWeight(1)
                .height(44)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(UiPalette.TEXT_PRIMARY)
                .backgroundColor(UiPalette.SURFACE_MUTED)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  if (!this.aiLoading) {
                    void this.applyCloudAi()
                  }
                })
            }
            .width('100%')

            if (this.aiKeywordsText.length > 0) {
              Text(`关键词：${this.aiKeywordsText}`)
                .fontSize(UiConstants.CAPTION_SIZE)
                .fontColor(UiPalette.TEXT_MUTED)
            }

            Text('AI 推荐标签（可编辑，逗号分隔）')
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_SECONDARY)

            TextInput({ placeholder: '例如：工作, 会议, 紧急', text: this.aiTagsText })
              .width('100%')
              .height(44)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.aiTagsText = value
              })

            Text('AI 生成摘要')
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_SECONDARY)

            TextArea({ placeholder: 'AI 会在这里生成摘要，支持编辑后保存', text: this.aiSummary })
              .width('100%')
              .height(120)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding(14)
              .onChange((value: string) => {
                this.aiSummary = value
              })

            Text('AI 生成待办/行动项')
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_SECONDARY)

            TextArea({ placeholder: 'AI 会在这里列出行动项，支持编辑后保存', text: this.aiActionItems })
              .width('100%')
              .height(120)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(14)
              .padding(14)
              .onChange((value: string) => {
                this.aiActionItems = value
              })
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(16)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('图片')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            Row({ space: 10 }) {
              Button('选择图片')
                .layoutWeight(1)
                .height(44)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(Color.White)
                .backgroundColor(UiPalette.PRIMARY)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  void this.pickImage()
                })

              Button('清除图片')
                .layoutWeight(1)
                .height(44)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(UiPalette.TEXT_PRIMARY)
                .backgroundColor(UiPalette.SURFACE_MUTED)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  this.imagePath = ''
                })
            }
            .width('100%')

            if (this.imagePath.length > 0) {
              Column({ space: 8 }) {
                Image(this.imagePath)
                  .width('100%')
                  .height(180)
                  .borderRadius(16)
                  .objectFit(ImageFit.Cover)

                Text(this.imagePath)
                  .fontSize(UiConstants.CAPTION_SIZE)
                  .fontColor(UiPalette.TEXT_MUTED)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('100%')
            } else {
              Text('暂未选择图片，支持直接保存纯文本待办。')
                .fontSize(UiConstants.CAPTION_SIZE)
                .fontColor(UiPalette.TEXT_MUTED)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(16)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('标签选择')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            Row({ space: 8 }) {
              ForEach(this.tagOptions, (tag: TagOption) => {
                Row() {
                  TagChip({
                    label: tag.label,
                    selected: this.selectedTags.indexOf(tag.label) >= 0,
                    fillColor: tag.color,
                    textColor: UiPalette.PRIMARY
                  })
                }
                .onClick(() => {
                  this.toggleTag(tag.label)
                })
              }, (tag: TagOption) => tag.label)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(16)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('待办状态')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            TodoStatusSwitch({ currentStatus: $todoStatus })
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(16)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Button(this.saving ? '正在保存...' : '保存待办')
            .width('100%')
            .height(52)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(Color.White)
            .backgroundColor(UiPalette.PRIMARY)
            .borderRadius(UiConstants.BUTTON_RADIUS)
            .onClick(() => {
              if (!this.saving) {
                void this.saveNote()
              }
            })

          if (!this.showError && this.helperText.length > 0) {
            Text(this.helperText)
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.ACCENT)
          }

          Column({ space: 10 }) {
            Text('卡片预览')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            NoteCard({
              title: this.titleText.trim().length > 0 ? this.titleText : '尚未填写标题',
              content: this.contentText.trim().length > 0 ? this.contentText : '正文为空时，这里会显示空白内容。',
              dateText: this.getPreviewDate(),
              imagePath: this.imagePath,
              tags: this.selectedTags,
              todoStatus: this.todoStatus
            })
          }
          .alignItems(HorizontalAlign.Start)
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
