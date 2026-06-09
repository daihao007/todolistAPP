# 技术栈

## 开发环境

| 项目 | 版本/说明 |
|------|-----------|
| **平台** | HarmonyOS (鸿蒙) |
| **SDK** | 6.0.2 (API 22) |
| **开发语言** | ArkTS (TypeScript 方言)、C++ |
| **UI 框架** | ArkUI (声明式组件) |
| **构建工具** | Hvigor、CMake/Ninja |
| **运行模式** | Stage Mode |

## 核心依赖

### 系统能力

| 模块 | 用途 |
|------|------|
| `@ohos.data.relationalStore` | 关系型数据库 (RDB) |
| `@ohos.data.preferences` | 轻量级键值存储 |
| `@ohos.net.http` | HTTP 网络请求 |
| `@ohos.file.picker` | 文件选择器 (PhotoViewPicker) |
| `@ohos.abilityAccessCtrl` | 权限管理 |
| `@ohos.hilog` | 日志系统 |

### Native 能力

| 模块 | 用途 |
|------|------|
| NAPI | ArkTS 与 C++ 共享库通信 |
| `libtext_analyzer.so` | Native 共享库，暴露文本分析和密码加密函数 |
| `crypto_utils.cpp` | SHA-256 密码哈希、随机盐值生成、密码验证 |
| `text_analyzer.cpp` | Native 关键词提取和句子评分 |

### 测试框架

| 模块 | 用途 |
|------|------|
| `@ohos/hypium` | 单元测试框架 |
| `@ohos/hamock` | Mock 框架 |

## 外部服务

| 服务 | 用途 | 配置位置 |
|------|------|----------|
| **阿里云 DashScope** | 通义千问大模型 API | `common/Constants.ets` |
| **模型**: qwen3.5-122b-a10b | 文本分析、摘要提取 | `CommonConstants.CLOUD_AI_MODEL` |

## API 端点

```
POST https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions
Authorization: Bearer {API_KEY}
```

## 项目配置文件

| 文件 | 说明 |
|------|------|
| `build-profile.json5` | 项目构建配置，SDK 版本 |
| `oh-package.json5` | 项目包描述，依赖声明 |
| `entry/build-profile.json5` | 模块构建配置 |
| `entry/oh-package.json5` | 模块包描述 |
| `entry/src/main/module.json5` | 模块清单，权限，页面路由 |
