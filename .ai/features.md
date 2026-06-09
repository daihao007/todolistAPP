# 功能清单

## 已实现功能

### 1. 用户系统

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 账号注册 | `UserViewModel.register()` | 账号 + 昵称 + 密码，存储在 Preferences |
| 账号登录 | `UserViewModel.login()` | 验证账号密码 |
| 昵称显示 | `Index.ets` | 首页显示当前用户昵称 |
| 昵称编辑 | `Index.ets` | 点击昵称可在线编辑 |
| 登出 | `Index.ets` | 清除当前用户状态 |
| 多用户隔离 | `RdbStoreManager` | 按 userId 过滤笔记数据 |

### 2. 笔记管理

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 新建笔记 | `NoteEditPage.ets` | 标题、正文、图片、标签 |
| 编辑笔记 | `NoteEditPage.ets` | 加载已有笔记数据 |
| 删除笔记 | `NoteEditPage.ets` | 删除笔记及关联待办 |
| 笔记列表 | `Index.ets` Tab1 | 卡片式展示，按创建时间倒序 |
| 卡片预览 | `NoteEditPage.ets` | 编辑时实时预览卡片效果 |

### 3. 待办事项

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 从笔记创建待办 | `NoteEditPage.ets` | 保存时基于 AI 行动项生成待办 |
| 三态管理 | `TodoStatusSwitch.ets` | 待处理 / 已完成 / 已延期 |
| Checkbox 切换 | `NoteCard.ets` | 快速切换完成状态 |
| 删除线效果 | `NoteCard.ets` | 已完成标题显示删除线 |
| 待办列表 | `Index.ets` Tab2 | 独立 Tab 展示待办 |
| 新建待办 | `TodoDetailPage.ets` | 专用待办创建页面 |
| 编辑待办 | `TodoDetailPage.ets` | 修改待办内容和状态 |

### 4. AI 智能功能

#### 本地 AI (基于规则)

| 功能 | 实现位置 | 算法 |
|------|----------|------|
| 标签提取 | `NoteService.generateLocalAiSuggestion()` | 关键词匹配 9 个预设类别 |
| 关键词提取 | 同上 | 词频统计，取 top 5 |
| 摘要生成 | 同上 | 句子评分算法 (关键词命中 + 摘要提示词 + 句长) |
| 行动项提取 | 同上 | 检测 13 个动作动词 |
| 待办状态推断 | 同上 | 检测 "待办/任务/计划/完成" 关键词 |
| 优先级推断 | 同上 | 检测 "紧急/马上/立即/今天/明天" 关键词 |

#### 云端 AI (通义千问)

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 云端分析 | `NoteService.requestCloudAiReview()` | 调用阿里云 DashScope API |
| 结构化 Prompt | 同上 | 要求返回 JSON 格式的摘要/关键词/行动项/标签 |
| 多格式解析 | 同上 | 支持直接 JSON、嵌套 data、OpenAI choices 格式 |
| 自动回退 | 同上 | 云端失败时使用本地 AI 结果 |

### 5. 搜索与筛选

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 关键字搜索 | `SearchResultPage.ets` | 模糊匹配标题和内容 |
| 日期范围筛选 | 同上 | 支持 10+ 种日期格式 |
| 快捷日期按钮 | 同上 | 今天、近 7 天 |
| 标签多选筛选 | 同上 | 全部/工作/学习/生活 |
| 自定义标签搜索 | 同上 | 输入自定义标签筛选 |
| 搜索中操作 | 同上 | 搜索结果中可直接操作待办状态 |

### 6. 图片功能

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 选择图片 | `ImageService.ets` | PhotoViewPicker 选择单张图片 |
| 图片预览 | `NoteCard.ets`, `NoteEditPage.ets` | 卡片和编辑页展示图片 |
| 清除图片 | `NoteEditPage.ets` | 可清除已选图片 |
| 权限申请 | `ImageService.ets` | 运行时申请 READ_IMAGEVIDEO |

### 7. 标签系统

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| 预设标签 | `Constants.ets` | 工作、学习、生活 |
| 自定义标签 | `NoteEditPage.ets` | 用户输入自定义标签 |
| 标签多选 | `TagChip.ets` | 选中/取消选择 |
| AI 推荐标签 | `NoteEditPage.ets` | AI 生成的标签可编辑 |
| 标签颜色 | `TagChip.ets` | 工作=冰蓝、学习=香芋紫、生活=芝士黄 |

### 8. 数据持久化

| 功能 | 实现位置 | 说明 |
|------|----------|------|
| RDB 存储 | `RdbStoreManager.ets` | notes 和 todos 两张表 |
| 偏好存储 | `PreferenceUtil.ets` | 用户信息存储 |
| 增量迁移 | `RdbStoreManager.ets` | ALTER TABLE 添加新列 |
| 备份恢复 | `EntryBackupAbility.ets` | 应用数据备份能力 |

---

## 空实现文件 (待补充)

| 文件 | 当前状态 | 建议用途 |
|------|----------|----------|
| `model/Tag.ets` | 空文件 | 定义 Tag 接口 (id, name, color, userId) |
| `service/TagService.ets` | 空文件 | 标签 CRUD 逻辑、标签统计 |
| `service/TodoService.ets` | 空文件 | 待办 CRUD 逻辑 (从 NoteService 拆分) |
| `viewmodel/TodoViewModel.ets` | 空文件 | 待办列表数据转换、筛选逻辑 |
| `viewmodel/SearchViewModel.ets` | 空文件 | 搜索状态管理、筛选条件组合 |

---

## 建议后续开发方向

### 高优先级

1. **重构待办逻辑** - 将 NoteService 中的待办逻辑迁移到 TodoService，使架构清晰
2. **实现 TagService** - 独立管理标签的增删改查，支持自定义标签持久化
3. **深浅色主题切换** - 资源已定义，需在页面中实现动态切换

### 中优先级

4. **数据统计** - 待办完成率、标签分布、活跃度图表
5. **笔记导出** - 导出为 Markdown/文本/图片
6. **提醒通知** - 已延期待办的系统通知

### 低优先级

7. **云同步** - 接入云端存储实现跨设备同步
8. **用户系统增强** - 密码加密、账号找回
9. **笔记分享** - 分享到其他应用
10. **批量操作** - 批量删除、批量标签
