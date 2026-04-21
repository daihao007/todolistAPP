/**
 * 待办状态枚举
 */
export enum TodoStatus {
  DEFAULT = 0, // 待完成
  DONE = 1,    // 已完成
  ARCHIVED = 2 // 已归档（可选）
}

/**
 * 待办数据模型
 */
export interface Todo {
  id: string;          // 待办唯一ID
  noteId: string;      // 关联的笔记ID (这是连接 Note 表和 Todo 表的关键)
  status: TodoStatus;  // 状态：0-未完成，1-已完成
  deadline: number;    // 截止时间戳（如果是0则表示没设置提醒）
  priority: number;    // 优先级：0-普通，1-紧急（给同学C留的扩展功能）
}

/**
 * 这里的假数据发给 C同学（待办/搜索组）和 D同学（视觉组）
 */
export const MockTodos: Todo[] = [
  {
    id: 't1',
    noteId: '1', // 对应 MockNotes 里的第一条
    status: TodoStatus.DEFAULT,
    deadline: Date.now() + 86400000, // 明天
    priority: 1
  },
  {
    id: 't2',
    noteId: '2',
    status: TodoStatus.DONE,
    deadline: 0,
    priority: 0
  }
]