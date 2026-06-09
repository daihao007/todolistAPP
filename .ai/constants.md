# 常量定义

文件位置: `entry/src/main/ets/common/Constants.ets`

## CommonConstants (通用常量)

### 数据库配置

| 常量 | 值 | 说明 |
|------|-----|------|
| `DB_NAME` | `InspirationNote.db` | 数据库名称 |
| `TABLE_NOTES` | `notes` | 笔记表名 |
| `TABLE_TODOS` | `todos` | 待办表名 |

### 列名

| 常量 | 值 |
|------|-----|
| `COL_ID` | `id` |
| `COL_USER_ID` | `userId` |
| `COL_TITLE` | `title` |
| `COL_CONTENT` | `content` |
| `COL_IMAGE_PATH` | `imagePath` |
| `COL_TAGS` | `tags` |
| `COL_AI_TAGS` | `aiTags` |
| `COL_SUMMARY` | `summary` |
| `COL_ACTION_ITEMS` | `actionItems` |
| `COL_PRIORITY` | `priority` |
| `COL_CREATE_TIME` | `createTime` |
| `COL_IS_TODO` | `isTodo` |
| `COL_TODO_STATUS` | `todoStatus` |
| `COL_NOTE_ID` | `noteId` |
| `COL_STATUS` | `status` |
| `COL_DEADLINE` | `deadline` |

### 页面路由

| 常量 | 值 |
|------|-----|
| `LOGIN_PAGE` | `pages/LoginPage` |
| `REGISTER_PAGE` | `pages/RegisterPage` |
| `INDEX_PAGE` | `pages/Index` |
| `NOTE_EDIT_PAGE` | `pages/NoteEditPage` |
| `TODO_DETAIL_PAGE` | `pages/TodoDetailPage` |
| `SEARCH_RESULT_PAGE` | `pages/SearchResultPage` |
| `TEST_SEARCH_PAGE` | `pages/TestSearchPage` |

### 默认标签

| 常量 | 值 |
|------|-----|
| `DEFAULT_TAG_1` | `工作` |
| `DEFAULT_TAG_2` | `学习` |
| `DEFAULT_TAG_3` | `生活` |

### AI API 配置

| 常量 | 值 | 说明 |
|------|-----|------|
| `CLOUD_AI_API_URL` | `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions` | 通义千问 API 地址 |
| `CLOUD_AI_API_KEY` | (密钥) | API Key |
| `CLOUD_AI_MODEL` | `qwen3.5-122b-a10b` | 模型名称 |

---

## TodoVisualStatus 枚举

```typescript
enum TodoVisualStatus {
  NONE = 'none',             // 无状态
  PENDING = 'pending',       // 待处理
  COMPLETED = 'completed',   // 已完成
  OVERDUE = 'overdue'        // 已延期
}
```

---

## UiConstants (UI 尺寸常量)

定义 UI 相关的尺寸、圆角、间距、字号等常量。

---

## UiPalette (色彩方案)

### 主色调

| 色名 | 色值 | 用途 |
|------|------|------|
| CreamWhite | #FFF8F0 | 主背景 |
| PinkMilk | #FFD6E0 | 强调色 |
| TaroPurple | #D4A5FF | 标签 (学习) |
| CheeseYellow | #FFE4A0 | 标签 (生活) |
| IceBlue | #A0E7FF | 标签 (工作) |
| MintGreen | #A0FFD6 | 成功状态 |

### 状态色

| 状态 | 色值 |
|------|------|
| 待处理 | 蓝色调 |
| 已完成 | 绿色调 |
| 已延期 | 红色调 |

---

## UiCopywriting (文案常量)

定义应用中使用的提示文案、空状态文案等。

---

## 图标资源

### 浅色主题 (common/ModeLight*.ets)

- 聊天图标
- 播放图标
- 日历图标
- 勾选图标
- 发送图标
- 加号图标
- 搜索图标

### 深色主题 (common/ModeDark*.ets)

与浅色主题对应的深色版本图标。

> 所有图标以 SVG 路径数据形式存储，可在 ArkUI 中通过 Shape/Path 组件渲染。
