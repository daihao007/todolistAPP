import common from '@ohos.app.ability.common'
import { CommonConstants, TodoVisualStatus } from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { Logger } from '../utils/Logger'
import { PreferenceUtil } from '../utils/PreferenceUtil'

export interface NoteEditorInput {
  title: string
  content: string
  imagePath: string
  tags: string[]
  todoStatus: TodoVisualStatus
}

export class NoteService {
  private readonly rdbStoreManager: RdbStoreManager
  private readonly context: common.Context

  constructor(context: common.Context) {
    this.context = context
    this.rdbStoreManager = RdbStoreManager.getInstance(context)
  }

  async getCurrentUser(): Promise<string> {
    return await PreferenceUtil.getString(this.context, 'CURRENT_USER', '')
  }

  async createNote(input: NoteEditorInput): Promise<Note> {
    const timestamp = Date.now()
    const currentUserId = await this.getCurrentUser()
    const note: Note = {
      id: this.generateNoteId(timestamp),
      userId: currentUserId,
      title: input.title.trim(),
      content: input.content.trim(),
      imagePath: input.imagePath,
      tags: this.tagsToText(input.tags),
      createTime: timestamp,
      isTodo: this.toIsTodo(input.todoStatus),
      todoStatus: input.todoStatus
    }
    await this.rdbStoreManager.insertNote(note)
    Logger.info('NoteService', `Created note ${note.id}`)
    return note
  }

  async updateNote(noteId: string, input: NoteEditorInput): Promise<Note> {
    const current = await this.rdbStoreManager.queryNoteById(noteId)
    if (current === null) {
      throw new Error(`Note ${noteId} does not exist`)
    }

    const currentUserId = await this.getCurrentUser()

    const nextNote: Note = {
      id: current.id,
      userId: currentUserId || current.userId,
      title: input.title.trim(),
      content: input.content.trim(),
      imagePath: input.imagePath,
      tags: this.tagsToText(input.tags),
      createTime: current.createTime,
      isTodo: this.toIsTodo(input.todoStatus),
      todoStatus: input.todoStatus
    }

    await this.rdbStoreManager.updateNote(nextNote)
    Logger.info('NoteService', `Updated note ${noteId}`)
    return nextNote
  }

  async getNoteDetail(noteId: string): Promise<Note | null> {
    return this.rdbStoreManager.queryNoteById(noteId)
  }

  async getAllNotes(): Promise<Note[]> {
    const currentUserId = await this.getCurrentUser()
    return this.rdbStoreManager.queryAllNotes(currentUserId)
  }

  parseTags(tagsText: string): string[] {
    if (tagsText.trim().length === 0) {
      return []
    }
    return tagsText
      .split(',')
      .map((tag: string) => tag.trim())
      .filter((tag: string) => tag.length > 0)
  }

  normalizeTodoStatus(value: string): TodoVisualStatus {
    switch (value) {
      case TodoVisualStatus.COMPLETED:
        return TodoVisualStatus.COMPLETED
      case TodoVisualStatus.DEFERRED:
        return TodoVisualStatus.DEFERRED
      case TodoVisualStatus.PENDING:
        return TodoVisualStatus.PENDING
      default:
        return TodoVisualStatus.NONE
    }
  }

  private tagsToText(tags: string[]): string {
    return tags
      .map((tag: string) => tag.trim())
      .filter((tag: string) => CommonConstants.DEFAULT_TAGS.indexOf(tag) >= 0)
      .join(',')
  }

  private toIsTodo(todoStatus: TodoVisualStatus): number {
    switch (todoStatus) {
      case TodoVisualStatus.PENDING:
        return 1
      case TodoVisualStatus.COMPLETED:
        return 0
      case TodoVisualStatus.DEFERRED:
        return 2
      case TodoVisualStatus.NONE:
      default:
        return -1
    }
  }

  private generateNoteId(timestamp: number): string {
    const randomSuffix = Math.floor(Math.random() * 1000).toString().padStart(3, '0')
    return `note-${timestamp}-${randomSuffix}`
  }
}
