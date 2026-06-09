# Native增强与多端适配 - 五人轮流开发分工

## 大作业要求

- **Native原生增强**（3选2）：将核心逻辑迁移到 C/C++ 侧，通过 NAPI 与 ArkTS 通信
- **全场景适配**（3选2）：应用需适配手机和平板，不能简单等比拉伸

## 选择的4个方向

| 类别 | 方向 | 说明 |
|------|------|------|
| Native A | C++ 关键词提取算法 | TF-IDF + TextRank，替换现有空格分词 |
| Native B | C++ 密码加密存储 | SHA-256 哈希，替代明文存储 |
| 适配 A | 响应式布局 | MediaQuery 断点系统，手机/平板自适应 |
| 适配 B | 平板分栏架构 | SideBarContainer 列表-详情双栏 |

---

## 开发顺序

```
第1人 → 第2人 → 第3人 → 第4人 → 第5人
(Native关键词)  (Native加密)  (响应式断点)  (分栏架构)  (集成测试)
```

> 第2人和第3人可以调换，因为 Native 加密和响应式布局互不依赖。

---

## 第1人 - Native 环境搭建 + C++ 关键词提取算法

**交付物**: C++ TF-IDF 关键词提取模块，通过 NAPI 被 ArkTS 调用

### 具体任务

1. 配置 `CMakeLists.txt` + 修改 `build-profile.json5` 添加 NDK 构建
2. 编写 `text_analyzer.cpp`：n-gram 中文分词 + TF-IDF 权重计算 + TextRank 句子评分
3. 编写 `napi_init.cpp`：NAPI 模块注册，暴露 `extractKeywords()` 和 `scoreSentences()`
4. 编写 `NativeTextAnalyzer.ets`：ArkTS 封装层
5. 修改 `NoteService.ets`：替换原有 `extractKeywords()` 和 `buildLocalSummary()` 为 Native 版本

### 新建文件

- `entry/src/main/cpp/CMakeLists.txt`
- `entry/src/main/cpp/text_analyzer.cpp`
- `entry/src/main/cpp/napi_init.cpp`
- `entry/src/main/ets/utils/NativeTextAnalyzer.ets`

### 修改文件

- `entry/build-profile.json5`
- `entry/src/main/ets/service/NoteService.ets`

### 技术要点

**C++ 侧实现**:
- n-gram 分词：将中文文本按 2 字符和 3 字符切分为 token
- TF-IDF 计算：TF(t,d) = 词频 / 总词数，IDF(t) = log(文档数 / 包含词的文档数)
- TextRank 句子评分：基于关键词命中、摘要暗示词、句长的加权评分

**NAPI 桥接**:
```cpp
// 暴露的函数签名
napi_value ExtractKeywords(napi_env env, napi_callback_info info);
// 参数: text(string), topK(number)
// 返回: string[]

napi_value ScoreSentences(napi_env env, napi_callback_info info);
// 参数: text(string), keywords(string[]), topK(number)
// 返回: string[]
```

**ArkTS 调用**:
```typescript
import textAnalyzer from 'libtext_analyzer.so'

const keywords: string[] = textAnalyzer.extractKeywords('今天开了项目会议', 5)
const sentences: string[] = textAnalyzer.scoreSentences(text, keywords, 2)
```

### 验证方式

输入中文文本 "今天开了项目会议，讨论了下周的开发计划，需要完成数据库迁移"，验证：
- `extractKeywords(text, 5)` 返回有意义的关键词
- `scoreSentences(text, keywords, 2)` 返回得分最高的 2 个句子

### 预计工作量: 3天

---

## 第2人 - C++ 密码加密存储

**交付物**: SHA-256 密码哈希模块，用户密码安全存储

**状态**: 已完成（2026-06-09）

### 具体任务

1. 编写 `crypto_utils.cpp`：SHA-256 哈希 + 随机盐值生成 + 密码验证
2. 在 `napi_init.cpp` 中注册 crypto 模块，暴露 `hashPassword()` / `generateSalt()` / `verifyPassword()`
3. 编写 `NativeCrypto.ets`：ArkTS 封装层
4. 修改 `UserViewModel.ets`：注册时哈希存储，登录时验证，旧用户自动迁移

### 新建文件

- `entry/src/main/cpp/crypto_utils.cpp`
- `entry/src/main/ets/utils/NativeCrypto.ets`

### 修改文件

- `entry/src/main/cpp/CMakeLists.txt`（合并构建）
- `entry/src/main/cpp/napi_init.cpp`（注册新模块）
- `entry/src/main/ets/viewmodel/UserViewModel.ets`

### 技术要点

**C++ 侧实现**:
- SHA-256 哈希函数：对 password + salt 拼接字符串计算哈希值
- 盐值生成：使用 `<random>` 生成 16 字节随机盐，转为 hex 字符串
- 密码验证：重新计算哈希值并与存储值比较

**NAPI 桥接**:
```cpp
// 暴露的函数签名
napi_value HashPassword(napi_env env, napi_callback_info info);
// 参数: password(string), salt(string)
// 返回: string (hex哈希值)

napi_value GenerateSalt(napi_env env, napi_callback_info info);
// 参数: 无
// 返回: string (16字节hex盐值)

napi_value VerifyPassword(napi_env env, napi_callback_info info);
// 参数: password(string), salt(string), expectedHash(string)
// 返回: boolean
```

**密码存储格式**:
```
Preferences key: user_{account}
Preferences value: {sha256_hash}:{salt}
示例: "a3f2b8c1d4e5...f6:9b8a7c6d5e4f3a2b"
```

**UserViewModel 改造**:
```typescript
// 注册时
const salt = NativeCrypto.generateSalt()
const hash = NativeCrypto.hashPassword(password, salt)
await PreferenceUtil.putString(context, user, `${hash}:${salt}`)

// 登录时
const stored = await PreferenceUtil.getString(context, user, 'NOT_FOUND')
const [storedHash, salt] = stored.split(':')
const isValid = NativeCrypto.verifyPassword(password, salt, storedHash)

// 兼容旧版明文密码
if (!stored.includes(':')) {
  // 旧版明文，直接比较后自动迁移为哈希
  if (stored === password) {
    const salt = NativeCrypto.generateSalt()
    const hash = NativeCrypto.hashPassword(password, salt)
    await PreferenceUtil.putString(context, user, `${hash}:${salt}`)
    return true
  }
}
```

### 验证方式

1. 注册新用户，检查 Preferences 中存储的是 `hash:salt` 格式而非明文
2. 使用正确密码登录，验证成功
3. 使用错误密码登录，验证失败
4. 旧版明文用户首次登录后自动迁移为哈希格式

### 完成记录（2026-06-09）

- 已实现 `entry/src/main/cpp/crypto_utils.cpp`，提供 SHA-256、16 字节随机盐值生成、密码验证。
- 已在 `entry/src/main/cpp/napi_init.cpp` 注册 `hashPassword()`、`generateSalt()`、`verifyPassword()`，并在 `entry/src/main/cpp/CMakeLists.txt` 合并构建。
- 已新增 `entry/src/main/ets/utils/NativeCrypto.ets`，封装 Native 加密能力。
- 已改造 `entry/src/main/ets/viewmodel/UserViewModel.ets`：注册写入 `64位hash:32位salt`，登录验证哈希，旧版明文密码在正确登录后自动迁移。
- DevEco/Hvigor 构建通过：`assembleHap` 成功，Native CMake/Ninja 构建成功。
- 模拟器功能验证通过：注册测试账号 `crypto0609a`，正确密码 `Pw123456` 登录成功进入 `pages/Index`，错误密码 `Wrong123` 停留在 `pages/LoginPage`。
- 非明文存储验证通过：临时内部探针读取 Preferences 记录，结果为 `recordLength=97 hashRecord=true containsPlain=false`；探针代码已删除，最终版重新构建并安装验证通过。

### 预计工作量: 2天

---

## 第3人 - 响应式布局断点系统

**交付物**: MediaQuery 断点系统，手机单列/平板多列自适应布局

### 具体任务

1. 在 `Constants.ets` 添加 `Breakpoint` 枚举和 `ResponsiveConstants` 响应式常量
2. 新建 `BreakpointUtil.ets`：断点管理器，监听屏幕宽度变化
3. 改造 `EntryAbility.ets`：注册 MediaQuery 监听
4. 改造 `Index.ets`：List 改为 GridRow/GridCol，手机1列/平板2-3列
5. 改造 `NoteCard.ets`：根据断点调整图片高度、内容行数
6. 改造编辑页和搜索页：平板端限制最大宽度居中显示

### 新建文件

- `entry/src/main/ets/utils/BreakpointUtil.ets`

### 修改文件

- `entry/src/main/ets/common/Constants.ets`
- `entry/src/main/ets/entryability/EntryAbility.ets`
- `entry/src/main/ets/pages/Index.ets`
- `entry/src/main/ets/pages/NoteEditPage.ets`
- `entry/src/main/ets/pages/TodoDetailPage.ets`
- `entry/src/main/ets/pages/SearchResultPage.ets`
- `entry/src/main/ets/components/NoteCard.ets`

### 技术要点

**断点定义**:
```typescript
// Constants.ets
enum Breakpoint {
  SM = 'sm',   // 手机竖屏: 0-599vp
  MD = 'md',   // 手机横屏/小平板: 600-839vp
  LG = 'lg'    // 平板: 840vp+
}

class ResponsiveConstants {
  static readonly SM_PAGE_PADDING = 20
  static readonly SM_COLUMNS = 1
  static readonly SM_CARD_MAX_WIDTH = 9999

  static readonly MD_PAGE_PADDING = 24
  static readonly MD_COLUMNS = 2
  static readonly MD_CARD_MAX_WIDTH = 400

  static readonly LG_PAGE_PADDING = 32
  static readonly LG_COLUMNS = 3
  static readonly LG_CARD_MAX_WIDTH = 360
}
```

**断点管理器**:
```typescript
// BreakpointUtil.ets
export class BreakpointUtil {
  static currentBreakpoint: Breakpoint = Breakpoint.SM
  static currentPadding: number = ResponsiveConstants.SM_PAGE_PADDING
  static currentColumns: number = ResponsiveConstants.SM_COLUMNS

  static init(context: Context) {
    // 注册 MediaQuery 监听
  }
}
```

**Index.ets 改造示例**:
```typescript
// 手机端: 单列 List
// 平板端: GridRow + GridCol 多列
if (BreakpointUtil.currentBreakpoint === Breakpoint.SM) {
  List() { ... }
} else {
  GridRow({ columns: BreakpointUtil.currentColumns }) {
    ForEach(notes, (note) => {
      GridCol() {
        NoteCard({ note: note })
      }
    })
  }
}
```

**编辑页居中**:
```typescript
Column() {
  // 原有内容
}
.width('100%')
.constraintSize({
  maxWidth: BreakpointUtil.currentBreakpoint === Breakpoint.SM
    ? '100%'
    : ResponsiveConstants.LG_CARD_MAX_WIDTH
})
.alignSelf(ItemAlign.Center)
```

### 验证方式

1. DevEco Studio Previewer 切换 phone / tablet 设备
2. 手机端：单列卡片布局
3. 平板端：2-3 列卡片网格布局
4. 编辑页在平板上限制宽度居中显示

### 预计工作量: 2天

---

## 第4人 - 平板分栏架构

**交付物**: SideBarContainer 列表-详情双栏布局，类似 Notion

### 具体任务

1. 改造 `Index.ets`：平板端使用 `SideBarContainer`，左侧列表（360vp）右侧详情
2. 改造 `NoteEditPage.ets`：添加 `@Prop isEmbedded` 支持嵌入模式
3. 改造 `TodoDetailPage.ets`：同上
4. 处理导航差异：手机端路由跳转，平板端组件嵌入
5. 状态同步：列表选中态、编辑内容实时更新

### 修改文件

- `entry/src/main/ets/pages/Index.ets`（主要改动）
- `entry/src/main/ets/pages/NoteEditPage.ets`
- `entry/src/main/ets/pages/TodoDetailPage.ets`

### 技术要点

**布局结构**:
```
手机 (<600vp):                    平板 (>=840vp):
┌─────────────┐                  ┌──────┬──────────────┐
│   顶部问候   │                  │ 侧边 │              │
│  搜索筛选    │                  │  栏  │   详情区域    │
│  笔记列表    │                  │ 列表 │  NoteEditPage │
│     [+]     │                  │      │  或           │
│             │                  │      │  TodoDetail   │
└─────────────┘                  └──────┴──────────────┘
```

**Index.ets 改造**:
```typescript
if (BreakpointUtil.currentBreakpoint === Breakpoint.SM) {
  // 手机端: 原有 Tabs 布局
  Tabs() { ... }
} else {
  // 平板端: SideBarContainer
  SideBarContainer(SideBarContainerType.Embed) {
    // 侧边栏: 搜索 + 列表
    Column() {
      // 搜索筛选区
      // 笔记/待办列表
    }
    .width(360)

    // 内容区: 详情页
    Column() {
      if (this.selectedNoteId > 0) {
        NoteEditPage({
          noteId: this.selectedNoteId,
          isEmbedded: true
        })
      } else {
        CommonEmptyView({ message: '选择一个笔记开始编辑' })
      }
    }
  }
  .sideBarWidth(360)
}
```

**NoteEditPage.ets 改造**:
```typescript
@Component
struct NoteEditPage {
  @Prop noteId: number = 0
  @Prop isEmbedded: boolean = false  // 新增: 是否嵌入模式

  build() {
    if (this.isEmbedded) {
      // 嵌入模式: 无 Scroll 包裹，无返回按钮
      Column() {
        // 页面内容
      }
    } else {
      // 独立页面模式: 原有 Scroll 包裹
      Scroll() {
        Column() {
          // 返回按钮 + 页面内容
        }
      }
    }
  }
}
```

**导航差异处理**:
```typescript
// 手机端点击卡片
if (BreakpointUtil.currentBreakpoint === Breakpoint.SM) {
  router.pushUrl({ url: 'pages/NoteEditPage', params: { noteId: id } })
} else {
  // 平板端: 直接更新选中状态
  this.selectedNoteId = id
  this.selectedType = 'note'
}
```

### 验证方式

1. 手机端：保持原有单栏导航，点击卡片跳转详情页
2. 平板端：左侧 360vp 列表栏，右侧显示详情编辑页
3. 点击列表项，右侧实时切换显示对应笔记/待办
4. 编辑保存后，列表自动刷新

### 预计工作量: 2天

---

## 第5人 - 集成测试与优化

**交付物**: 完整可运行应用 + HapTest 测试报告

### 具体任务

1. 集成联调：确保 Native 模块 + 多端适配协同工作
2. Bug 修复：处理前4人的集成问题
3. UI 统一：硬编码尺寸改为常量
4. HapTest 测试：选择2个测试策略完成测试报告
5. 编写实验报告技术章节

### 修改文件

- 多个文件的 UI 尺寸统一
- 可能的 Bug 修复

### 技术要点

**UI 尺寸统一**:
| 位置 | 当前值 | 改为 |
|------|--------|------|
| 页面标题字号 | 硬编码 28 | `UiConstants.TITLE_SIZE` (需改为28) |
| 搜索框高度 | 48/52 不一致 | 统一为 48 |
| 图片预览高度 | 160/180 不一致 | 统一为 160 |
| 按钮高度 | 36/44/52 混用 | 统一规范 |

**HapTest 测试**:
- 从内置测试策略中选择2个完成测试报告
- 开源地址: https://gitee.com/sandlake/haptest
- 建议选择: UI自动化测试 + 功能测试

### 验证方式

1. 手机和平板上完整走通所有功能流程
2. Native 模块调用无崩溃
3. 深浅色主题切换正常
4. HapTest 测试报告完成

### 预计工作量: 3天

---

## 时间安排（截止 6.20 晚12点）

| 人员 | 任务 | 预计天数 | 建议日期 |
|------|------|----------|----------|
| 第1人 | Native 关键词提取 | 3天 | 6.9 - 6.11 |
| 第2人 | Native 密码加密 | 2天 | 6.11 - 6.12 |
| 第3人 | 响应式断点系统 | 2天 | 6.12 - 6.14 |
| 第4人 | 平板分栏架构 | 2天 | 6.14 - 6.16 |
| 第5人 | 集成测试与优化 | 3天 | 6.16 - 6.20 |

---

## 关键文件清单

### 新建文件

| 文件 | 负责人 | 说明 |
|------|--------|------|
| `entry/src/main/cpp/CMakeLists.txt` | 第1人 | C++ 构建配置 |
| `entry/src/main/cpp/text_analyzer.cpp` | 第1人 | TF-IDF 关键词提取 |
| `entry/src/main/cpp/napi_init.cpp` | 第1人 | NAPI 模块注册 |
| `entry/src/main/cpp/crypto_utils.cpp` | 第2人 | SHA-256 密码哈希 |
| `entry/src/main/ets/utils/NativeTextAnalyzer.ets` | 第1人 | ArkTS 封装 |
| `entry/src/main/ets/utils/NativeCrypto.ets` | 第2人 | ArkTS 封装 |
| `entry/src/main/ets/utils/BreakpointUtil.ets` | 第3人 | 断点管理器 |

### 修改文件

| 文件 | 负责人 | 改动内容 |
|------|--------|----------|
| `entry/build-profile.json5` | 第1人 | 添加 externalNativeOptions |
| `entry/src/main/ets/service/NoteService.ets` | 第1人 | 调用 Native 关键词提取 |
| `entry/src/main/ets/viewmodel/UserViewModel.ets` | 第2人 | 密码哈希存储验证 |
| `entry/src/main/ets/common/Constants.ets` | 第3人 | 断点枚举和响应式常量 |
| `entry/src/main/ets/entryability/EntryAbility.ets` | 第3人 | MediaQuery 监听 |
| `entry/src/main/ets/pages/Index.ets` | 第3、4人 | 响应式 + 分栏 |
| `entry/src/main/ets/pages/NoteEditPage.ets` | 第3、4人 | 响应式 + 嵌入模式 |
| `entry/src/main/ets/pages/TodoDetailPage.ets` | 第3、4人 | 响应式 + 嵌入模式 |
| `entry/src/main/ets/pages/SearchResultPage.ets` | 第3人 | 响应式布局 |
| `entry/src/main/ets/components/NoteCard.ets` | 第3人 | 响应式尺寸 |
