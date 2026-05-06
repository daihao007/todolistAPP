import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';
import { Note } from '../model/Note';
import { Todo, TodoStatus } from '../model/Todo';
import { CommonConstants, TodoVisualStatus } from '../common/Constants';

export class RdbStoreManager {
  private static instance: RdbStoreManager | null = null;
  private store: relationalStore.RdbStore | null = null;
  private context: common.Context;

  private constructor(context: common.Context) {
    this.context = context;
  }

  /**
   * 单例获取入口
   */
  static getInstance(context: common.Context): RdbStoreManager {
    if (RdbStoreManager.instance === null) {
      RdbStoreManager.instance = new RdbStoreManager(context);
    }
    return RdbStoreManager.instance;
  }

  /**
   * 初始化数据库
   */
  async initDb() {
    if (this.store !== null) return;

    const config: relationalStore.StoreConfig = {
      name: CommonConstants.RDB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };

    const sqlNotes = `CREATE TABLE IF NOT EXISTS ${CommonConstants.TABLE_NOTES} (
      id TEXT PRIMARY KEY,
      userId TEXT,
      title TEXT,
      content TEXT,
      imagePath TEXT,
      tags TEXT,
      createTime INTEGER,
      isTodo INTEGER,
      todoStatus TEXT
    )`;

    const sqlTodos = `CREATE TABLE IF NOT EXISTS ${CommonConstants.TABLE_TODOS} (
      id TEXT PRIMARY KEY,
      noteId TEXT,
      status INTEGER,
      deadline INTEGER,
      priority INTEGER
    )`;

    try {
      this.store = await relationalStore.getRdbStore(this.context, config);
      await this.store.executeSql(sqlNotes);
      await this.store.executeSql(sqlTodos);
      await this.ensureUserIdColumn();
      await this.ensureTodoStatusColumn();
      await this.syncLegacyTodoStatus();
      console.info('RDB_LOG: 数据库初始化成功');
    } catch (err) {
      console.error('RDB_LOG: 初始化失败', JSON.stringify(err));
    }
  }

  /* ==================== 笔记操作 (Note CRUD) ==================== */

  /**
   * 插入新笔记
   */
  async insertNote(note: Note) {
    if (!this.store) return;
    const valueBucket: relationalStore.ValuesBucket = {
      'id': note.id,
      'userId': note.userId || '',
      'title': note.title,
      'content': note.content,
      'imagePath': note.imagePath,
      'tags': note.tags,
      'createTime': note.createTime,
      'isTodo': note.isTodo,
      'todoStatus': note.todoStatus
    };
    return await this.store.insert(CommonConstants.TABLE_NOTES, valueBucket);
  }

  /**
   * 修复报错 3: 更新笔记内容（用于编辑页）
   */
  async updateNote(note: Note) {
    if (!this.store) return;
    const valueBucket: relationalStore.ValuesBucket = {
      'title': note.title,
      'content': note.content,
      'imagePath': note.imagePath,
      'tags': note.tags,
      'createTime': note.createTime,
      'isTodo': note.isTodo,
      'todoStatus': note.todoStatus
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    predicates.equalTo('id', note.id);
    return await this.store.update(valueBucket, predicates);
  }

  /**
   * 修复报错 2 & 4: 根据ID查询单个笔记
   */
  async queryNoteById(id: string): Promise<Note | null> {
    if (!this.store) return null;
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    predicates.equalTo('id', id);
    let resultSet = await this.store.query(predicates);
    const results = this.mapResultSetToNotes(resultSet);
    return results.length > 0 ? results[0] : null;
  }

  /**
   * 查询所有笔记
   */
  async queryAllNotes(userId?: string): Promise<Note[]> {
    if (!this.store) return [];
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    if (userId) {
      predicates.equalTo('userId', userId);
    }
    predicates.orderByDesc('createTime');
    let resultSet = await this.store.query(predicates);
    return this.mapResultSetToNotes(resultSet);
  }

  /**
   * 搜索笔记
   */
  async searchNotes(keyword: string, userId?: string): Promise<Note[]> {
    if (!this.store) return [];
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    if (userId) {
      predicates.equalTo('userId', userId);
      if (keyword.trim()) {
        predicates.and().beginWrap().contains('title', keyword).or().contains('content', keyword).endWrap();
      }
    } else {
      if (keyword.trim()) {
        predicates.contains('title', keyword).or().contains('content', keyword);
      }
    }
    predicates.orderByDesc('createTime');
    let resultSet = await this.store.query(predicates);
    return this.mapResultSetToNotes(resultSet);
  }

  /**
   * 更新笔记勾选状态
   */
  async updateNoteCompleteStatus(noteId: string, isDone: boolean): Promise<number | void> {
    return this.updateNoteTodoStatus(noteId, isDone ? TodoVisualStatus.COMPLETED : TodoVisualStatus.PENDING);
  }

  /**
   * 更新待办三态：待处理、已完成、已延期。
   */
  async updateNoteTodoStatus(noteId: string, todoStatus: TodoVisualStatus): Promise<number | void> {
    if (!this.store) return;
    const valueBucket: relationalStore.ValuesBucket = {
      'isTodo': todoStatus === TodoVisualStatus.COMPLETED ? 0 : 1,
      'todoStatus': todoStatus
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    predicates.equalTo('id', noteId);
    return await this.store.update(valueBucket, predicates);
  }

  /**
   * 内部方法：将结果集映射为 Note 数组 (解决 TodoVisualStatus 枚举转换问题)
   */
  private mapResultSetToNotes(resultSet: relationalStore.ResultSet): Note[] {
    let result: Note[] = [];
    while (resultSet.goToNextRow()) {
      const isTodoVal = resultSet.getLong(resultSet.getColumnIndex('isTodo'));
      const todoStatus = this.readTodoStatus(resultSet, isTodoVal);

      // 注意：如果有的记录在修改表之前插入的，可能没用到 userId，处理一下异常
      let uId = '';
      try {
        uId = resultSet.getString(resultSet.getColumnIndex('userId'));
      } catch (e) {}

      result.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        userId: uId,
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        imagePath: resultSet.getString(resultSet.getColumnIndex('imagePath')),
        tags: resultSet.getString(resultSet.getColumnIndex('tags')),
        createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
        isTodo: isTodoVal,
        todoStatus: todoStatus
      });
    }
    resultSet.close();
    return result;
  }

  private async ensureUserIdColumn(): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN userId TEXT DEFAULT ''`
      );
    } catch (err) {
      console.info('RDB_LOG: userId column already exists');
    }
  }

  private async ensureTodoStatusColumn(): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(
        `ALTER TABLE ${CommonConstants.TABLE_NOTES} ADD COLUMN todoStatus TEXT DEFAULT '${TodoVisualStatus.PENDING}'`
      );
    } catch (err) {
      console.info('RDB_LOG: todoStatus column already exists');
    }
  }

  private async syncLegacyTodoStatus(): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(
        `UPDATE ${CommonConstants.TABLE_NOTES} SET todoStatus = '${TodoVisualStatus.COMPLETED}' WHERE isTodo = 0`
      );
    } catch (err) {
      console.info('RDB_LOG: sync legacy todo status skipped');
    }
  }

  private readTodoStatus(resultSet: relationalStore.ResultSet, isTodoVal: number): TodoVisualStatus {
    try {
      const statusIndex = resultSet.getColumnIndex('todoStatus');
      if (statusIndex >= 0) {
        const value = resultSet.getString(statusIndex);
        switch (value) {
          case TodoVisualStatus.COMPLETED:
            return TodoVisualStatus.COMPLETED;
          case TodoVisualStatus.DEFERRED:
            return TodoVisualStatus.DEFERRED;
          case TodoVisualStatus.PENDING:
            return TodoVisualStatus.PENDING;
          default:
            break;
        }
      }
    } catch (err) {
      console.info('RDB_LOG: fallback to legacy todo status');
    }
    return isTodoVal === 0 ? TodoVisualStatus.COMPLETED : TodoVisualStatus.PENDING;
  }

  /* ==================== 待办操作 (Todo CRUD) ==================== */

  async insertTodo(todo: Todo) {
    if (!this.store) return;
    const valueBucket: relationalStore.ValuesBucket = {
      'id': todo.id,
      'noteId': todo.noteId,
      'status': todo.status,
      'deadline': todo.deadline,
      'priority': todo.priority
    };
    return await this.store.insert(CommonConstants.TABLE_TODOS, valueBucket);
  }

  async queryTodoByNoteId(noteId: string): Promise<Todo | null> {
    if (!this.store) return null;
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_TODOS);
    predicates.equalTo('noteId', noteId);
    let resultSet = await this.store.query(predicates);
    if (resultSet.goToFirstRow()) {
      const res: Todo = {
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        noteId: resultSet.getString(resultSet.getColumnIndex('noteId')),
        status: resultSet.getLong(resultSet.getColumnIndex('status')) as TodoStatus,
        deadline: resultSet.getLong(resultSet.getColumnIndex('deadline')),
        priority: resultSet.getLong(resultSet.getColumnIndex('priority'))
      };
      resultSet.close();
      return res;
    }
    resultSet.close();
    return null;
  }
}
