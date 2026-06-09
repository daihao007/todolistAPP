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
  aiTags: string[]
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
  keywords: string[]
  actionItems: string[]
  suggestedTags: string[]
}

interface CloudRequestPayload {
  model: string
  messages: CloudRequestMessage[]
  temperature: number
}

interface CloudRequestMessage {
  role: string
  content: string
}

interface CloudMessagePayload {
  content?: string
}

interface CloudChoicePayload {
  message?: CloudMessagePayload
}

interface CloudResponsePayload {
  summary?: string
  keywords?: Array<string>
  actionItems?: Array<string>
  suggestedTags?: Array<string>
  tags?: Array<string>
  data?: CloudResponsePayload
  choices?: Array<CloudChoicePayload>
}

interface SummarySentenceScore {
  sentence: string
  index: number
  score: number
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
      aiTags: this.tagsToText(input.aiTags),
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
      aiTags: this.tagsToText(input.aiTags),
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

  async deleteNote(noteId: string): Promise<void> {
    await this.rdbStoreManager.deleteNote(noteId)
    Logger.info('NoteService', `Deleted note ${noteId}`)
  }

  async deleteTodo(noteId: string): Promise<void> {
    await this.rdbStoreManager.deleteNote(noteId)
    Logger.info('NoteService', `Deleted todo ${noteId}`)
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

    const prompt = this.buildCloudAiPrompt(title, content)
    const payload: CloudRequestPayload = {
      model: CommonConstants.AI_CLOUD_MODEL,
      messages: [
        {
          role: 'system',
          content: '你是一个笔记整理助手。请只返回 JSON，不要输出任何额外说明。'
        },
        {
          role: 'user',
          content: prompt
        }
      ],
      temperature: 0.3
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
        keywords: parsed.keywords,
        actionItems: parsed.actionItems,
        suggestedTags: parsed.suggestedTags
      }
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      Logger.error('NoteService', `Cloud AI request failed: ${errMsg}`)
      throw new Error(`Cloud AI request failed: ${errMsg}`)
    }
  }

  private parseCloudResponse(response: string): CloudAiResult {
    const parsed = JSON.parse(response) as CloudResponsePayload
    const directSummary = this.pickString(parsed.summary)
    const directKeywords = this.pickStringList(parsed.keywords)
    const directActions = this.pickStringList(parsed.actionItems)
    const directTags = this.pickStringList(parsed.suggestedTags)
    const fallbackTags = this.pickStringList(parsed.tags)
    const resolvedTags = directTags.length > 0 ? directTags : fallbackTags
    if (directSummary.length > 0 || directKeywords.length > 0 || directActions.length > 0 || resolvedTags.length > 0) {
      return {
        summary: directSummary,
        keywords: directKeywords,
        actionItems: directActions,
        suggestedTags: resolvedTags
      }
    }

    const dataBlock = parsed.data
    if (dataBlock !== undefined) {
      const dataSuggestedTags = this.pickStringList(dataBlock.suggestedTags)
      const dataFallbackTags = this.pickStringList(dataBlock.tags)
      return {
        summary: this.pickString(dataBlock.summary),
        keywords: this.pickStringList(dataBlock.keywords),
        actionItems: this.pickStringList(dataBlock.actionItems),
        suggestedTags: dataSuggestedTags.length > 0 ? dataSuggestedTags : dataFallbackTags
      }
    }

    const choices = parsed.choices
    if (choices !== undefined && choices.length > 0) {
      const firstChoice = choices[0]
      const message = firstChoice.message
      const messageContent = message === undefined ? '' : this.pickString(message.content)
      if (messageContent.length > 0) {
        try {
          // 清理大模型可能返回的 ```json ``` 标记
          let cleanContent = messageContent;
          if (cleanContent.startsWith('```json')) {
            cleanContent = cleanContent.replace(/^```json/, '').replace(/```$/, '').trim();
          } else if (cleanContent.startsWith('```')) {
            cleanContent = cleanContent.replace(/^```/, '').replace(/```$/, '').trim();
          }
          return this.parseCloudResponse(cleanContent)
        } catch (_error) {
          return {
            summary: messageContent,
            keywords: [],
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
      keywords: this.extractKeywords(merged),
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
    const normalized = text
      .replace(/\s+/g, ' ')
      .replace(/[，,]{2,}/g, '，')
      .trim()

    if (normalized.length === 0) {
      return ''
    }

    const sentences = this.splitToSentences(normalized)
    if (sentences.length === 0) {
      return this.limitSummaryLength(normalized)
    }

    const keywords = this.extractKeywords(normalized)
    const rankedSentenceScores: SummarySentenceScore[] = sentences
      .map((sentence: string, index: number): SummarySentenceScore => {
        return {
          sentence: sentence,
          index: index,
          score: this.scoreSummarySentence(sentence, keywords)
        }
      })
      .sort((a: SummarySentenceScore, b: SummarySentenceScore) => b.score - a.score || a.index - b.index)
      .slice(0, Math.min(2, sentences.length))
      .sort((a: SummarySentenceScore, b: SummarySentenceScore) => a.index - b.index)

    const rankedSentences: string[] = rankedSentenceScores.map((item: SummarySentenceScore) => item.sentence)
    const summary = rankedSentences.join('；')
    return this.limitSummaryLength(summary.length > 0 ? summary : normalized)
  }

  private extractActionItems(text: string): string[] {
    const lines = text.split(/[。；;\n\r]/)
    const items: string[] = []
    const actionWords = ['需要', '请', '记得', '务必', '安排', '完成', '落实', '准备', '确认', '跟进', '提交', '联系', '推进']
    for (const line of lines) {
      const trimmed = this.normalizeActionItem(line)
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

    if (items.length === 0) {
      const fallbackSentences = this.splitToSentences(text)
      for (const sentence of fallbackSentences) {
        const normalizedSentence = this.normalizeActionItem(sentence)
        if (normalizedSentence.length > 0 && items.indexOf(normalizedSentence) < 0) {
          items.push(normalizedSentence)
        }
        if (items.length >= 3) {
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

  private buildCloudAiPrompt(title: string, content: string): string {
    return [
      '请根据下面的笔记内容，生成摘要、关键词、待办事项和推荐标签。',
      '请严格返回 JSON，格式如下：',
      '{"summary":"...","keywords":["..."],"actionItems":["..."],"suggestedTags":["..."]}',
      '要求：',
      '1. summary 用简体中文，1到3句。',
      '2. keywords 返回 3 到 5 个关键词。',
      '3. actionItems 返回 1 到 5 条可执行待办；如果内容里没有明确待办，可以基于笔记整理出合理行动项。',
      '4. suggestedTags 返回 2 到 4 个简短标签。',
      `标题：${title.trim()}`,
      `内容：${content.trim()}`
    ].join('\n')
  }

  private splitToSentences(text: string): string[] {
    return text
      .split(/[。！？；;\n\r]/)
      .map((sentence: string) => sentence.trim())
      .filter((sentence: string) => sentence.length >= 6)
  }

  private scoreSummarySentence(sentence: string, keywords: string[]): number {
    let score = Math.min(sentence.length, 40)

    keywords.forEach((keyword: string, index: number) => {
      if (keyword.length >= 2 && sentence.indexOf(keyword) >= 0) {
        score += Math.max(8 - index, 3)
      }
    })

    const summaryHints = ['目标', '计划', '需要', '准备', '安排', '问题', '风险', '结论', '总结', '完成', '推进']
    summaryHints.forEach((hint: string) => {
      if (sentence.indexOf(hint) >= 0) {
        score += 6
      }
    })

    if (sentence.length < 10) {
      score -= 8
    }
    if (sentence.length > 80) {
      score -= 4
    }

    return score
  }

  private limitSummaryLength(text: string): string {
    if (text.length <= 120) {
      return text
    }
    return `${text.substring(0, 117).trim()}...`
  }

  private normalizeActionItem(text: string): string {
    return text
      .trim()
      .replace(/^[\d\-•.\s]+/g, '')
      .replace(/[。；;，,]+$/g, '')
      .trim()
  }
}
