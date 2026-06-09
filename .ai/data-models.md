# 数据模型

## 数据库配置

- **数据库名**: `InspirationNote.db`
- **存储方式**: `@ohos.data.relationalStore` (RDB)
- **用户隔离**: 通过 `userId` 字段过滤

## 表结构

### notes 表 (笔记/待办)

| 列名 | 类型 | 说明 |
|------|------|------|
| `id` | INTEGER | 主键，自增 |
| `userId` | TEXT | 用户 ID，用于多用户隔离 |
| `title` | TEXT | 标题 |
| `content` | TEXT | 正文内容 |
| `imagePath` | TEXT | 图片路径 |
| `tags` | TEXT | 用户标签，逗号分隔 |
| `aiTags` | TEXT | AI 推荐标签，逗号分隔 |
| `summary` | TEXT | AI 生成摘要 |
| `actionItems` | TEXT | AI 提取的行动项 |
| `priority` | INTEGER | 优先级 (AI 推断) |
| `createTime` | TEXT | 创建时间，格式 yyyy-MM-dd HH:mm |
| `isTodo` | INTEGER | 是否为待办 (0=否, 1=是) |
| `todoStatus` | INTEGER | 待办状态 (0=默认, 1=已完成, 2=已延期) |

**注意**: 笔记和待办共用 notes 表，通过 `isTodo` 字段区分。

### todos 表 (待办详情)

| 列名 | 类型 | 说明 |
|------|------|------|
| `id` | INTEGER | 主键，自增 |
| `noteId` | INTEGER | 关联的笔记 ID |
| `status` | INTEGER | 状态 (0=默认, 1=已完成, 2=已归档) |
| `deadline` | TEXT | 截止日期 |
| `priority` | INTEGER | 优先级 |

---

## 数据模型接口

### Note 接口

```typescript
interface Note {
  id: number
  userId: string
  title: string
  content: string
  imagePath: string
  tags: string           // 逗号分隔，如 "工作,学习"
  aiTags: string         // AI 推荐标签
  summary: string        // AI 摘要
  actionItems: string    // AI 行动项
  priority: number       // 优先级
  createTime: string     // yyyy-MM-dd HH:mm
  isTodo: number         // 0=笔记, 1=待办
  todoStatus: number     // 0=默认, 1=已完成, 2=已延期
}
```

### Todo 接口

```typescript
interface Todo {
  id: number
  noteId: number
  status: number      // TodoStatus 枚举
  deadline: string
  priority: number
}
```

### TodoStatus 枚举

```typescript
enum TodoStatus {
  DEFAULT = 0,     // 待处理
  DONE = 1,        // 已完成
  ARCHIVED = 2     // 已归档
}
```

### TodoVisualStatus 枚举 (UI 展示用)

```typescript
enum TodoVisualStatus {
  NONE = 'none',             // 无状态
  PENDING = 'pending',       // 待处理
  COMPLETED = 'completed',   // 已完成
  OVERDUE = 'overdue'        // 已延期
}
```

### NoteCardViewData (卡片视图数据)

```typescript
class NoteCardViewData {
  id: number
  title: string
  content: string
  imagePath: string
  tags: string[]
  aiTags: string[]
  summary: string
  actionItems: string
  priority: number
  createTime: string       // 格式化后的日期
  relativeTime: string     // 相对时间，如 "3 小时前"
  isTodo: boolean
  todoStatus: TodoVisualStatus
}
```

---

## 数据库操作 (RdbStoreManager)

### 笔记操作

| 方法 | 说明 |
|------|------|
| `insertNote(note)` | 插入新笔记 |
| `updateNote(note)` | 更新笔记 |
| `queryNoteById(id)` | 根据 ID 查询 |
| `queryAllNotes(userId)` | 查询用户所有笔记 |
| `searchNotes(keyword, userId)` | 按关键字模糊搜索 |
| `deleteNote(id)` | 删除笔记 (级联删除 todos) |

### 待办状态操作

| 方法 | 说明 |
|------|------|
| `updateNoteCompleteStatus(noteId, status)` | 更新待办完成状态 |
| `updateNoteTodoStatus(noteId, isTodo, status)` | 同步更新 isTodo 和 todoStatus |

---

## 偏好存储 (PreferenceUtil)

| Key | 类型 | 说明 |
|-----|------|------|
| `user_{account}_password` | string | 用户密码 |
| `user_{account}_nickname` | string | 用户昵称 |
| `current_user` | string | 当前登录用户账号 |
