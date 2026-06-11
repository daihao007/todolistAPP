# 实验报告技术章节

## 1. 系统概述

本项目是基于 HarmonyOS Stage 模型开发的灵感笔记与待办管理应用。应用采用 ArkTS 构建页面和业务逻辑，使用 RDB 持久化笔记与待办数据，通过 C++ NAPI 扩展补充关键词提取、摘要句子评分和密码哈希能力，并针对手机和平板做响应式布局适配。

## 2. 模块架构

### 2.1 页面层

页面层位于 `entry/src/main/ets/pages`，主要包括登录页、注册页、首页、笔记编辑页、待办详情页和搜索结果页。

- `LoginPage` 和 `RegisterPage` 负责账号入口。
- `Index` 负责首页列表、标签筛选、昵称管理、手机/平板导航差异和右侧嵌入编辑。
- `NoteEditPage` 负责笔记编辑、图片选择、AI 整理和预览。
- `TodoDetailPage` 负责待办编辑和三态切换。
- `SearchResultPage` 负责关键词、日期、标签组合筛选。

### 2.2 数据层

数据层核心是 `RdbStoreManager`，使用 `InspirationNote.db` 建立两张表：

- `notes`：保存标题、正文、图片路径、标签、AI 标签、摘要、行动项、优先级、创建时间和待办状态。
- `todos`：保存待办状态、截止时间和优先级，并通过 `noteId` 关联到笔记。

这种设计允许普通笔记和待办共用编辑、搜索、卡片展示能力，同时保留待办状态的独立扩展空间。

### 2.3 业务层

业务层主要由 `NoteService`、`ImageService` 和 `UserViewModel` 承担：

- `NoteService` 封装笔记 CRUD、标签解析、AI 建议、本地摘要和云端 AI 请求。
- `ImageService` 封装相册权限申请和图片选择。
- `UserViewModel` 封装注册、登录、密码哈希校验和旧密码迁移。

## 3. Native 能力集成

项目通过 `entry/src/main/cpp` 构建 `libtext_analyzer.so`，并在 ArkTS 中通过 `NativeTextAnalyzer` 与 `NativeCrypto` 调用。

### 3.1 文本分析

`text_analyzer.cpp` 实现 UTF-8 解码、中文 n-gram 分词、停用词过滤、TF-IDF 风格权重排序和句子评分。ArkTS 层通过 `extractKeywords(text, topK)` 获取关键词，通过 `scoreSentences(text, keywords, topK)` 获取摘要候选句。

### 3.2 密码加密

`crypto_utils.cpp` 实现 SHA-256、随机盐值生成和常量时间字符串比较。注册时保存 `hash:salt`，登录时使用盐值重新计算哈希并比对。对于旧版本明文密码，登录成功后自动迁移为哈希记录。

### 3.3 NAPI 注册

`napi_init.cpp` 统一注册以下方法：

- `extractKeywords`
- `scoreSentences`
- `hashPassword`
- `generateSalt`
- `verifyPassword`

本次集成构建确认 CMake、Ninja、ArkTS 编译和 HAP 打包均可通过。

## 4. 响应式与平板分栏

响应式能力由 `BreakpointUtil` 和 `ResponsiveConstants` 实现。

- 小屏：单列列表，点击卡片通过路由进入详情页。
- 中屏：两列网格，编辑页和搜索页限制最大宽度并居中。
- 大屏：三列网格，首页使用列表-详情双栏。

`EntryAbility` 在窗口创建和尺寸变化时更新断点，页面通过 `@StorageProp('currentBreakpoint')` 获取当前断点，统一调整页面 padding、列数、图片高度和正文展示行数。

平板端首页使用 `SideBarContainer` 思路，左侧保持列表，右侧根据选中笔记或待办展示嵌入式 `NoteEditPage` 或 `TodoDetailPage`。手机端保持 `router.pushUrl` 导航，避免小屏内容挤压。

## 5. UI 统一优化

第五部分对高频 UI 尺寸进行了集中管理，减少页面间风格漂移：

- 页面标题：`UiConstants.TITLE_SIZE`
- 小节/卡片标题：`UiConstants.SUBTITLE_SIZE`
- 正文字号：`UiConstants.BODY_SIZE`
- 大号正文/输入文字：`UiConstants.BODY_LARGE_SIZE`
- 辅助文字：`UiConstants.LABEL_SIZE`、`UiConstants.CAPTION_SIZE`
- 标准输入/按钮高度：`UiConstants.CONTROL_HEIGHT`
- 紧凑输入/按钮高度：`UiConstants.COMPACT_CONTROL_HEIGHT`
- 卡片内边距：`UiConstants.CARD_PADDING`
- 表单内边距：`UiConstants.FORM_PADDING`
- 输入框圆角：`UiConstants.FIELD_RADIUS`
- 图片圆角：`UiConstants.MEDIA_RADIUS`
- 图标尺寸：`UiConstants.ICON_SIZE`

统一常量后，登录、注册、首页、编辑页、待办详情页、搜索页和笔记卡片在标题、输入区、按钮、卡片和图片展示上保持一致。

## 6. 集成验证

本次完成一次本机 HAP 构建验证：

```text
BUILD SUCCESSFUL in 11 s 25 ms
```

关键任务结果：

- Native CMake 配置通过。
- Native Ninja 构建通过。
- ArkTS 编译通过。
- HAP 打包通过。
- 打包检查通过。

构建中仍存在若干警告，主要集中在异常处理、废弃 API 和 Native 声明文件三个方向。它们不阻塞当前交付，但建议作为下一阶段代码质量优化目标。

## 7. 总结

前四部分完成了 Native 文本分析、Native 加密、响应式断点和平板分栏。第五部分在此基础上完成集成构建验证、UI 常量统一、HapTest 测试方案整理和实验报告技术章节编写。当前应用已经具备完整编译打包能力，核心功能可进入真机测试阶段。
