import common from '@ohos.app.ability.common'
import { CommonConstants, TodoVisualStatus } from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { Logger } from '../utils/Logger'
import { PreferenceUtil } from '../utils/PreferenceUtil'
import { HttpUtil } from '../utils/HttpUtil'

export interface NoteEditorInput {
  title: string
  content: string
  imagePath: string
  tags: string[]
  todoStatus: TodoVisualStatus
  summary: string
  actionItems: string
  priority: number
}

export interface AiSuggestion {
  suggestedTags: string[]
  keywords: string[]
  summary: string
  actionItems: string[]
  todoStatus: TodoVisualStatus
  priority: number
}

export interface CloudAiResult {
  summary: string
  actionItems: string[]
  suggestedTags: string[]
}

interface CloudRequestPayload {
  title: string
  content: string
  input: string
  mode: string
}

interface CloudMessagePayload {
  content?: string
}

interface CloudChoicePayload {
  message?: CloudMessagePayload
}

interface CloudResponsePayload {
  summary?: string
  actionItems?: Array<string>
  suggestedTags?: Array<string>
  data?: CloudResponsePayload
  choices?: Array<CloudChoicePayload>
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
      aiTags: this.tagsToText(input.tags),
      summary: input.summary.trim(),
      actionItems: input.actionItems.trim(),
      priority: input.priority,
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
      aiTags: this.tagsToText(input.tags),
      summary: input.summary.trim(),
      actionItems: input.actionItems.trim(),
      priority: input.priority,
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

  async generateLocalAiSuggestion(title: string, content: string): Promise<AiSuggestion> {
    const trimmed = `${title.trim()} ${content.trim()}`.trim()
    const suggestedTags = this.extractTagsFromText(trimmed)
    const keywords = this.extractKeywords(trimmed)
    const todoStatus = this.inferTodoStatus(trimmed)
    const priority = this.inferPriority(trimmed)
    const summary = this.buildLocalSummary(trimmed)
    const actionItems = this.extractActionItems(trimmed)
    return {
      suggestedTags,
      keywords,
      summary,
      actionItems,
      todoStatus,
      priority
    }
  }

  async requestCloudAiReview(title: string, content: string): Promise<CloudAiResult> {
    const normalizedText = `${title.trim()} ${content.trim()}`.trim()
    if (normalizedText.length === 0) {
      return this.buildFallbackCloudResult(title, content)
    }

    const cloudUrl = CommonConstants.AI_CLOUD_API_URL.trim()
    if (cloudUrl.length === 0 || cloudUrl.indexOf('your-cloud-ai-endpoint.example.com') >= 0) {
      Logger.info('NoteService', 'Cloud AI endpoint is not configured, falling back to local AI')
      return this.buildFallbackCloudResult(title, content)
    }

    const payload: CloudRequestPayload = {
      title: title.trim(),
      content: content.trim(),
      input: normalizedText,
      mode: 'summarize'
    }

    let authorization: string | undefined = undefined
    if (CommonConstants.AI_CLOUD_API_KEY.trim().length > 0) {
      authorization = `Bearer ${CommonConstants.AI_CLOUD_API_KEY.trim()}`
    }

    try {
      const response = await HttpUtil.postJson(cloudUrl, payload, authorization)
      const parsed = this.parseCloudResponse(response)
      return {
        summary: parsed.summary,
        actionItems: parsed.actionItems,
        suggestedTags: parsed.suggestedTags
      }
    } catch (error) {
      Logger.error('NoteService', `Cloud AI request failed: ${JSON.stringify(error)}`)
      return this.buildFallbackCloudResult(title, content)
    }
  }

  private parseCloudResponse(response: string): CloudAiResult {
    const parsed = JSON.parse(response) as CloudResponsePayload
    const directSummary = this.pickString(parsed.summary)
    const directActions = this.pickStringList(parsed.actionItems)
    const directTags = this.pickStringList(parsed.suggestedTags)
    if (directSummary.length > 0 || directActions.length > 0 || directTags.length > 0) {
      return {
        summary: directSummary,
        actionItems: directActions,
        suggestedTags: directTags
      }
    }

    const dataBlock = parsed.data
    if (dataBlock !== undefined) {
      return {
        summary: this.pickString(dataBlock.summary),
        actionItems: this.pickStringList(dataBlock.actionItems),
        suggestedTags: this.pickStringList(dataBlock.suggestedTags)
      }
    }

    const choices = parsed.choices
    if (choices !== undefined && choices.length > 0) {
      const firstChoice = choices[0]
      const message = firstChoice.message
      const messageContent = message === undefined ? '' : this.pickString(message.content)
      if (messageContent.length > 0) {
        try {
          return this.parseCloudResponse(messageContent)
        } catch (_error) {
          return {
            summary: messageContent,
            actionItems: [],
            suggestedTags: []
          }
        }
      }
    }

    throw new Error('Unsupported cloud AI response format')
  }

  private pickString(value: string | undefined): string {
    if (typeof value === 'string') {
      return value.trim()
    }
    return ''
  }

  private pickStringList(value: Array<string> | undefined): string[] {
    if (value !== undefined) {
      const result: string[] = []
      value.forEach((item: string) => {
        const trimmed = item.trim()
        if (trimmed.length > 0) {
          result.push(trimmed)
        }
      })
      return result
    }
    return []
  }

  private buildFallbackCloudResult(title: string, content: string): CloudAiResult {
    const merged = `${title.trim()} ${content.trim()}`.trim()
    return {
      summary: this.buildLocalSummary(merged),
      actionItems: this.extractActionItems(merged),
      suggestedTags: this.extractTagsFromText(merged)
    }
  }

  private extractTagsFromText(text: string): string[] {
    const suggested: string[] = []
    const lower = text.toLowerCase()
    const tagCandidates = ['工作', '学习', '生活', '会议', '课程', '计划', '任务', '提醒', '调研']
    for (const tag of tagCandidates) {
      if (lower.indexOf(tag.toLowerCase()) >= 0 && suggested.indexOf(tag) < 0) {
        suggested.push(tag)
      }
    }
    if (suggested.length === 0) {
      const keywords = this.extractKeywords(text)
      for (const keyword of keywords) {
        if (suggested.length >= 3) {
          break
        }
        suggested.push(keyword)
      }
    }
    return suggested
  }

  private extractKeywords(text: string): string[] {
    const cleaned = text.replace(/[^a-zA-Z0-9\u4e00-\u9fa5]+/g, ' ').replace(/\s+/g, ' ')
    const tokens = cleaned.split(' ').filter((word: string) => word.trim().length >= 2)
    const frequency = new Map<string, number>()
    for (const token of tokens) {
      const key = token.trim()
      if (key.length === 0) {
        continue
      }
      const current = frequency.get(key)
      frequency.set(key, current === undefined ? 1 : current + 1)
    }
    return Array.from(frequency.keys())
      .sort((a: string, b: string) => {
        const aCount = frequency.get(a)
        const bCount = frequency.get(b)
        return (bCount === undefined ? 0 : bCount) - (aCount === undefined ? 0 : aCount)
      })
      .slice(0, 5)
  }

  private inferTodoStatus(text: string): TodoVisualStatus {
    const urgentWords = ['待办', '任务', '计划', '完成', '截止', '提醒', '安排']
    const doneWords = ['已完成', '完成了', '处理完']
    for (const keyword of doneWords) {
      if (text.indexOf(keyword) >= 0) {
        return TodoVisualStatus.COMPLETED
      }
    }
    for (const keyword of urgentWords) {
      if (text.indexOf(keyword) >= 0) {
        return TodoVisualStatus.PENDING
      }
    }
    return TodoVisualStatus.NONE
  }

  private inferPriority(text: string): number {
    const highWords = ['紧急', '马上', '立即', '今天', '明天', '重要', '优先']
    for (const keyword of highWords) {
      if (text.indexOf(keyword) >= 0) {
        return 1
      }
    }
    return 0
  }

  private buildLocalSummary(text: string): string {
    if (text.length <= 120) {
      return text.trim()
    }
    const snippet = text.substring(0, 120).trim()
    return `${snippet}...`
  }

  private extractActionItems(text: string): string[] {
    const lines = text.split(/[。；;\n\r]/)
    const items: string[] = []
    const actionWords = ['需要', '请', '记得', '务必', '安排', '完成', '落实']
    for (const line of lines) {
      const trimmed = line.trim()
      if (trimmed.length === 0) {
        continue
      }
      for (const keyword of actionWords) {
        if (trimmed.indexOf(keyword) >= 0 && items.length < 5) {
          items.push(trimmed)
          break
        }
      }
    }
    return items
  }

  parseTags(tagsText: string): string[] {
    if (tagsText.trim().length === 0) {
      return []
    }
    const uniqueTags: string[] = []
    tagsText
      .split(',')
      .map((tag: string) => tag.trim())
      .filter((tag: string) => tag.length > 0)
      .forEach((tag: string) => {
        if (uniqueTags.indexOf(tag) < 0) {
          uniqueTags.push(tag)
        }
      })
    return uniqueTags
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
    const uniqueTags: string[] = []
    tags
      .map((tag: string) => tag.trim())
      .filter((tag: string) => tag.length > 0)
      .forEach((tag: string) => {
        if (uniqueTags.indexOf(tag) < 0) {
          uniqueTags.push(tag)
        }
      })
    return uniqueTags.join(',')
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
