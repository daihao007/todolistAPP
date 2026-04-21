import common from '@ohos.app.ability.common'
import { TodoVisualStatus } from '../common/Constants'
import { NoteService } from '../service/NoteService'
import { DateUtil } from '../utils/DateUtil'

export class NoteCardViewData {
  id: string
  title: string
  content: string
  dateText: string
  imagePath: string
  tags: string[]
  todoStatus: TodoVisualStatus

  constructor(id: string, title: string, content: string, dateText: string, imagePath: string, tags: string[],
    todoStatus: TodoVisualStatus) {
    this.id = id
    this.title = title
    this.content = content
    this.dateText = dateText
    this.imagePath = imagePath
    this.tags = tags
    this.todoStatus = todoStatus
  }
}

export class NoteViewModel {
  private readonly noteService: NoteService

  constructor(context: common.Context) {
    this.noteService = new NoteService(context)
  }

  async loadNotes(): Promise<NoteCardViewData[]> {
    const notes = await this.noteService.getAllNotes()
    return notes.map((note) => {
      return new NoteCardViewData(
        note.id,
        note.title,
        note.content,
        DateUtil.formatDate(note.createTime),
        note.imagePath,
        this.noteService.parseTags(note.tags),
        this.noteService.normalizeTodoStatus(note.todoStatus)
      )
    })
  }
}
