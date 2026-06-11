# 第五部分 HapTest 测试报告

## 1. 测试目标

本次测试覆盖前四部分集成后的主链路，重点确认 Native 模块、密码加密、响应式断点和平板分栏在同一工程中可以协同工作，并为后续真机 HapTest 执行提供可复用用例。

## 2. 测试环境

- 工程：todolistAPP
- 平台：HarmonyOS Stage 模型，ArkTS + C++ NAPI
- SDK：DevEco Studio 本地 SDK，`D:\deveco-studio\DevEco Studio\sdk`
- 构建命令：

```powershell
$env:DEVECO_SDK_HOME='D:\deveco-studio\DevEco Studio\sdk'
& 'D:\deveco-studio\DevEco Studio\tools\hvigor\bin\hvigorw.bat' --mode module -p module=entry@default -p product=default assembleHap
```

## 3. 测试策略一：核心功能集成冒烟

### 3.1 覆盖范围

- 登录注册：注册时调用 NativeCrypto 生成盐值并保存哈希，登录时校验哈希，兼容旧明文密码迁移。
- 笔记编辑：新建、编辑、删除笔记，保存后首页列表刷新。
- 待办状态：待处理、已完成、已延期三态在卡片、详情页、搜索页之间同步。
- AI 整理：本地 AI 调用 NativeTextAnalyzer 提取关键词和句子摘要；云端 AI 失败时保留错误提示。
- 数据持久化：RDB notes/todos 两张表保持关联更新。

### 3.2 用例设计

| 用例编号 | 用例名称 | 操作步骤 | 期望结果 | 当前状态 |
| --- | --- | --- | --- | --- |
| F-01 | 注册和登录 | 输入账号、昵称、密码注册，退出后重新登录 | 注册成功，密码不以明文保存，登录成功进入首页 | 待真机执行 |
| F-02 | 新建笔记 | 新建笔记，填写标题、正文、标签，保存 | 首页笔记列表出现新卡片，日期和标签正确 | 待真机执行 |
| F-03 | 本地 AI 整理 | 在编辑页输入包含任务和时间的正文，点击本地 AI | 生成关键词、摘要和行动项 | 待真机执行 |
| F-04 | 待办三态同步 | 新建待办，在列表和详情页切换状态 | 卡片角标、勾选状态、详情页状态一致 | 待真机执行 |
| F-05 | 搜索筛选 | 按关键词、日期、标签筛选笔记 | 搜索结果只展示匹配记录 | 待真机执行 |

## 4. 测试策略二：多端适配与分栏验证

### 4.1 覆盖范围

- 手机端：单列 GridRow/GridCol，点击卡片进入独立详情页。
- 平板端：SideBarContainer 左侧列表、右侧嵌入编辑区。
- 断点系统：窗口宽度变化后更新 AppStorage 中的 currentBreakpoint。
- 图片卡片：不同断点使用不同图片高度和正文行数。

### 4.2 用例设计

| 用例编号 | 用例名称 | 操作步骤 | 期望结果 | 当前状态 |
| --- | --- | --- | --- | --- |
| R-01 | 手机单列布局 | 在手机宽度打开首页 | 笔记/待办列表单列展示，浮动新建按钮可用 | 待真机执行 |
| R-02 | 平板多列列表 | 在平板宽度打开首页 | 列表根据断点展示 2 到 3 列 | 待真机执行 |
| R-03 | 平板双栏编辑 | 在平板宽度点击笔记卡片 | 左侧保持列表，右侧展示嵌入编辑器 | 待真机执行 |
| R-04 | 窗口尺寸变化 | 调整窗口宽度跨过 600vp 和 840vp | 页面 padding、列数、图片高度随断点更新 | 待真机执行 |
| R-05 | 搜索页宽屏居中 | 平板宽度打开搜索页 | 搜索内容区域限制最大宽度并居中 | 待真机执行 |

## 5. 本机集成构建结果

已完成一次本机 HAP 构建验证：

- 结果：通过
- 输出：`BUILD SUCCESSFUL in 11 s 25 ms`
- Native 构建：`BuildNativeWithCmake`、`BuildNativeWithNinja` 均通过
- ArkTS 编译：`CompileArkTS` 通过
- HAP 打包：`PackageHap`、`PackingCheck`、`SignHap`、`assembleHap` 均通过
- 说明：当前工程未配置正式签名，构建日志显示跳过 `hos_hap` 签名配置，这是调试阶段可接受状态。

## 6. 已完成优化

- 将登录、注册、首页、编辑页、待办详情页、搜索页和笔记卡片中的高频硬编码 UI 尺寸抽到 `UiConstants`。
- 统一页面标题字号为 `UiConstants.TITLE_SIZE`。
- 统一输入框高度为 `UiConstants.CONTROL_HEIGHT`，紧凑按钮/输入框高度为 `UiConstants.COMPACT_CONTROL_HEIGHT`。
- 统一卡片内边距、表单内边距、输入圆角、媒体圆角和图标尺寸。

## 7. 遗留风险

- RDB 和 Preferences 的部分调用仍有 ArkTS “Function may throw exceptions” 警告，建议下一轮统一加错误处理。
- `router`、`promptAction.showToast`、`PhotoViewPicker` 等接口存在废弃警告，建议后续迁移到新版 API。
- Native `.so` 导入缺少 `.d.ts` 声明文件，当前可编译，但后续 SDK 可能加强校验。
- 云 AI API Key 仍在常量文件中硬编码，建议改为安全配置或服务端代理。
