import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import common from '@ohos.app.ability.common'
import { Breakpoint, CommonConstants, ResponsiveConstants, TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'
import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { ImageService } from '../service/ImageService'
import { NoteEditorInput, NoteService } from '../service/NoteService'
import { BreakpointUtil } from '../utils/BreakpointUtil'
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

@Component
export struct NoteEditPage {
  @StorageProp('currentBreakpoint') currentBreakpoint: Breakpoint = Breakpoint.SM
  @Prop isEmbedded: boolean = false
  @Prop @Watch('onNoteIdChanged') noteId: string = ''
  onSaved: (noteId: string) => void = () => {}
  onDeleted: (noteId: string) => void = () => {}
  onDraftChange: (title: string, content: string, imagePath: string, tags: string[]) => void =
    () => {}
  @State titleText: string = ''
  @State contentText: string = ''
  @State imagePath: string = ''
  @State selectedTags: string[] = []
  @State aiSelectedTags: string[] = []
  @State aiTagsText: string = ''
  @State aiKeywordsText: string = ''
  @State aiSummary: string = ''
  @State aiActionItems: string = ''
  @State aiLoading: boolean = false
  @State shouldSaveGeneratedTodo: boolean = false
  @State todoStatus: TodoVisualStatus = TodoVisualStatus.NONE
  @State helperText: string = ''
  @State showError: boolean = false
  @State loading: boolean = true
  @State saving: boolean = false
  @State pageTitle: string = '新建笔记'
  @State tagInputText: string = ''
  @State tagHelperText: string = ''
  @State currentNoteId: string = ''
  @State tagOptions: TagOption[] = [
    new TagOption('工作', UiPalette.TAG_WORK),
    new TagOption('学习', UiPalette.TAG_STUDY),
    new TagOption('生活', UiPalette.TAG_LIFE)
  ]
  private createTime: number = Date.now()
  private noteService: NoteService | null = null
  private imageService: ImageService | null = null

  aboutToAppear(): void {
    this.ensureServices()
    void this.loadInitialState()
  }

  private onNoteIdChanged(): void {
    if (this.isEmbedded) {
      void this.loadInitialState()
    }
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
    this.shouldSaveGeneratedTodo = false
    this.resetEditorState()
    this.currentNoteId = this.resolveNoteId()
    if (this.currentNoteId.length === 0) {
      this.pageTitle = '新建笔记'
      this.createTime = Date.now()
      this.contentText = ''
      this.selectedTags = ['学习']
      this.helperText = ''
      this.loading = false
      return
    }

    this.pageTitle = '编辑笔记'
    const noteService = this.noteService
    if (noteService === null) {
      this.showError = true
      this.helperText = '笔记服务初始化失败。'
      this.loading = false
      return
    }

    try {
      const note = await noteService.getNoteDetail(this.currentNoteId)
      if (note === null) {
        this.showError = true
        this.helperText = '未找到要编辑的笔记。'
      } else {
        this.titleText = note.title
        this.contentText = note.content
        this.imagePath = note.imagePath
        this.selectedTags = noteService.parseTags(note.tags)
        this.aiSelectedTags = noteService.parseTags(note.aiTags || '')
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
      this.helperText = '加载笔记失败，请稍后重试。'
      Logger.error('NoteEditPage', `Failed to load note detail: ${JSON.stringify(error)}`)
    } finally {
      this.loading = false
    }
  }

  private resetEditorState(): void {
    this.titleText = ''
    this.contentText = ''
    this.imagePath = ''
    this.selectedTags = []
    this.aiSelectedTags = []
    this.aiTagsText = ''
    this.aiKeywordsText = ''
    this.aiSummary = ''
    this.aiActionItems = ''
    this.todoStatus = TodoVisualStatus.NONE
    this.helperText = ''
    this.showError = false
    this.tagInputText = ''
    this.tagHelperText = ''
  }

  private resolveNoteId(): string {
    if (this.isEmbedded) {
      return this.noteId
    }
    const params = router.getParams() as Record<string, string | number> | undefined
    if (params === undefined) {
      return ''
    }
    const noteId = params.noteId
    if (typeof noteId === 'string') {
      return noteId
    }
    return typeof noteId === 'number' ? noteId.toString() : ''
  }

  private notifyDraftChange(): void {
    if (this.isEmbedded) {
      this.onDraftChange(this.titleText, this.contentText, this.imagePath, this.selectedTags)
    }
  }

  private toggleTag(label: string): void {
    const exists = this.selectedTags.indexOf(label) >= 0
    if (exists) {
      this.selectedTags = this.selectedTags.filter((item: string) => item !== label)
      this.removeAiTagSelection(label)
      this.notifyDraftChange()
      return
    }
    this.selectedTags = [...this.selectedTags, label]
    this.notifyDraftChange()
  }

  private addCustomTag(): void {
    const label = this.tagInputText.trim().split(',').join('').split('，').join('')
    if (label.length === 0) {
      this.tagHelperText = '请输入标签名称。'
      return
    }

    if (this.selectedTags.indexOf(label) < 0) {
      this.selectedTags = [...this.selectedTags, label]
    }
    this.tagInputText = ''
    this.tagHelperText = '已添加到当前笔记的自定义标签。'
    this.notifyDraftChange()
  }

  private removeTag(label: string): void {
    this.selectedTags = this.selectedTags.filter((tag: string) => tag !== label)
    this.removeAiTagSelection(label)
    this.notifyDraftChange()
  }

  private getCustomSelectedTags(): string[] {
    return this.selectedTags.filter((tag: string) => CommonConstants.DEFAULT_TAGS.indexOf(tag) < 0)
  }

  private getTagColor(label: string): string {
    switch (label) {
      case '工作':
        return UiPalette.TAG_WORK
      case '学习':
        return UiPalette.TAG_STUDY
      case '生活':
        return UiPalette.TAG_LIFE
      default:
        return UiPalette.SURFACE_MUTED
    }
  }

  private buildEditorInput(): NoteEditorInput {
    return {
      title: this.titleText,
      content: this.contentText,
      imagePath: this.imagePath,
      tags: this.selectedTags,
      aiTags: this.aiSelectedTags,
      todoStatus: TodoVisualStatus.NONE,
      summary: this.aiSummary,
      actionItems: this.aiActionItems,
      priority: this.aiKeywordsText.length > 0 ? 1 : 0
    }
  }

  private buildGeneratedTodoInputs(): NoteEditorInput[] {
    const actionLines = this.getGeneratedTodoLines()
    if (actionLines.length === 0) {
      return []
    }

    return actionLines.map((action: string): NoteEditorInput => {
      let input: NoteEditorInput = {
        title: action,
        content: action,
        imagePath: '',
        tags: this.selectedTags,
        aiTags: this.aiSelectedTags,
        todoStatus: TodoVisualStatus.PENDING,
        summary: this.aiSummary,
        actionItems: action,
        priority: this.aiKeywordsText.length > 0 ? 1 : 0
      }
      return input
    })
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

  private applyAiTagSelection(nextAiTags: string[]): void {
    const manualTags = this.selectedTags.filter((tag: string) => this.aiSelectedTags.indexOf(tag) < 0)
    this.aiSelectedTags = nextAiTags
    this.aiTagsText = nextAiTags.join(', ')
    this.selectedTags = [...manualTags]
    nextAiTags.forEach((tag: string) => {
      if (this.selectedTags.indexOf(tag) < 0) {
        this.selectedTags = [...this.selectedTags, tag]
      }
    })
    this.notifyDraftChange()
  }

  private removeAiTagSelection(label: string): void {
    if (this.aiSelectedTags.indexOf(label) < 0) {
      return
    }
    this.aiSelectedTags = this.aiSelectedTags.filter((tag: string) => tag !== label)
    this.aiTagsText = this.aiSelectedTags.join(', ')
  }

  private getGeneratedTodoLines(): string[] {
    return this.aiActionItems
      .split(/[；;。，,\n\r]/)
      .map((item: string) => item.trim())
      .filter((item: string) => item.length > 0)
  }

  private canGenerateTodo(): boolean {
    return this.getGeneratedTodoLines().length > 0
  }

  private getGeneratedTodoCount(): number {
    return this.getGeneratedTodoLines().length
  }

  private getGeneratedTodoButtonText(): string {
    if (this.shouldSaveGeneratedTodo) {
      return '取消保存待办事项'
    }
    if (this.getGeneratedTodoCount() === 0) {
      return '无可保存待办'
    }
    return `保存 ${this.getGeneratedTodoCount()} 条待办事项`
  }

  private toggleGeneratedTodo(): void {
    if (!this.shouldSaveGeneratedTodo && !this.canGenerateTodo()) {
      this.showError = true
      this.helperText = '请先生成或填写待办/行动项，再保存待办事项。'
      return
    }
    this.showError = false
    this.shouldSaveGeneratedTodo = !this.shouldSaveGeneratedTodo
    this.helperText = this.shouldSaveGeneratedTodo ?
      `当前会在保存笔记时同步创建 ${this.getGeneratedTodoCount()} 条待办事项。` : ''
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
      this.applyAiTagSelection(aiResult.suggestedTags)
      this.aiKeywordsText = aiResult.keywords.join(', ')
      this.aiSummary = aiResult.summary
      this.aiActionItems = aiResult.actionItems.join('；')
      this.shouldSaveGeneratedTodo = this.shouldSaveGeneratedTodo && this.getGeneratedTodoCount() > 0
      this.helperText = this.getGeneratedTodoCount() > 0 ?
        '本地 AI 推荐已生成，可以继续编辑后保存。' :
        '本地 AI 推荐已生成；未识别到明确待办事项。'
    } catch (error) {
      this.showError = true
      this.helperText = '本地 AI 生成失败，请检查内容后重试。'
      Logger.error('NoteEditPage', `Local AI failed: ${JSON.stringify(error)}`)
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
      this.aiKeywordsText = cloudResult.keywords.join(', ')
      this.aiActionItems = cloudResult.actionItems.join('；')
      this.shouldSaveGeneratedTodo = this.shouldSaveGeneratedTodo && this.getGeneratedTodoCount() > 0
      this.applyAiTagSelection(cloudResult.suggestedTags)
      this.helperText = '云端 AI 整理完成，可以编辑后保存。'
      promptAction.showToast({ message: '云端大模型调用成功！' })
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      this.showError = true
      this.helperText = `云端 AI 请求失败: ${errMsg}`
      Logger.error('NoteEditPage', `Cloud AI failed: ${errMsg}`)
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
        this.notifyDraftChange()
      }
    } catch (error) {
      this.showError = true
      this.helperText = '选择图片失败，请稍后重试。'
      Logger.error('NoteEditPage', `Failed to pick image: ${JSON.stringify(error)}`)
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
      this.helperText = '笔记服务初始化失败。'
      return
    }

    try {
      const editorInput = this.buildEditorInput()
      if (this.currentNoteId.length === 0) {
        const note = await noteService.createNote(editorInput)
        this.currentNoteId = note.id
        this.createTime = note.createTime
      } else {
        const note = await noteService.updateNote(this.currentNoteId, editorInput)
        this.createTime = note.createTime
      }
      if (this.shouldSaveGeneratedTodo) {
        const todoInputs = this.buildGeneratedTodoInputs()
        for (const input of todoInputs) {
          await noteService.createNote(input)
        }
      }
      if (this.isEmbedded) {
        this.onSaved(this.currentNoteId)
        promptAction.showToast({ message: '笔记已保存' })
      } else {
        router.replaceUrl({
          url: CommonConstants.PAGE_INDEX,
          params: {
            refreshAt: Date.now().toString()
          }
        })
      }
    } catch (error) {
      this.showError = true
      this.helperText = '保存失败，请稍后重试。'
      Logger.error('NoteEditPage', `Failed to save note: ${JSON.stringify(error)}`)
    } finally {
      this.saving = false
    }
  }

  private async deleteNote(): Promise<void> {
    if (this.currentNoteId.length === 0) {
      router.back()
      return
    }

    const noteService = this.noteService
    if (noteService === null) {
      this.showError = true
      this.helperText = '笔记服务初始化失败。'
      return
    }

    this.saving = true
    this.showError = false
    this.helperText = ''
    try {
      const deletedNoteId = this.currentNoteId
      await noteService.deleteNote(this.currentNoteId)
      if (this.isEmbedded) {
        this.onDeleted(deletedNoteId)
        promptAction.showToast({ message: '笔记已删除' })
      } else {
        router.replaceUrl({
          url: CommonConstants.PAGE_INDEX,
          params: {
            refreshAt: Date.now().toString()
          }
        })
      }
    } catch (error) {
      this.showError = true
      this.helperText = '删除失败，请稍后重试。'
      Logger.error('NoteEditPage', `Failed to delete note: ${JSON.stringify(error)}`)
    } finally {
      this.saving = false
    }
  }

  private getPreviewDate(): string {
    return DateUtil.formatDate(this.createTime)
  }

  private getPagePadding(): number {
    return BreakpointUtil.getPagePadding(this.currentBreakpoint)
  }

  private getContentMaxWidth(): number {
    return BreakpointUtil.isWide(this.currentBreakpoint) ? ResponsiveConstants.FORM_MAX_WIDTH : 9999
  }

  private getImageHeight(): number {
    return BreakpointUtil.getImageHeight(this.currentBreakpoint)
  }

  @Builder EditorContent() {
    Column({ space: UiConstants.SECTION_SPACING }) {
        Column({ space: 6 }) {
          Text(this.pageTitle)
            .fontSize(UiConstants.TITLE_SIZE)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('支持标题、正文、图片、标签。保存成功后会返回首页并自动刷新列表。')
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

            TextInput({ placeholder: '输入笔记标题', text: this.titleText })
              .width('100%')
              .height(UiConstants.CONTROL_HEIGHT)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.FIELD_RADIUS)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.titleText = value
                this.notifyDraftChange()
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
          .padding(UiConstants.CARD_PADDING)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('正文内容')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            TextArea({ placeholder: this.contentText.length > 0 ? '' : '在这里记录灵感、课程安排或待办事项，保存后首页会自动刷新。', text: this.contentText })
              .width('100%')
              .height(180)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.FIELD_RADIUS)
              .padding(UiConstants.FIELD_RADIUS)
              .onChange((value: string) => {
                this.contentText = value
                this.notifyDraftChange()
              })
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(UiConstants.CARD_PADDING)
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
                .height(UiConstants.COMPACT_CONTROL_HEIGHT)
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
                .height(UiConstants.COMPACT_CONTROL_HEIGHT)
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
              .height(UiConstants.COMPACT_CONTROL_HEIGHT)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.FIELD_RADIUS)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.aiTagsText = value
                this.applyAiTagSelection(this.parseCustomTags())
              })

            Text('AI 生成摘要')
              .fontSize(UiConstants.CAPTION_SIZE)
              .fontColor(UiPalette.TEXT_SECONDARY)

            TextArea({ placeholder: 'AI 会在这里生成摘要，支持编辑后保存', text: this.aiSummary })
              .width('100%')
              .height(120)
              .fontSize(UiConstants.BODY_SIZE)
              .backgroundColor(UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.FIELD_RADIUS)
              .padding(UiConstants.FIELD_RADIUS)
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
              .borderRadius(UiConstants.FIELD_RADIUS)
              .padding(UiConstants.FIELD_RADIUS)
              .onChange((value: string) => {
                this.aiActionItems = value
              })

            Button(this.getGeneratedTodoButtonText())
              .width('100%')
              .height(UiConstants.COMPACT_CONTROL_HEIGHT)
              .fontSize(UiConstants.BODY_SIZE)
              .fontColor(this.shouldSaveGeneratedTodo ? Color.White : UiPalette.TEXT_PRIMARY)
              .backgroundColor(this.shouldSaveGeneratedTodo ? UiPalette.SUCCESS : UiPalette.SURFACE_MUTED)
              .borderRadius(UiConstants.BUTTON_RADIUS)
              .onClick(() => {
                this.toggleGeneratedTodo()
              })
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(UiConstants.CARD_PADDING)
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
                .height(UiConstants.COMPACT_CONTROL_HEIGHT)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(Color.White)
                .backgroundColor(UiPalette.PRIMARY)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  void this.pickImage()
                })

              Button('清除图片')
                .layoutWeight(1)
                .height(UiConstants.COMPACT_CONTROL_HEIGHT)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(UiPalette.TEXT_PRIMARY)
                .backgroundColor(UiPalette.SURFACE_MUTED)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  this.imagePath = ''
                  this.notifyDraftChange()
                })
            }
            .width('100%')

            if (this.imagePath.length > 0) {
              Column({ space: 8 }) {
                Image(this.imagePath)
                  .width('100%')
                  .height(this.getImageHeight())
                  .borderRadius(UiConstants.MEDIA_RADIUS)
                  .objectFit(ImageFit.Cover)

                Text(this.imagePath)
                  .fontSize(UiConstants.CAPTION_SIZE)
                  .fontColor(UiPalette.TEXT_MUTED)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('100%')
            } else {
              Text('暂未选择图片，支持直接保存纯文本笔记。')
                .fontSize(UiConstants.CAPTION_SIZE)
                .fontColor(UiPalette.TEXT_MUTED)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(UiConstants.CARD_PADDING)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Column({ space: 10 }) {
            Text('标签选择')
              .fontSize(UiConstants.SUBTITLE_SIZE)
              .fontWeight(FontWeight.Medium)
              .fontColor(UiPalette.TEXT_PRIMARY)

            Scroll() {
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
            .width('100%')
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)

            Row({ space: 10 }) {
              TextInput({ placeholder: '当前笔记的自定义标签，如：项目A', text: this.tagInputText })
                .layoutWeight(1)
                .height(UiConstants.COMPACT_CONTROL_HEIGHT)
                .fontSize(UiConstants.BODY_SIZE)
                .backgroundColor(UiPalette.SURFACE_MUTED)
                .borderRadius(UiConstants.FIELD_RADIUS)
                .padding({ left: 12, right: 12 })
                .onChange((value: string) => {
                  this.tagInputText = value
                  this.tagHelperText = ''
                })

              Button('添加')
                .width(80)
                .height(UiConstants.COMPACT_CONTROL_HEIGHT)
                .fontSize(UiConstants.BODY_SIZE)
                .fontColor(Color.White)
                .backgroundColor(UiPalette.PRIMARY)
                .borderRadius(UiConstants.BUTTON_RADIUS)
                .onClick(() => {
                  this.addCustomTag()
                })
            }
            .width('100%')

            if (this.getCustomSelectedTags().length > 0) {
              Column({ space: 8 }) {
                Text('已选自定义标签')
                  .fontSize(UiConstants.CAPTION_SIZE)
                  .fontColor(UiPalette.TEXT_MUTED)

                Scroll() {
                  Row({ space: 8 }) {
                    ForEach(this.getCustomSelectedTags(), (tag: string) => {
                      Row() {
                        TagChip({
                          label: tag,
                          selected: true,
                          fillColor: UiPalette.SURFACE_MUTED,
                          textColor: UiPalette.PRIMARY
                        })
                      }
                      .onClick(() => {
                        this.removeTag(tag)
                      })
                    }, (tag: string) => tag)
                  }
                }
                .width('100%')
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }

            if (this.tagHelperText.length > 0) {
              Text(this.tagHelperText)
                .fontSize(UiConstants.CAPTION_SIZE)
                .fontColor(UiPalette.TEXT_SECONDARY)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(UiConstants.CARD_PADDING)
          .backgroundColor(UiPalette.SURFACE)
          .borderRadius(UiConstants.CARD_RADIUS)

          Button(this.saving ? '正在保存...' : '保存笔记')
            .width('100%')
            .height(UiConstants.CONTROL_HEIGHT)
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(Color.White)
            .backgroundColor(UiPalette.PRIMARY)
            .borderRadius(UiConstants.BUTTON_RADIUS)
            .onClick(() => {
              if (!this.saving) {
                void this.saveNote()
              }
            })

          if (this.currentNoteId.length > 0) {
            Button(this.saving ? '正在处理...' : '删除笔记')
              .width('100%')
              .height(UiConstants.CONTROL_HEIGHT)
              .fontSize(UiConstants.BODY_SIZE)
              .fontColor(Color.White)
              .backgroundColor(UiPalette.DANGER)
              .borderRadius(UiConstants.BUTTON_RADIUS)
              .onClick(() => {
                if (!this.saving) {
                  void this.deleteNote()
                }
              })
          }

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
              todoStatus: TodoVisualStatus.NONE
            })

            if (this.shouldSaveGeneratedTodo) {
              Text(`待办事项预览（${this.getGeneratedTodoCount()} 条）`)
                .fontSize(UiConstants.CAPTION_SIZE)
                .fontColor(UiPalette.TEXT_SECONDARY)

              ForEach(this.buildGeneratedTodoInputs(), (todoInput: NoteEditorInput) => {
                NoteCard({
                  title: todoInput.title,
                  content: todoInput.content,
                  dateText: this.getPreviewDate(),
                  imagePath: '',
                  tags: todoInput.tags,
                  todoStatus: TodoVisualStatus.PENDING
                })
              }, (todoInput: NoteEditorInput) => `${todoInput.title}-${todoInput.content}`)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
        }
    }
    .padding(this.getPagePadding())
    .width('100%')
    .constraintSize({ maxWidth: this.getContentMaxWidth() })
    .alignSelf(ItemAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    if (this.isEmbedded) {
      this.EditorContent()
    } else {
      Scroll() {
        this.EditorContent()
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .backgroundColor(UiPalette.PAGE_BACKGROUND)
      .onAreaChange((oldArea: Area, newArea: Area) => {
        BreakpointUtil.updateByWidth(newArea.width.toString())
      })
    }
  }
}

@Entry
@Component
struct NoteEditPageEntry {
  build() {
    Stack() {
      NoteEditPage()
    }
    .width('100%')
    .height('100%')
  }
}
