# 分工 4 平板列表-详情分栏架构完成记录

## 完成时间

2026-06-11

## 本次负责内容

分工 4：在现有响应式断点系统上增加平板列表-详情双栏架构。LG 平板使用 `SideBarContainer` 保持左侧列表可见，右侧直接嵌入笔记或待办编辑组件；手机和 MD 设备继续使用路由跳转。

## 主要代码变更

1. `entry/src/main/ets/pages/Index.ets`
   - LG 断点使用 `SideBarContainer(SideBarContainerType.Embed)`。
   - 左侧栏宽度、最小宽度和最大宽度均设置为 360vp。
   - 左侧提供笔记/待办切换、搜索、标签筛选、列表和新建入口。
   - 右侧根据 `selectedType` 嵌入 `NoteEditPage` 或 `TodoDetailPage`。
   - 使用 `selectedNoteId` 和 `showEmbeddedEditor` 展示列表选中边框。
   - 手机和 MD 断点继续通过 `router.pushUrl` 打开独立页面。
   - 平板端通过组件回调处理保存、删除和草稿变化，不进行页面跳转。

2. `entry/src/main/ets/pages/NoteEditPage.ets`
   - 增加 `@Prop isEmbedded` 和 `@Prop noteId`。
   - 将可复用编辑内容抽取为 `EditorContent`。
   - 嵌入模式直接渲染编辑内容，独立页面模式保留页面级 `Scroll`。
   - 保存和删除时，嵌入模式通知父组件，独立模式保持原有路由行为。
   - 标题、正文、图片和标签变化时触发 `onDraftChange`。
   - 使用独立 `@Entry` 包装组件，避免入口组件接收 `@Prop`。

3. `entry/src/main/ets/pages/TodoDetailPage.ets`
   - 与笔记编辑页采用相同的嵌入模式结构。
   - 草稿回调额外同步待办状态。
   - 保存、删除和状态变化均可实时反馈给平板左侧列表。

## 关键问题修复

1. 点击笔记闪退
   - 原因：ArkUI V1 的 `@Prop` 不支持函数回调，组件初始化时触发非法属性值异常。
   - 修复：`onSaved`、`onDeleted` 和 `onDraftChange` 改为普通组件回调属性。

2. 左侧卡片未实时更新
   - 原因：平板列表 `ForEach` 的 key 只包含记录 ID 和待办状态，标题或正文变化时复用了旧节点。
   - 修复：平板列表 key 纳入标题、正文、图片和标签等预览字段，草稿变化时重建对应卡片。

## 导航与状态策略

| 场景 | 行为 |
|------|------|
| 手机/MD 点击笔记 | `router.pushUrl` 打开 `NoteEditPage` |
| 手机/MD 点击待办 | `router.pushUrl` 打开 `TodoDetailPage` |
| LG 平板点击列表项 | 更新 `selectedNoteId` 和 `selectedType` |
| LG 平板新建内容 | 清空 `selectedNoteId` 并显示对应嵌入编辑器 |
| 编辑草稿 | 实时更新左侧选中卡片 |
| 保存 | 刷新列表并保持新记录选中 |
| 删除 | 清空选中状态并恢复右侧空状态 |

## 验证结果

- DevEco/Hvigor `assembleHap` 构建成功。
- 2560x1600 平板模拟器验证通过：
  - 360vp 左侧栏和右侧详情区正常显示。
  - 新建、保存和重新打开笔记正常。
  - 待办编辑器可正常嵌入。
  - 选中边框正确显示。
  - 右侧编辑标题或正文时，左侧卡片无需保存即可实时更新。
  - 日志中无 `TypeError`、`JS_ERROR` 或运行时崩溃。
- 当前环境没有手机模拟器，手机导航分支完成代码路径检查和编译验证，尚未完成手机设备运行测试。

## 提交记录

- `2de57da feat: add tablet split-view editing`
- 已于 2026-06-11 合并并推送到 GitHub `main`。
