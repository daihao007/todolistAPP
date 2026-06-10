# 分工 3 响应式布局断点系统完成记录

## 完成时间

2026-06-10

## 本次负责内容

分工 3：MediaQuery/断点式响应式布局系统，目标是让应用在手机单列和平板多列场景下自动切换布局，并让编辑、详情、搜索页面在宽屏上限制内容宽度。

## 主要代码变更

1. `entry/src/main/ets/common/Constants.ets`
   - 新增 `Breakpoint` 枚举：`SM`、`MD`、`LG`。
   - 新增 `ResponsiveConstants`，统一维护断点阈值、页面 padding、网格列数、图片高度、卡片内容行数和宽屏页面最大宽度。

2. `entry/src/main/ets/utils/BreakpointUtil.ets`
   - 新增断点管理工具类。
   - 使用 `AppStorage` 保存全局 `currentBreakpoint`。
   - 提供宽度解析、断点判断、padding、列数、Grid span、图片高度、内容行数等响应式辅助方法。

3. `entry/src/main/ets/entryability/EntryAbility.ets`
   - 应用启动时初始化断点状态。
   - 在窗口创建后读取主窗口宽度，并监听 `windowSizeChange`，作为断点更新的兜底来源。

4. `entry/src/main/ets/pages/Index.ets`
   - 首页笔记列表和待办列表由 `List` 改为 `GridRow/GridCol`。
   - 手机端保持 1 列，MD 断点显示 2 列，LG 断点显示 3 列。
   - 页面 padding 根据断点自动切换。
   - 通过 `onAreaChange` 使用页面真实布局宽度刷新断点状态。

5. `entry/src/main/ets/components/NoteCard.ets`
   - 卡片订阅全局断点。
   - 图片高度按断点切换：手机较低，平板更高。
   - 正文预览行数按断点切换：宽屏展示更多内容。

6. `entry/src/main/ets/pages/NoteEditPage.ets`
   - 编辑页订阅全局断点。
   - 手机端保持满宽布局，宽屏端最大宽度限制为 `ResponsiveConstants.FORM_MAX_WIDTH` 并居中。
   - 图片预览高度随断点变化。

7. `entry/src/main/ets/pages/TodoDetailPage.ets`
   - 待办详情页订阅全局断点。
   - 手机端满宽，宽屏端限制最大表单宽度并居中。
   - 图片预览高度随断点变化。

8. `entry/src/main/ets/pages/SearchResultPage.ets`
   - 搜索结果页订阅全局断点。
   - 搜索结果由单列 `Column` 改为响应式 `GridRow/GridCol`。
   - 宽屏端限制页面最大宽度为 `ResponsiveConstants.SEARCH_MAX_WIDTH` 并居中。

9. `entry/src/main/module.json5`
   - `deviceTypes` 增加 `tablet`，使工程配置与手机/平板适配目标一致。

## 验证建议

由于当前命令行环境未提供 `hvigor` 或 `hvigorw`，本次无法在终端直接执行 DevEco/Hvigor 构建。建议在 DevEco Studio 中完成以下验证：

1. Phone Previewer：确认首页笔记和待办仍为单列布局，点击卡片仍跳转对应详情页。
2. Tablet Previewer 600vp 以上：确认首页和搜索结果切换为 2 列。
3. Tablet Previewer 840vp 以上：确认首页和搜索结果切换为 3 列。
4. 编辑页、待办详情页、搜索页：确认宽屏下内容居中且不被横向拉伸。
5. 插入图片的笔记卡片：确认图片高度随断点变化，文本预览行数在宽屏上增加。
