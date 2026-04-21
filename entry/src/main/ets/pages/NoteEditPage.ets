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
export struct NoteEditPage {
  @State titleText: string = ''
  @State contentText: string = ''
  @State imagePath: string = ''
  @State selectedTags: string[] = []
  @State todoStatus: TodoVisualStatus = TodoVisualStatus.PENDING
  @State helperText: string = ''
  @State showError: boolean = false
  @State loading: boolean = true
  @State saving: boolean = false
  @State pageTitle: string = '新建笔记'
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
      this.pageTitle = '新建笔记'
      this.createTime = Date.now()
      this.contentText = '在这里记录灵感、课程安排或待办事项，保存后首页会自动刷新。'
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
      const note = await noteService.getNoteDetail(this.noteId)
      if (note === null) {
        this.showError = true
        this.helperText = '未找到要编辑的笔记。'
      } else {
        this.titleText = note.title
        this.contentText = note.content
        this.imagePath = note.imagePath
        this.selectedTags = noteService.parseTags(note.tags)
        this.todoStatus = noteService.normalizeTodoStatus(note.todoStatus)
        this.createTime = note.createTime
        this.helperText = ''
        this.showError = false
      }
    } catch (error) {
      this.showError = true
      this.helperText = '加载笔记失败，请稍后再试。'
      Logger.error('NoteEditPage', `Failed to load note detail: ${JSON.stringify(error)}`)
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
      tags: this.selectedTags,
      todoStatus: this.todoStatus
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
      this.helperText = '选择图片失败，请稍后再试。'
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
      Logger.error('NoteEditPage', `Failed to save note: ${JSON.stringify(error)}`)
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

            TextInput({ placeholder: '输入笔记标题', text: this.titleText })
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

            TextArea({ placeholder: '输入正文内容', text: this.contentText })
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
              Text('暂未选择图片，支持直接保存纯文本笔记。')
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

          Button(this.saving ? '正在保存...' : '保存笔记')
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
              content: this.contentText.trim().length > 0 ? this.contentText : '正文为空时，这里会展示空白内容。',
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
