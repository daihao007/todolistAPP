# 文件结构与功能说明

## 项目根目录

```
todolistAPP/
├── AppScope/                          # 应用级配置
├── entry/                             # 主模块
├── build-profile.json5                # 项目构建配置
├── oh-package.json5                   # 项目包描述
├── code-linter.json5                  # 代码检查配置
└── hvigor/                            # 构建工具缓存
```

## Native 源码目录 (entry/src/main/cpp/)

| 文件 | 功能 | 状态 |
|------|------|------|
| `CMakeLists.txt` | 构建 `text_analyzer` 共享库，合并编译文本分析和密码加密 Native 代码 | 已实现 |
| `text_analyzer.cpp` | Native 文本分析模块，提供关键词提取和句子评分能力 | 已实现 |
| `crypto_utils.cpp` | Native 密码加密模块，提供 SHA-256 哈希、随机盐值生成、密码验证 | 已实现 |
| `napi_init.cpp` | NAPI 注册入口，暴露 `extractKeywords`、`scoreSentences`、`hashPassword`、`generateSalt`、`verifyPassword` | 已实现 |

## ArkTS 源代码目录 (entry/src/main/ets/)

### 入口与生命周期

| 文件 | 功能 |
|------|------|
| `entryability/EntryAbility.ets` | 应用主入口 UIAbility，初始化数据库，加载首屏 LoginPage |
| `entrybackupability/EntryBackupAbility.ets` | 备份扩展能力，支持应用数据备份与恢复 |

### 数据模型层 (model/)

| 文件 | 功能 | 状态 |
|------|------|------|
| `model/Note.ets` | 笔记数据模型，包含 id、userId、title、content、imagePath、tags、aiTags、summary、actionItems、priority、createTime、isTodo、todoStatus | 已实现 |
| `model/Todo.ets` | 待办数据模型，包含 id、noteId、status、deadline、priority；TodoStatus 枚举 (DEFAULT=0, DONE=1, ARCHIVED=2) | 已实现 |
| `model/Tag.ets` | 标签模型 | 空文件 |

### 常量与主题 (common/)

| 文件 | 功能 |
|------|------|
| `common/Constants.ets` | 核心常量：数据库名、表名、列名、路由、默认标签、AI API 配置、UI 尺寸、色彩方案、文案 |
| `common/ModeDark*.ets` | 深色主题图标资源 (SVG 路径数据) |
| `common/ModeLight*.ets` | 浅色主题图标资源 (SVG 路径数据) |
| `common/Country*.ets` | 国家/地区图标资源 |

### 数据库层 (database/)

| 文件 | 功能 |
|------|------|
| `database/RdbStoreManager.ets` | 关系型数据库管理器 (单例)，创建 notes/todos 表，支持增量迁移，提供完整 CRUD |
| `database/PreferenceUtil.ets` | 偏好设置工具，存取字符串和布尔值 |

### 服务层 (service/)

| 文件 | 功能 | 状态 |
|------|------|------|
| `service/NoteService.ets` | 笔记业务核心服务，包含笔记 CRUD、本地 AI 分析、云端 AI 调用 | 已实现 |
| `service/ImageService.ets` | 图片选择服务，通过 PhotoViewPicker 选择图片，处理权限申请 | 已实现 |
| `service/TagService.ets` | 标签服务 | 空文件 |
| `service/TodoService.ets` | 待办服务 | 空文件 |

### 视图模型层 (viewmodel/)

| 文件 | 功能 | 状态 |
|------|------|------|
| `viewmodel/NoteViewModel.ets` | 笔记视图模型，加载笔记列表并转换为卡片视图数据 | 已实现 |
| `viewmodel/UserViewModel.ets` | 用户视图模型，注册/登录逻辑；注册时存储 `hash:salt`，登录时调用 NativeCrypto 验证，旧明文账号自动迁移 | 已实现 |
| `viewmodel/TodoViewModel.ets` | 待办视图模型 | 空文件 |
| `viewmodel/SearchViewModel.ets` | 搜索视图模型 | 空文件 |

### 工具类 (utils/)

| 文件 | 功能 |
|------|------|
| `utils/DateUtil.ets` | 日期格式化：formatDate (yyyy-MM-dd)、formatTime (yyyy-MM-dd HH:mm)、getRelativeTime (相对时间) |
| `utils/Logger.ets` | 日志工具，封装 hilog，支持 info/error 级别 |
| `utils/PermissionUtil.ets` | 权限申请工具，封装 requestPermissionsFromUser |
| `utils/PreferenceUtil.ets` | 偏好设置工具 (utils 目录版本) |
| `utils/HttpUtil.ets` | HTTP 请求工具，支持 GET/POST JSON，Authorization 头，60 秒超时 |
| `utils/NativeCrypto.ets` | Native 密码加密封装，调用 `libtext_analyzer.so` 中的 `hashPassword`、`generateSalt`、`verifyPassword` |

### UI 组件 (components/)

| 文件 | 功能 |
|------|------|
| `components/NoteCard.ets` | 笔记卡片组件，展示标题、摘要、标签、日期、图片、待办状态；支持 Checkbox、三态切换、删除线 |
| `components/TagChip.ets` | 标签胶囊组件，选中/未选中态切换，自定义颜色 |
| `components/TodoStatusSwitch.ets` | 待办状态切换组件，@Link 双向绑定，三态选项 |
| `components/CommonEmptyView.ets` | 空状态视图组件，列表为空时显示提示 |

### 页面 (pages/)

| 文件 | 功能 |
|------|------|
| `pages/LoginPage.ets` | 登录页，品牌 Logo、账号密码输入、登录按钮、注册入口 |
| `pages/RegisterPage.ets` | 注册页，账号、昵称、密码输入 |
| `pages/Index.ets` | 首页，双 Tab 布局 (我的笔记 + 待办事项)，搜索、筛选、FAB 按钮 |
| `pages/NoteEditPage.ets` | 笔记编辑页，标题/正文输入、AI 整理、图片、标签、保存时生成待办 |
| `pages/TodoDetailPage.ets` | 待办详情页，标题/正文、AI 整理、图片、标签、待办状态切换 |
| `pages/SearchResultPage.ets` | 搜索结果页，关键字搜索、日期范围筛选、标签筛选 |
| `pages/TestSearchPage.ets` | 测试页，数据库操作测试 |

## 资源文件 (entry/src/main/resources/)

| 目录 | 内容 |
|------|------|
| `base/element/` | 颜色、字符串、尺寸定义 |
| `base/media/` | 图片资源 |
| `base/profile/` | 页面路由 (main_pages.json)、备份配置 |
| `dark/element/` | 深色主题颜色定义 |

## 页面路由

```json
[
  "pages/LoginPage",
  "pages/RegisterPage",
  "pages/Index",
  "pages/NoteEditPage",
  "pages/TestSearchPage",
  "pages/SearchResultPage",
  "pages/TodoDetailPage"
]
```
