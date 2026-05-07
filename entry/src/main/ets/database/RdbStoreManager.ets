import relationalStore from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import { Note } from '../model/Note'
import { Todo, TodoStatus } from '../model/Todo'
import { CommonConstants, TodoVisualStatus } from '../common/Constants'

export class RdbStoreManager {
  private static instance: RdbStoreManager | null = null
  private store: relationalStore.RdbStore | null = null
  private context: common.Context

  private constructor(context: common.Context) {
    this.context = context
  }

  static getInstance(context: common.Context): RdbStoreManager {
    if (RdbStoreManager.instance === null) {
      RdbStoreManager.instance = new RdbStoreManager(context)
    }
    return RdbStoreManager.instance
  }

  async initDb() {
    if (this.store !== null) {
      return
    }

    const config: relationalStore.StoreConfig = {
      name: CommonConstants.RDB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }

    const sqlNotes = `CREATE TABLE IF NOT EXISTS ${CommonConstants.TABLE_NOTES} (
      id TEXT PRIMARY KEY,
      userId TEXT,
      title TEXT,
      content TEXT,
      imagePath TEXT,
      tags TEXT,
      aiTags TEXT,
      summary TEXT,
      actionItems TEXT,
      priority INTEGER,
      createTime INTEGER,
      isTodo INTEGER
    )`

    const sqlTodos = `CREATE TABLE IF NOT EXISTS ${CommonConstants.TABLE_TODOS} (
      id TEXT PRIMARY KEY,
      noteId TEXT,
      status INTEGER,
      deadline INTEGER,
      priority INTEGER
    )`

    try {
      this.store = await relationalStore.getRdbStore(this.context, config)
      await this.store.executeSql(sqlNotes)
      await this.store.executeSql(sqlTodos)
      const alterStatements = [
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN aiTags TEXT`,
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN summary TEXT`,
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN actionItems TEXT`,
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN priority INTEGER`
      ]
      for (const stmt of alterStatements) {
        try {
          await this.store.executeSql(stmt)
        } catch (_err) {
          // Ignore repeated ALTER TABLE statements on existing columns.
        }
      }
      console.info('RDB_LOG: 数据库初始化成功')
    } catch (err) {
      console.error(`RDB_LOG: 数据库初始化失败 ${JSON.stringify(err)}`)
    }
  }

  async insertNote(note: Note) {
    if (!this.store) {
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      id: note.id,
      userId: note.userId || '',
      title: note.title,
      content: note.content,
      imagePath: note.imagePath,
      tags: note.tags,
      aiTags: note.aiTags || '',
      summary: note.summary || '',
      actionItems: note.actionItems || '',
      priority: note.priority || 0,
      createTime: note.createTime,
      isTodo: note.isTodo
    }
    return await this.store.insert(CommonConstants.TABLE_NOTES, valueBucket)
  }

  async updateNote(note: Note) {
    if (!this.store) {
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      title: note.title,
      content: note.content,
      imagePath: note.imagePath,
      tags: note.tags,
      aiTags: note.aiTags || '',
      summary: note.summary || '',
      actionItems: note.actionItems || '',
      priority: note.priority || 0,
      createTime: note.createTime,
      isTodo: note.isTodo
    }
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    predicates.equalTo('id', note.id)
    return await this.store.update(valueBucket, predicates)
  }

  async queryNoteById(id: string): Promise<Note | null> {
    if (!this.store) {
      return null
    }
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    predicates.equalTo('id', id)
    const resultSet = await this.store.query(predicates)
    const results = this.mapResultSetToNotes(resultSet)
    return results.length > 0 ? results[0] : null
  }

  async queryAllNotes(userId?: string): Promise<Note[]> {
    if (!this.store) {
      return []
    }
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    if (userId) {
      predicates.equalTo('userId', userId)
    }
    predicates.orderByDesc('createTime')
    const resultSet = await this.store.query(predicates)
    return this.mapResultSetToNotes(resultSet)
  }

  async searchNotes(keyword: string, userId?: string): Promise<Note[]> {
    if (!this.store) {
      return []
    }
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    if (userId) {
      predicates.equalTo('userId', userId)
      if (keyword.trim()) {
        predicates.and().beginWrap().contains('title', keyword).or().contains('content', keyword).endWrap()
      }
    } else if (keyword.trim()) {
      predicates.contains('title', keyword).or().contains('content', keyword)
    }
    predicates.orderByDesc('createTime')
    const resultSet = await this.store.query(predicates)
    return this.mapResultSetToNotes(resultSet)
  }

  async updateNoteCompleteStatus(noteId: string, isDone: boolean) {
    if (!this.store) {
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      isTodo: isDone ? 0 : 1
    }
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    predicates.equalTo('id', noteId)
    return await this.store.update(valueBucket, predicates)
  }

  private mapResultSetToNotes(resultSet: relationalStore.ResultSet): Note[] {
    const result: Note[] = []
    while (resultSet.goToNextRow()) {
      const isTodoVal = resultSet.getLong(resultSet.getColumnIndex('isTodo'))

      let userId = ''
      try {
        userId = resultSet.getString(resultSet.getColumnIndex('userId'))
      } catch (_error) {
        userId = ''
      }

      result.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        userId,
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        imagePath: resultSet.getString(resultSet.getColumnIndex('imagePath')),
        tags: resultSet.getString(resultSet.getColumnIndex('tags')),
        aiTags: resultSet.getString(resultSet.getColumnIndex('aiTags')),
        summary: resultSet.getString(resultSet.getColumnIndex('summary')),
        actionItems: resultSet.getString(resultSet.getColumnIndex('actionItems')),
        priority: resultSet.getLong(resultSet.getColumnIndex('priority')),
        createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
        isTodo: isTodoVal,
        todoStatus: this.mapTodoStatus(isTodoVal)
      })
    }
    resultSet.close()
    return result
  }

  private mapTodoStatus(isTodoVal: number): TodoVisualStatus {
    switch (isTodoVal) {
      case 1:
        return TodoVisualStatus.PENDING
      case 0:
        return TodoVisualStatus.COMPLETED
      case 2:
        return TodoVisualStatus.DEFERRED
      case -1:
      default:
        return TodoVisualStatus.NONE
    }
  }

  async insertTodo(todo: Todo) {
    if (!this.store) {
      return
    }
    const valueBucket: relationalStore.ValuesBucket = {
      id: todo.id,
      noteId: todo.noteId,
      status: todo.status,
      deadline: todo.deadline,
      priority: todo.priority
    }
    return await this.store.insert(CommonConstants.TABLE_TODOS, valueBucket)
  }

  async queryTodoByNoteId(noteId: string): Promise<Todo | null> {
    if (!this.store) {
      return null
    }
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_TODOS)
    predicates.equalTo('noteId', noteId)
    const resultSet = await this.store.query(predicates)
    if (resultSet.goToFirstRow()) {
      const result: Todo = {
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        noteId: resultSet.getString(resultSet.getColumnIndex('noteId')),
        status: resultSet.getLong(resultSet.getColumnIndex('status')) as TodoStatus,
        deadline: resultSet.getLong(resultSet.getColumnIndex('deadline')),
        priority: resultSet.getLong(resultSet.getColumnIndex('priority'))
      }
      resultSet.close()
      return result
    }
    resultSet.close()
    return null
  }
}
