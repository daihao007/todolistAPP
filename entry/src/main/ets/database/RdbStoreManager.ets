import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';
import { Note } from '../model/Note';
import { Todo, TodoStatus } from '../model/Todo';
import { CommonConstants, TodoVisualStatus } from '../common/Constants';

export class RdbStoreManager {
  // --- 1. 新增：静态私有实例变量 ---
  private static instance: RdbStoreManager | null = null;
  private store: relationalStore.RdbStore | null = null;
  private context: common.Context;

  // --- 2. 修改：将 constructor 设为私有，防止外部直接 new ---
  private constructor(context: common.Context) {
    this.context = context;
  }

  // --- 3. 新增：静态获取实例的方法（这就是你报错缺失的方法） ---
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
    // 如果已经初始化过了，直接返回，避免重复开启连接
    if (this.store !== null) return;

    const config: relationalStore.StoreConfig = {
      name: CommonConstants.RDB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };

    const sqlNotes = `CREATE TABLE IF NOT EXISTS ${CommonConstants.TABLE_NOTES} (
      id TEXT PRIMARY KEY,
      title TEXT,
      content TEXT,
      imagePath TEXT,
      tags TEXT,
      createTime INTEGER,
      isTodo INTEGER
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
      console.info('RDB_LOG: 数据库与所有表初始化成功');
    } catch (err) {
      console.error('RDB_LOG: 初始化失败', JSON.stringify(err));
    }
  }

  /* ==================== 笔记操作 ==================== */

  async insertNote(note: Note) {
    if (!this.store) return;
    const valueBucket: relationalStore.ValuesBucket = {
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'imagePath': note.imagePath,
      'tags': note.tags,
      'createTime': note.createTime,
      'isTodo': note.isTodo
    };
    return await this.store.insert(CommonConstants.TABLE_NOTES, valueBucket);
  }

  async queryAllNotes(): Promise<Note[]> {
    if (!this.store) return [];
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    predicates.orderByDesc('createTime');

    let resultSet = await this.store.query(predicates);
    let result: Note[] = [];
    while (resultSet.goToNextRow()) {
      const isTodoVal = resultSet.getLong(resultSet.getColumnIndex('isTodo'));
      result.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        imagePath: resultSet.getString(resultSet.getColumnIndex('imagePath')),
        tags: resultSet.getString(resultSet.getColumnIndex('tags')),
        createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
        isTodo: isTodoVal,
        todoStatus: isTodoVal === 1 ? TodoVisualStatus.PENDING : TodoVisualStatus.COMPLETED
      });
    }
    resultSet.close();
    return result;
  }

  // --- 追加搜索逻辑（SearchResultPage 需要） ---
  async searchNotes(keyword: string): Promise<Note[]> {
    if (!this.store) return [];
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    if (keyword) {
      predicates.contains('title', keyword).or().contains('content', keyword);
    }
    predicates.orderByDesc('createTime');

    let resultSet = await this.store.query(predicates);
    let result: Note[] = [];
    while (resultSet.goToNextRow()) {
      const isTodoVal = resultSet.getLong(resultSet.getColumnIndex('isTodo'));
      result.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        imagePath: resultSet.getString(resultSet.getColumnIndex('imagePath')),
        tags: resultSet.getString(resultSet.getColumnIndex('tags')),
        createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
        isTodo: isTodoVal,
        todoStatus: isTodoVal === 1 ? TodoVisualStatus.PENDING : TodoVisualStatus.COMPLETED
      });
    }
    resultSet.close();
    return result;
  }

  // --- 追加状态更新逻辑 ---
  async updateNoteCompleteStatus(noteId: string, isDone: boolean) {
    if (!this.store) return;
    const valueBucket: relationalStore.ValuesBucket = {
      'isTodo': isDone ? 0 : 1
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    predicates.equalTo('id', noteId);
    return await this.store.update(valueBucket, predicates);
  }

  /* ==================== 待办操作 ==================== */

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