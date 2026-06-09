import common from '@ohos.app.ability.common'
import { CommonConstants, TodoVisualStatus } from '../common/Constants'
import { RdbStoreManager } from '../database/RdbStoreManager'
import { Note } from '../model/Note'
import { Logger } from '../utils/Logger'
import { PreferenceUtil } from '../utils/PreferenceUtil'
import { HttpUtil } from '../utils/HttpUtil'
import { NativeTextAnalyzer } from '../utils/NativeTextAnalyzer'

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
  timeInfo: string  // 提取的时间信息，如"明天"、"下周五"
  priorityLevel: 'high' | 'medium' | 'low' | 'none'  // 优先级级别
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

  // 同义词映射表
  private readonly synonymMap: Record<string, string> = {
    '开会': '会议', '开个会': '会议', '开个短会': '会议', '站会': '会议',
    '上课': '课程', '听课': '课程', '培训': '课程',
    '买东西': '购物', '采购': '购物', '下单': '购物',
    'bug': 'Bug', '修bug': 'Bug', '修Bug': 'Bug', '修 bug': 'Bug',
    '发布': '上线', '部署': '上线', '上线发布': '上线',
    '联调': '接口', '对接': '接口', '联调测试': '接口',
    '写代码': '开发', '编码': '开发', '撸代码': '开发',
    '写文档': '文档', '写需求': '文档', '写PRD': '文档',
    '排期': '计划', '做计划': '计划', '定计划': '计划',
    '复盘': '总结', '回顾': '总结',
    '汇报': '周报', '写周报': '周报', '周报总结': '周报',
    '健身': '运动', '锻炼': '运动', '跑步': '运动',
    '做饭': '饮食', '点外卖': '饮食', '吃饭': '饮食',
    'debug': 'Bug', '调试': 'Bug',
    'review': '评审', '代码评审': '评审', 'CR': '评审',
    '需求评审': '评审', '方案评审': '评审',
    '同步': '沟通', '对齐': '沟通', '拉通': '沟通',
    '跟进': '任务', '追踪': '任务', '推动': '任务'
  }

  // 分层标签体系（50+个标签）
  private readonly tagHierarchy: Record<string, string[]> = {
    '工作': ['会议', '项目', '产品', '评审', '需求', '排期', '上线', '复盘', '周报', '汇报', '沟通', '协调'],
    '学习': ['课程', '考试', '论文', '调研', '技术', '算法', '框架', '源码', '笔记', '读书', '培训'],
    '生活': ['购物', '旅行', '健身', '饮食', '娱乐', '社交', '家务', '维修', '运动', '电影', '音乐'],
    '开发': ['Bug', '测试', '部署', '数据库', '接口', '优化', '重构', '迁移', '开发', '前端', '后端', 'API'],
    '管理': ['计划', '任务', '排期', '跟进', '协调', '分配', '验收', '目标', 'KPI', 'OKR'],
    '文档': ['文档', '需求', 'PRD', '方案', '设计', '架构', '流程图', 'UML'],
    '财务': ['报销', '预算', '成本', '收入', '支出', '账单'],
    '健康': ['体检', '就医', '用药', '睡眠', '养生', '心理']
  }

  // 时间提取模式
  private readonly timePatterns: Array<{ regex: RegExp, handler: (match: RegExpMatchArray) => string }> = [
    { regex: /今天|今日/, handler: () => '今天' },
    { regex: /明天|明日/, handler: () => '明天' },
    { regex: /后天/, handler: () => '后天' },
    { regex: /大后天/, handler: () => '大后天' },
    { regex: /下周一/, handler: () => '下周一' },
    { regex: /下周二/, handler: () => '下周二' },
    { regex: /下周三/, handler: () => '下周三' },
    { regex: /下周四/, handler: () => '下周四' },
    { regex: /下周五/, handler: () => '下周五' },
    { regex: /下周六/, handler: () => '下周六' },
    { regex: /下周日|下周天/, handler: () => '下周日' },
    { regex: /这周|本周/, handler: () => '本周内' },
    { regex: /月底/, handler: () => '月底前' },
    { regex: /年底/, handler: () => '年底' },
    { regex: /(\d{1,2})月(\d{1,2})[日号]/, handler: (m) => `${m[1]}月${m[2]}日` },
    { regex: /下个月/, handler: () => '下个月' },
    { regex: /下周/, handler: () => '下周' }
  ]

  // 优先级关键词
  private readonly priorityPatterns = {
    high: ['紧急', '马上', '立即', 'ASAP', '尽快', '优先', '重要', '关键', '火速', '加急', '立刻', '火急'],
    medium: ['尽快', '这周', '本周', '近期', '这两天', '早些'],
    low: ['有空', '方便时', '后续', '以后', '不急', '慢慢', '空了']
  }

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
    const timeInfo = this.extractTimeInfo(trimmed)
    const priorityLevel = this.extractPriorityLevel(trimmed)
    return {
      suggestedTags,
      keywords,
      summary,
      actionItems,
      todoStatus,
      priority,
      timeInfo,
      priorityLevel
    }
  }

  // 提取时间信息
  private extractTimeInfo(text: string): string {
    for (const pattern of this.timePatterns) {
      const match = text.match(pattern.regex)
      if (match) {
        return pattern.handler(match)
      }
    }
    return ''
  }

  // 提取优先级级别
  private extractPriorityLevel(text: string): 'high' | 'medium' | 'low' | 'none' {
    for (const keyword of this.priorityPatterns.high) {
      if (text.indexOf(keyword) >= 0) {
        return 'high'
      }
    }
    for (const keyword of this.priorityPatterns.medium) {
      if (text.indexOf(keyword) >= 0) {
        return 'medium'
      }
    }
    for (const keyword of this.priorityPatterns.low) {
      if (text.indexOf(keyword) >= 0) {
        return 'low'
      }
    }
    return 'none'
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
    const tagScores: Map<string, number> = new Map()
    const lower = text.toLowerCase()

    // 1. 同义词替换后匹配标签
    for (const [synonym, standardTag] of Object.entries(this.synonymMap)) {
      if (lower.indexOf(synonym.toLowerCase()) >= 0) {
        tagScores.set(standardTag, (tagScores.get(standardTag) || 0) + 3)
      }
    }

    // 2. 直接匹配标签（遍历所有标签）
    for (const [category, tags] of Object.entries(this.tagHierarchy)) {
      for (const tag of tags) {
        if (lower.indexOf(tag.toLowerCase()) >= 0) {
          tagScores.set(tag, (tagScores.get(tag) || 0) + 5)
        }
      }
      // 匹配到类别关键词，给类别下的标签加分
      if (lower.indexOf(category.toLowerCase()) >= 0) {
        for (const tag of tags.slice(0, 3)) {
          tagScores.set(tag, (tagScores.get(tag) || 0) + 1)
        }
      }
    }

    // 3. 提取关键词作为候选标签
    const keywords = this.extractKeywords(text, 8)
    for (let i = 0; i < keywords.length; i++) {
      const keyword = keywords[i]
      if (keyword.length >= 2 && !tagScores.has(keyword)) {
        // 关键词权重递减
        tagScores.set(keyword, (tagScores.get(keyword) || 0) + (3 - i * 0.3))
      }
    }

    // 4. 按权重排序，取前3个
    const sortedTags = Array.from(tagScores.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 3)
      .map(entry => entry[0])

    return sortedTags
  }

  private extractKeywords(text: string, topK: number = 5): string[] {
    return NativeTextAnalyzer.extractKeywords(text, topK)
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
      .replace(/[ \t]+/g, ' ')
      .replace(/[\n\r]+/g, '。')
      .replace(/[，,]{2,}/g, '，')
      .trim()

    if (normalized.length === 0) {
      return ''
    }

    const sentences = this.splitToSentences(normalized)
    if (sentences.length === 0) {
      return this.limitSummaryLength(normalized)
    }

    const keywords = this.extractKeywords(normalized, 5)
    const topSentences = NativeTextAnalyzer.scoreSentences(normalized, keywords, 2)
    if (topSentences.length > 0) {
      return this.limitSummaryLength(this.buildConciseSummary(topSentences, keywords, normalized))
    }

    const rankedSentenceScores: SummarySentenceScore[] = sentences
      .map((sentence: string, index: number): SummarySentenceScore => {
        return {
          sentence: sentence,
          index: index,
          score: this.scoreSummarySentence(sentence, keywords, index, sentences.length)
        }
      })
      .sort((a: SummarySentenceScore, b: SummarySentenceScore) => b.score - a.score || a.index - b.index)
      .slice(0, Math.min(2, sentences.length))
      .sort((a: SummarySentenceScore, b: SummarySentenceScore) => a.index - b.index)

    const rankedSentences: string[] = rankedSentenceScores.map((item: SummarySentenceScore) => item.sentence)
    const summary = this.buildConciseSummary(rankedSentences, keywords, normalized)
    return this.limitSummaryLength(summary.length > 0 ? summary : normalized)
  }

  private buildConciseSummary(sentences: string[], keywords: string[], fallback: string): string {
    const candidates: SummarySentenceScore[] = []
    let order = 0

    sentences.forEach((sentence: string) => {
      sentence
        .split(/[。！？；;，,\n\r]/)
        .map((clause: string) => this.normalizeSummaryClause(clause))
        .filter((clause: string) => clause.length >= 4)
        .forEach((clause: string) => {
          if (this.containsSummaryClause(candidates, clause)) {
            return
          }
          candidates.push({
            sentence: clause,
            index: order,
            score: this.scoreSummaryClause(clause, keywords, order)
          })
          order += 1
        })
    })

    if (candidates.length === 0) {
      return fallback
    }

    const selected = candidates
      .sort((a: SummarySentenceScore, b: SummarySentenceScore) => b.score - a.score || a.index - b.index)
      .slice(0, Math.min(5, candidates.length))
      .sort((a: SummarySentenceScore, b: SummarySentenceScore) => a.index - b.index)
      .map((item: SummarySentenceScore) => item.sentence)

    return this.mergeSummaryClauses(selected).join('；')
  }

  private normalizeSummaryClause(text: string): string {
    return text
      .trim()
      .replace(/^今天(开了|召开了|进行了)?/, '')
      .replace(/^另外还要/, '')
      .replace(/^另外/, '')
      .replace(/^还要/, '')
      .replace(/^需要/, '')
      .replace(/^请/, '')
      .replace(/^讨论了/, '')
      .replace(/^讨论/, '')
      .replace(/^这个任务/, '任务')
      .trim()
  }

  private scoreSummaryClause(clause: string, keywords: string[], index: number): number {
    let score = Math.min(clause.length, 30) - index * 0.2
    keywords.forEach((keyword: string, keywordIndex: number) => {
      if (keyword.length >= 2 && clause.indexOf(keyword) >= 0) {
        score += Math.max(8 - keywordIndex, 3)
      }
    })

    const actionHints = ['完成', '确认', '推进', '安排', '整理', '准备', '落实', '提交', '迁移', '部署']
    actionHints.forEach((hint: string) => {
      if (clause.indexOf(hint) >= 0) {
        score += 6
      }
    })

    if (clause.indexOf('紧急') >= 0 || clause.indexOf('风险') >= 0 || clause.indexOf('问题') >= 0) {
      score += 4
    }
    return score
  }

  private containsSummaryClause(candidates: SummarySentenceScore[], clause: string): boolean {
    for (const candidate of candidates) {
      if (candidate.sentence === clause) {
        return true
      }
    }
    return false
  }

  private mergeSummaryClauses(clauses: string[]): string[] {
    const merged: string[] = []
    clauses.forEach((clause: string) => {
      if (merged.length > 0) {
        const previous = merged[merged.length - 1]
        const isActionClause = clause.indexOf('完成') >= 0 || clause.indexOf('确认') >= 0 ||
          clause.indexOf('推进') >= 0 || clause.indexOf('安排') >= 0 || clause.indexOf('整理') >= 0
        if (!isActionClause && (previous.indexOf('会议') >= 0 || previous.indexOf('评审') >= 0) &&
          clause.indexOf('计划') >= 0) {
          merged[merged.length - 1] = `${previous}讨论${clause}`
          return
        }
      }
      merged.push(clause)
    })
    return merged
  }

  private extractActionItems(text: string): string[] {
    const clauses = text.split(/[。；;，,\n\r]/)
    const items: string[] = []
    const actionWords = [
      // 原有动词
      '确认', '完成', '推进', '安排', '整理', '落实', '提交', '联系', '跟进', '需要', '请', '记得', '务必',
      // 新增动词
      '准备', '处理', '修改', '更新', '检查', '测试', '部署', '发布', '修复', '优化',
      '开发', '实现', '设计', '调研', '讨论', '评审', '同步', '对齐', '沟通', '协调',
      '通知', '提醒', '预定', '预约', '购买', '下载', '上传', '备份', '清理', '删除',
      '创建', '新建', '配置', '设置', '调整', '规划', '制定', '执行', '启动', '暂停'
    ]

    for (const clause of clauses) {
      const trimmed = this.normalizeActionItem(clause)
      if (trimmed.length === 0 || trimmed.length < 3) {
        continue
      }
      for (const keyword of actionWords) {
        if (trimmed.indexOf(keyword) >= 0 && items.length < 5) {
          const actionItem = this.trimActionPrefix(trimmed, keyword)
          if (actionItem.length > 0 && items.indexOf(actionItem) < 0) {
            items.push(actionItem)
          }
          break
        }
      }
    }

    // 识别隐含待办
    const implicitActions = this.inferImplicitActions(text)
    for (const action of implicitActions) {
      if (items.length >= 5) break
      if (items.indexOf(action) < 0) {
        items.push(action)
      }
    }

    // 回退逻辑：如果还是没有，尝试从句子中提取
    if (items.length === 0) {
      const fallbackSentences = this.splitToSentences(text)
      for (const sentence of fallbackSentences) {
        const normalizedSentence = this.normalizeActionItem(sentence)
        if (normalizedSentence.length > 0 && normalizedSentence.length >= 6 && items.indexOf(normalizedSentence) < 0) {
          items.push(normalizedSentence)
        }
        if (items.length >= 3) {
          break
        }
      }
    }

    return items
  }

  // 识别隐含待办
  private inferImplicitActions(text: string): string[] {
    const actions: string[] = []
    const patterns: Array<{ regex: RegExp, template: string }> = [
      { regex: /(.+?)(?:有风险|存在风险|风险较高)/, template: '评估$1风险' },
      { regex: /(.+?)(?:有问题|存在问题|出问题了)/, template: '排查$1问题' },
      { regex: /(.+?)(?:还没完成|未完成|还没做|没做完)/, template: '完成$1' },
      { regex: /(.+?)(?:需要优化|可以优化|待优化)/, template: '优化$1' },
      { regex: /(.+?)(?:需要测试|待测试|还没测试)/, template: '测试$1' },
      { regex: /(.+?)(?:需要确认|待确认|还不确定)/, template: '确认$1' },
      { regex: /(.+?)(?:有bug|有Bug|存在bug|存在Bug)/, template: '修复$1的Bug' },
      { regex: /(.+?)(?:延期了|推迟了|延后了)/, template: '跟进$1进度' },
      { regex: /(.+?)(?:超时了|超期了|逾期了)/, template: '处理$1超时问题' },
      { regex: /(.+?)(?:卡住了|阻塞了|被阻塞)/, template: '解决$1阻塞问题' },
      { regex: /要(?:尽快|赶紧|马上)(.+?)(?:一下|掉|完|好)/, template: '尽快$1' },
      { regex: /记得(?:要|去|把)?(.+?)(?:一下|掉|完|好)/, template: '$1' }
    ]

    for (const pattern of patterns) {
      const match = text.match(pattern.regex)
      if (match && match[1]) {
        let action = pattern.template.replace('$1', match[1].trim())
        // 清理模板生成的结果
        action = action.replace(/^(需要|请|记得|务必|还要|得)/, '')
        action = action.replace(/[。；;，,]+$/g, '')
        action = action.trim()
        if (action.length >= 4 && action.length <= 30 && actions.indexOf(action) < 0) {
          actions.push(action)
        }
      }
    }

    return actions
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

  private scoreSummarySentence(sentence: string, keywords: string[], index: number = 0, totalSentences: number = 1): number {
    let score = 0

    // 1. 基础分：句子长度（适中的长度更好）
    const len = sentence.length
    if (len >= 15 && len <= 60) {
      score += 30  // 最佳长度范围
    } else if (len >= 10 && len <= 80) {
      score += 20  // 可接受长度
    } else if (len < 10) {
      score += 5   // 太短
    } else {
      score += 15  // 偏长
    }

    // 2. 位置权重（开头和结尾的句子通常更重要）
    if (index === 0) {
      score += 15  // 第一句
    } else if (index === totalSentences - 1) {
      score += 10  // 最后一句
    } else if (index <= 2) {
      score += 8   // 前三句
    }

    // 3. 关键词命中（权重递减）
    keywords.forEach((keyword: string, keywordIndex: number) => {
      if (keyword.length >= 2 && sentence.indexOf(keyword) >= 0) {
        score += Math.max(10 - keywordIndex * 2, 4)
      }
    })

    // 4. 摘要暗示词（扩展词库）
    const summaryHints = [
      // 决策类
      '决定', '确认', '确定', '敲定', '定下', '拍板',
      // 计划类
      '目标', '计划', '规划', '安排', '打算', '准备',
      // 行动类
      '需要', '必须', '务必', '要求', '建议',
      // 结论类
      '结论', '总结', '结果', '成果', '收获',
      // 问题类
      '问题', '风险', '难点', '挑战', '瓶颈',
      // 进展类
      '完成', '推进', '进展', '进度', '下一步',
      // 重点类
      '重点', '核心', '关键', '主要', '重要', '首先', '最终'
    ]
    summaryHints.forEach((hint: string) => {
      if (sentence.indexOf(hint) >= 0) {
        score += 7
      }
    })

    // 5. 时间信息加分（包含时间的句子往往是重点）
    const timeWords = ['今天', '明天', '下周', '月底', '年底', '本周', '近期', '尽快', '马上', '紧急']
    timeWords.forEach((time: string) => {
      if (sentence.indexOf(time) >= 0) {
        score += 5
      }
    })

    // 6. 否定词惩罚（包含否定的句子通常不是核心结论）
    const negationWords = ['不', '没', '未', '无', '非', '别', '勿', '莫']
    negationWords.forEach((neg: string) => {
      if (sentence.indexOf(neg) >= 0) {
        score -= 3
      }
    })

    // 7. 数字加分（包含数据的句子往往更具体）
    if (/\d+/.test(sentence)) {
      score += 4
    }

    // 8. 问句惩罚（问句通常不是结论）
    if (sentence.indexOf('?') >= 0 || sentence.indexOf('？') >= 0 || sentence.indexOf('吗') >= 0) {
      score -= 8
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

  private trimActionPrefix(text: string, keyword: string): string {
    const keywordIndex = text.indexOf(keyword)
    if (keywordIndex < 0) {
      return text
    }

    const actionText = text.substring(keywordIndex)
      .replace(/^需要/, '')
      .replace(/^请/, '')
      .replace(/^记得/, '')
      .replace(/^务必/, '')
      .replace(/^还要/, '')
      .trim()

    return actionText.length > 0 ? actionText : text
  }
}
