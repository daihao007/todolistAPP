# UI 组件与页面结构

## 设计规范

### 色彩方案 (暖色奶油风)

| 色名 | 色值 | 用途 |
|------|------|------|
| 奶泡白 | #FFF8F0 | 主背景 |
| 樱花奶冻粉 | #FFD6E0 | 强调色、按钮 |
| 香芋奶紫 | #D4A5FF | 标签 (学习) |
| 芝士黄 | #FFE4A0 | 标签 (生活) |
| 冰蓝 | #A0E7FF | 标签 (工作) |
| 薄荷绿 | #A0FFD6 | 成功状态 |

> 完整色彩定义在 `common/Constants.ets` 的 `UiPalette` 中

### UI 尺寸常量

定义在 `common/Constants.ets` 的 `UiConstants` 中：
- 圆角、间距、字号等统一管理

---

## 可复用组件 (components/)

### NoteCard.ets

**用途**: 笔记/待办卡片展示

**功能**:
- 展示标题、内容摘要、标签、日期、图片
- 待办状态胶囊显示
- Checkbox 勾选切换待办完成状态
- 三态状态切换按钮 (待处理/已完成/已延期)
- 已完成标题显示删除线
- 图片展示

**接口**:
```typescript
@Component
struct NoteCard {
  note: NoteCardViewData
  onStatusChange?: (noteId: number, status: number) => void
  onTodoStatusChange?: (noteId: number, status: TodoVisualStatus) => void
  onClick?: (noteId: number) => void
}
```

### TagChip.ets

**用途**: 标签胶囊组件

**功能**:
- 选中/未选中态切换
- 自定义颜色
- 点击事件

**接口**:
```typescript
@Component
struct TagChip {
  label: string
  selected: boolean
  color?: ResourceColor
  onClick?: () => void
}
```

### TodoStatusSwitch.ets

**用途**: 待办状态切换组件

**功能**:
- 展示三个状态选项 (待处理/已完成/已延期)
- @Link 双向绑定状态值

**接口**:
```typescript
@Component
struct TodoStatusSwitch {
  @Link status: TodoVisualStatus
}
```

### CommonEmptyView.ets

**用途**: 空状态视图

**功能**:
- 列表为空时显示提示文案
- 可自定义提示文字

**接口**:
```typescript
@Component
struct CommonEmptyView {
  message?: string
}
```

---

## 页面结构 (pages/)

### LoginPage.ets

**路由**: `pages/LoginPage`
**功能**: 应用首屏，用户登录

**UI 结构**:
```
┌─────────────────────┐
│     品牌 Logo 区      │
│                     │
│   ┌───────────────┐ │
│   │   账号输入框   │ │
│   └───────────────┘ │
│   ┌───────────────┐ │
│   │   密码输入框   │ │
│   └───────────────┘ │
│                     │
│   ┌───────────────┐ │
│   │    登录按钮    │ │
│   └───────────────┘ │
│                     │
│   没有账号？去注册    │
└─────────────────────┘
```

### RegisterPage.ets

**路由**: `pages/RegisterPage`
**功能**: 用户注册

**UI 结构**:
```
┌─────────────────────┐
│     注册新账号       │
│                     │
│   ┌───────────────┐ │
│   │   账号输入框   │ │
│   └───────────────┘ │
│   ┌───────────────┐ │
│   │   昵称输入框   │ │
│   └───────────────┘ │
│   ┌───────────────┐ │
│   │   密码输入框   │ │
│   └───────────────┘ │
│                     │
│   ┌───────────────┐ │
│   │    注册按钮    │ │
│   └───────────────┘ │
└─────────────────────┘
```

### Index.ets

**路由**: `pages/Index`
**功能**: 首页，双 Tab 布局

**UI 结构**:
```
┌─────────────────────┐
│ 用户昵称    [编辑][登出] │
├─────────────────────┤
│  [我的笔记] [待办事项]  │
├─────────────────────┤
│ [搜索框] [日期] [标签]  │
├─────────────────────┤
│                     │
│   ┌───────────────┐ │
│   │   NoteCard    │ │
│   └───────────────┘ │
│   ┌───────────────┐ │
│   │   NoteCard    │ │
│   └───────────────┘ │
│         ...         │
│                     │
│              [+] FAB│
└─────────────────────┘
```

### NoteEditPage.ets

**路由**: `pages/NoteEditPage`
**功能**: 笔记编辑

**参数**: `noteId` (可选，编辑已有笔记)

**UI 结构**:
```
┌─────────────────────┐
│ [返回]  笔记编辑  [删除] │
├─────────────────────┤
│ ┌───────────────┐   │
│ │   标题输入框   │   │
│ └───────────────┘   │
│ ┌───────────────┐   │
│ │               │   │
│ │   正文输入框   │   │
│ │               │   │
│ └───────────────┘   │
│                     │
│ [AI 整理] [选择图片]  │
│                     │
│ AI 推荐标签:         │
│ [工作] [学习] [生活]  │
│ 标签输入框: ________ │
│                     │
│ 关键词: xxx, xxx     │
│ 摘要: xxxxxxxxxx     │
│ 行动项: xxxxxxxxxx   │
│                     │
│ ┌───────────────┐   │
│ │   卡片预览    │   │
│ └───────────────┘   │
│                     │
│   ┌───────────────┐ │
│   │    保存按钮    │ │
│   └───────────────┘ │
└─────────────────────┘
```

### TodoDetailPage.ets

**路由**: `pages/TodoDetailPage`
**功能**: 待办详情编辑

**参数**: `noteId` (可选，编辑已有待办)

**UI 结构**: 与 NoteEditPage 类似，增加待办状态切换组件

### SearchResultPage.ets

**路由**: `pages/SearchResultPage`
**功能**: 搜索结果

**UI 结构**:
```
┌─────────────────────┐
│ [返回]    搜索       │
├─────────────────────┤
│ ┌───────────────┐   │
│ │   搜索输入框   │   │
│ └───────────────┘   │
│                     │
│ [今天] [近7天]       │
│ [日期范围选择器]      │
│                     │
│ [全部] [工作] [学习]  │
│ [生活] [自定义标签]   │
├─────────────────────┤
│                     │
│   ┌───────────────┐ │
│   │   NoteCard    │ │
│   └───────────────┘ │
│         ...         │
└─────────────────────┘
```

### TestSearchPage.ets

**路由**: `pages/TestSearchPage`
**功能**: 测试页面，用于数据库操作测试

---

## 页面路由配置

文件位置: `entry/src/main/resources/base/profile/main_pages.json`

```json
{
  "src": [
    "pages/LoginPage",
    "pages/RegisterPage",
    "pages/Index",
    "pages/NoteEditPage",
    "pages/TestSearchPage",
    "pages/SearchResultPage",
    "pages/TodoDetailPage"
  ]
}
```

## 页面间导航

| 来源 | 目标 | 触发方式 | 参数 |
|------|------|----------|------|
| LoginPage | Index | 登录成功 | - |
| LoginPage | RegisterPage | 点击注册 | - |
| RegisterPage | LoginPage | 注册成功 | - |
| Index | NoteEditPage | 点击卡片/FAB | noteId (可选) |
| Index | TodoDetailPage | 点击 FAB (待办 Tab) | - |
| Index | SearchResultPage | 点击搜索 | keyword |
| NoteEditPage | Index | 保存成功 | - |
| TodoDetailPage | Index | 保存成功 | - |
| SearchResultPage | NoteEditPage | 点击卡片 | noteId |
