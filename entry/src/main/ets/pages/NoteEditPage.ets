import { NoteCard } from '../components/NoteCard'
import { TagChip } from '../components/TagChip'
import { TodoStatusSwitch } from '../components/TodoStatusSwitch'
import { TodoVisualStatus, UiConstants, UiPalette } from '../common/Constants'

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
  @State titleText: string = ''
  @State contentText: string =
    '\u5728\u8FD9\u91CC\u8BB0\u5F55\u7075\u611F\u3001\u8BFE\u7A0B\u5B89\u6392\u6216\u5F85\u529E\u4E8B\u9879\uFF0C\u957F\u6587\u5185\u5BB9\u53EF\u4EE5\u76F4\u63A5\u6EDA\u52A8\u7F16\u8F91\u3002'
  @State imagePath: string = ''
  @State selectedTags: string[] = ['\u5B66\u4E60']
  @State todoStatus: TodoVisualStatus = TodoVisualStatus.PENDING
  @State helperText: string = '\u6807\u9898\u4E0D\u80FD\u4E3A\u7A7A'
  @State showError: boolean = false
  private readonly tagOptions: TagOption[] = [
    new TagOption('\u5DE5\u4F5C', UiPalette.TAG_WORK),
    new TagOption('\u5B66\u4E60', UiPalette.TAG_STUDY),
    new TagOption('\u751F\u6D3B', UiPalette.TAG_LIFE)
  ]

  private toggleTag(label: string): void {
    const exists: boolean = this.selectedTags.indexOf(label) >= 0
    if (exists) {
      this.selectedTags = this.selectedTags.filter((item: string) => item !== label)
      return
    }
    this.selectedTags = [...this.selectedTags, label]
  }

  private saveNote(): void {
    if (this.titleText.trim().length === 0) {
      this.showError = true
      this.helperText = '\u6807\u9898\u4E3A\u7A7A\u65F6\u4E0D\u5141\u8BB8\u4FDD\u5B58'
      return
    }
    this.showError = false
    this.helperText = '\u7EC4\u4EF6\u63A5\u5165\u5B8C\u6210\uFF0C\u540E\u7EED\u53EF\u4EE5\u5728 service/ \u91CC\u63A5\u5165\u771F\u5B9E\u4FDD\u5B58\u903B\u8F91'
  }

  build() {
    Scroll() {
      Column({ space: UiConstants.SECTION_SPACING }) {
        Column({ space: 6 }) {
          Text('\u7F16\u8F91\u7B14\u8BB0')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(UiPalette.TEXT_PRIMARY)

          Text('\u7EC4\u4EF6\u5DF2\u63A5\u5165\u7F16\u8F91\u9875\uFF0C\u652F\u6301\u6807\u9898\u3001\u6B63\u6587\u3001\u56FE\u7247\u8DEF\u5F84\u3001\u6807\u7B7E\u548C\u5F85\u529E\u72B6\u6001\u3002')
            .fontSize(UiConstants.BODY_SIZE)
            .fontColor(UiPalette.TEXT_SECONDARY)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Column({ space: 10 }) {
          Text('\u6807\u9898')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          TextInput({ placeholder: '\u8F93\u5165\u7B14\u8BB0\u6807\u9898', text: this.titleText })
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
          Text('\u6B63\u6587\u5185\u5BB9')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          TextArea({ placeholder: '\u8F93\u5165\u6B63\u6587\u5185\u5BB9', text: this.contentText })
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
          Text('\u672C\u5730\u56FE\u7247')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          TextInput({ placeholder: '\u4F8B\u5982 /storage/media/100/local/note.png', text: this.imagePath })
            .width('100%')
            .height(52)
            .fontSize(UiConstants.BODY_SIZE)
            .backgroundColor(UiPalette.SURFACE_MUTED)
            .borderRadius(14)
            .padding({ left: 14, right: 14 })
            .onChange((value: string) => {
              this.imagePath = value
            })

          Text('\u8FD9\u91CC\u5148\u7559\u597D\u672C\u5730\u56FE\u7247\u8DEF\u5F84\u63A5\u53E3\uFF0C\u540E\u9762\u53EF\u4EE5\u7531 B \u540C\u5B66\u63A5\u5165\u9009\u56FE\u5668\u3002')
            .fontSize(UiConstants.CAPTION_SIZE)
            .fontColor(UiPalette.TEXT_MUTED)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(16)
        .backgroundColor(UiPalette.SURFACE)
        .borderRadius(UiConstants.CARD_RADIUS)

        Column({ space: 10 }) {
          Text('\u6807\u7B7E\u9009\u62E9')
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
          Text('\u5F85\u529E\u72B6\u6001')
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

        Button('\u4FDD\u5B58\u7B14\u8BB0')
          .width('100%')
          .height(52)
          .fontSize(UiConstants.BODY_SIZE)
          .fontColor(Color.White)
          .backgroundColor(UiPalette.PRIMARY)
          .borderRadius(UiConstants.BUTTON_RADIUS)
          .onClick(() => {
            this.saveNote()
          })

        Text(this.helperText)
          .fontSize(UiConstants.CAPTION_SIZE)
          .fontColor(this.showError ? UiPalette.DANGER : UiPalette.ACCENT)

        Column({ space: 10 }) {
          Text('\u5361\u7247\u9884\u89C8')
            .fontSize(UiConstants.SUBTITLE_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor(UiPalette.TEXT_PRIMARY)

          NoteCard({
            title: this.titleText.trim().length > 0 ? this.titleText : '\u5C1A\u672A\u586B\u5199\u6807\u9898',
            content: this.contentText,
            dateText: '2026-04-21',
            imagePath: this.imagePath,
            tags: this.selectedTags,
            todoStatus: this.todoStatus
          })
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
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
