import relationalStore from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import { CommonConstants, TodoVisualStatus } from '../common/Constants'
import { Note } from '../model/Note'
import { Todo, TodoStatus } from '../model/Todo'
import { Logger } from '../utils/Logger'

export class RdbStoreManager {
  private static instance: RdbStoreManager | null = null
  private store: relationalStore.RdbStore | null = null
  private context: common.Context
  private initialized: boolean = false

  private constructor(context: common.Context) {
    this.context = context
  }

  static getInstance(context?: common.Context): RdbStoreManager {
    if (RdbStoreManager.instance === null) {
      if (context === undefined) {
        throw new Error('RdbStoreManager must be initialized with a context before use')
      }
      RdbStoreManager.instance = new RdbStoreManager(context)
    }
    return RdbStoreManager.instance
  }

  async initDb(): Promise<void> {
    if (this.initialized && this.store !== null) {
      return
    }

    const config: relationalStore.StoreConfig = {
      name: CommonConstants.RDB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }

    const sqlNotes = `CREATE TABLE IF NOT EXISTS ${CommonConstants.TABLE_NOTES} (
      ${CommonConstants.COL_ID} TEXT PRIMARY KEY,
      ${CommonConstants.COL_TITLE} TEXT,
      ${CommonConstants.COL_CONTENT} TEXT,
      ${CommonConstants.COL_IMAGE_PATH} TEXT,
      ${CommonConstants.COL_TAGS} TEXT,
      ${CommonConstants.COL_CREATE_TIME} INTEGER,
      ${CommonConstants.COL_IS_TODO} INTEGER,
      ${CommonConstants.COL_TODO_STATUS} TEXT DEFAULT '${TodoVisualStatus.PENDING}'
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
      await this.tryAddTodoStatusColumn()
      this.initialized = true
      Logger.info('RdbStoreManager', 'Database initialized successfully')
    } catch (error) {
      Logger.error('RdbStoreManager', `Database initialization failed: ${JSON.stringify(error)}`)
      throw new Error(`Database initialization failed: ${JSON.stringify(error)}`)
    }
  }

  private async ensureStore(): Promise<relationalStore.RdbStore> {
    await this.initDb()
    if (this.store === null) {
      throw new Error('Database store is unavailable')
    }
    return this.store
  }

  private async tryAddTodoStatusColumn(): Promise<void> {
    if (this.store === null) {
      return
    }
    try {
      await this.store.executeSql(
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN ${CommonConstants.COL_TODO_STATUS} TEXT DEFAULT '${TodoVisualStatus.PENDING}'`
      )
      Logger.info('RdbStoreManager', 'todoStatus column migration applied')
    } catch (error) {
      Logger.info('RdbStoreManager', `todoStatus migration skipped: ${JSON.stringify(error)}`)
    }
  }

  async insertNote(note: Note): Promise<number> {
    const store = await this.ensureStore()
    const valueBucket: relationalStore.ValuesBucket = {
      id: note.id,
      title: note.title,
      content: note.content,
      imagePath: note.imagePath,
      tags: note.tags,
      createTime: note.createTime,
      isTodo: note.isTodo,
      todoStatus: note.todoStatus
    }
    return store.insert(CommonConstants.TABLE_NOTES, valueBucket)
  }

  async updateNote(note: Note): Promise<number> {
    const store = await this.ensureStore()
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    predicates.equalTo(CommonConstants.COL_ID, note.id)
    const valueBucket: relationalStore.ValuesBucket = {
      title: note.title,
      content: note.content,
      imagePath: note.imagePath,
      tags: note.tags,
      createTime: note.createTime,
      isTodo: note.isTodo,
      todoStatus: note.todoStatus
    }
    return store.update(valueBucket, predicates)
  }

  async queryNoteById(noteId: string): Promise<Note | null> {
    const store = await this.ensureStore()
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    predicates.equalTo(CommonConstants.COL_ID, noteId)
    const resultSet = await store.query(predicates)
    if (!resultSet.goToFirstRow()) {
      resultSet.close()
      return null
    }
    const note = this.mapNote(resultSet)
    resultSet.close()
    return note
  }

  async queryAllNotes(): Promise<Note[]> {
    const store = await this.ensureStore()
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES)
    predicates.orderByDesc(CommonConstants.COL_CREATE_TIME)

    const resultSet = await store.query(predicates)
    const notes: Note[] = []
    while (resultSet.goToNextRow()) {
      notes.push(this.mapNote(resultSet))
    }
    resultSet.close()
    return notes
  }

  private mapNote(resultSet: relationalStore.ResultSet): Note {
    return {
      id: resultSet.getString(resultSet.getColumnIndex(CommonConstants.COL_ID)),
      title: resultSet.getString(resultSet.getColumnIndex(CommonConstants.COL_TITLE)),
      content: resultSet.getString(resultSet.getColumnIndex(CommonConstants.COL_CONTENT)),
      imagePath: resultSet.getString(resultSet.getColumnIndex(CommonConstants.COL_IMAGE_PATH)),
      tags: resultSet.getString(resultSet.getColumnIndex(CommonConstants.COL_TAGS)),
      createTime: resultSet.getLong(resultSet.getColumnIndex(CommonConstants.COL_CREATE_TIME)),
      isTodo: resultSet.getLong(resultSet.getColumnIndex(CommonConstants.COL_IS_TODO)),
      todoStatus: this.readTodoStatus(resultSet)
    }
  }

  private readTodoStatus(resultSet: relationalStore.ResultSet): string {
    try {
      return resultSet.getString(resultSet.getColumnIndex(CommonConstants.COL_TODO_STATUS))
    } catch (_) {
      return TodoVisualStatus.PENDING
    }
  }

  async insertTodo(todo: Todo): Promise<number> {
    const store = await this.ensureStore()
    const valueBucket: relationalStore.ValuesBucket = {
      id: todo.id,
      noteId: todo.noteId,
      status: todo.status,
      deadline: todo.deadline,
      priority: todo.priority
    }
    return store.insert(CommonConstants.TABLE_TODOS, valueBucket)
  }

  async queryTodoByNoteId(noteId: string): Promise<Todo | null> {
    const store = await this.ensureStore()
    const predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_TODOS)
    predicates.equalTo('noteId', noteId)

    const resultSet = await store.query(predicates)
    if (resultSet.goToFirstRow()) {
      const todo: Todo = {
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        noteId: resultSet.getString(resultSet.getColumnIndex('noteId')),
        status: resultSet.getLong(resultSet.getColumnIndex('status')) as TodoStatus,
        deadline: resultSet.getLong(resultSet.getColumnIndex('deadline')),
        priority: resultSet.getLong(resultSet.getColumnIndex('priority'))
      }
      resultSet.close()
      return todo
    }
    resultSet.close()
    return null
  }
}
