import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';
import { Note } from '../model/Note';
import { Todo, TodoStatus } from '../model/Todo';
import { CommonConstants } from '../common/Constants';

export class RdbStoreManager {
  private store: relationalStore.RdbStore | null = null;
  private context: common.Context;

  constructor(context: common.Context) {
    this.context = context;
  }

  /**
   * 初始化数据库：自动化建表逻辑
   */
  async initDb() {
    const config: relationalStore.StoreConfig = {
      name: CommonConstants.RDB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };

    // 动态拼接 SQL，确保表名来自 Constants
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

  /* ==================== 笔记操作 (给同学 B/E) ==================== */

  async insertNote(note: Note) {
    if (!this.store) return;

    // 关键修复：手动构建 ValuesBucket
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
    predicates.orderByDesc('createTime'); // 最新的笔记排前面

    let resultSet = await this.store.query(predicates);
    let result: Note[] = [];
    while (resultSet.goToNextRow()) {
      result.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        imagePath: resultSet.getString(resultSet.getColumnIndex('imagePath')),
        tags: resultSet.getString(resultSet.getColumnIndex('tags')),
        createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
        isTodo: resultSet.getLong(resultSet.getColumnIndex('isTodo'))
      });
    }
    resultSet.close();
    return result;
  }

  /* ==================== 待办操作 (给同学 C/E) ==================== */

  async insertTodo(todo: Todo) {
    if (!this.store) return;

    // 手动构建一个 ValuesBucket 对象，确保键名和数据库表里的列名完全一致
    const valueBucket: relationalStore.ValuesBucket = {
      'id': todo.id,
      'noteId': todo.noteId,
      'status': todo.status,
      'deadline': todo.deadline,
      'priority': todo.priority
    };

    return await this.store.insert(CommonConstants.TABLE_TODOS, valueBucket);
  }

  /**
   * 根据笔记ID获取关联待办（用于详情页显示）
   */
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
  /**
   * 模糊搜索：根据标题或内容搜索笔记
   * 对应任务：让笔记能被搜到
   */
  async searchNotes(keyword: string): Promise<Note[]> {
    if (!this.store || !keyword) return this.queryAllNotes();

    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    // 使用 contains 实现 SQL 的 LIKE %keyword% 效果
    predicates.contains('title', keyword)
      .or()
      .contains('content', keyword)
      .orderByDesc('createTime');

    let resultSet = await this.store.query(predicates);
    let result: Note[] = [];
    while (resultSet.goToNextRow()) {
      result.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        content: resultSet.getString(resultSet.getColumnIndex('content')),
        imagePath: resultSet.getString(resultSet.getColumnIndex('imagePath')),
        tags: resultSet.getString(resultSet.getColumnIndex('tags')),
        createTime: resultSet.getLong(resultSet.getColumnIndex('createTime')),
        isTodo: resultSet.getLong(resultSet.getColumnIndex('isTodo'))
      });
    }
    resultSet.close();
    return result;
  }

  /**
   * 更新待办状态：勾选/取消勾选
   * 对应任务：让待办能被勾选，触发 UI 刷新
   */
  async updateTodoStatus(id: string, newStatus: number) {
    if (!this.store) return;

    const valueBucket: relationalStore.ValuesBucket = {
      'status': newStatus
    };

    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_TODOS);
    predicates.equalTo('id', id);

    return await this.store.update(valueBucket, predicates);
  }
  /**
   * 专门为搜索页/首页提供的笔记勾选状态更新
   * @param noteId 笔记的ID
   * @param isDone 是否勾选完成
   */
  async updateNoteCompleteStatus(noteId: string, isDone: boolean) {
    if (!this.store) return;

    const valueBucket: relationalStore.ValuesBucket = {
      // 根据你的 NoteCard 逻辑：1 是待办(PENDING)，0 是完成(COMPLETED)
      'isTodo': isDone ? 0 : 1
    };

    let predicates = new relationalStore.RdbPredicates(CommonConstants.TABLE_NOTES);
    predicates.equalTo('id', noteId);

    return await this.store.update(valueBucket, predicates);
  }
}