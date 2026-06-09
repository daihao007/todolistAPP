# 技术架构

## 分层架构

```
┌─────────────────────────────────────────────┐
│                   Pages (页面层)              │
│   LoginPage, Index, NoteEditPage, etc.       │
├─────────────────────────────────────────────┤
│              Components (组件层)              │
│   NoteCard, TagChip, TodoStatusSwitch, etc.  │
├─────────────────────────────────────────────┤
│             ViewModel (视图模型层)            │
│   NoteViewModel, UserViewModel               │
├─────────────────────────────────────────────┤
│               Service (业务服务层)            │
│   NoteService, ImageService                  │
├─────────────────────────────────────────────┤
│             Native (C++ / NAPI)              │
│   text_analyzer, crypto_utils                │
├─────────────────────────────────────────────┤
│              Database (数据访问层)            │
│   RdbStoreManager, PreferenceUtil            │
├─────────────────────────────────────────────┤
│                Model (数据模型层)             │
│   Note, Todo, Tag                            │
└─────────────────────────────────────────────┘
```

## 数据流

```
用户操作 → Page → ViewModel → Service → Database
                ↓
           UI 状态更新 ← 数据返回
```

### 典型流程：新建笔记

1. 用户在 `NoteEditPage` 输入内容
2. 点击保存 → 调用 `NoteService.createNote()`
3. `NoteService` 调用本地 AI 分析 → 提取标签/摘要/行动项
4. `NoteService` 调用云端 AI 分析（失败则回退本地）
5. `NoteService` 调用 `RdbStoreManager.insertNote()` 写入数据库
6. 返回 `Index` 页面，`NoteViewModel` 重新加载列表

### 典型流程：用户登录

1. 用户在 `LoginPage` 输入账号和密码
2. `UserViewModel.login()` 从 Preferences 读取账号记录
3. 若记录为 `hash:salt`，调用 `NativeCrypto.verifyPassword()` 进入 C++ 侧重新计算 SHA-256 并比较
4. 若记录为旧版明文且密码正确，生成新盐值和哈希并重写为 `hash:salt`
5. 验证成功后写入 `CURRENT_USER`，跳转 `Index`

## 模块职责

| 层 | 职责 | 可调用 |
|----|------|--------|
| Page | UI 渲染、用户交互、状态管理 | ViewModel, Service |
| Component | 可复用 UI 片段 | 无（纯展示） |
| ViewModel | 数据转换、视图状态管理 | Service |
| Service | 业务逻辑、AI 调用 | Database |
| Native | C++ 核心算法，通过 NAPI 被 ArkTS 调用 | 无 |
| Database | 数据持久化、SQL 操作 | 无 |
| Model | 数据结构定义 | 无 |

## 关键设计决策

1. **用户数据隔离**: 通过 `userId` 字段过滤，多用户数据互不可见
2. **AI 双轨策略**: 本地 AI（基于规则）+ 云端 AI（通义千问），云端失败自动回退
3. **数据库迁移**: 使用 `ALTER TABLE` 增量迁移，避免破坏性升级
4. **单例模式**: `RdbStoreManager` 采用单例，确保数据库连接唯一
5. **Native 安全增强**: 用户密码不明文落盘，使用 C++ SHA-256 + 随机盐值，通过 NAPI 提供给 ArkTS 调用
