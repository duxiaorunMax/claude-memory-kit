# Claude Memory Kit

让 Claude Code 拥有跨会话记忆能力的完整解决方案。

---

## 快速开始

### 安装

```powershell
# Windows
./install.ps1

# Linux/Mac
./install.sh
```

安装完成后：
1. 重启 Claude Code
2. 在项目目录运行 `/my-mem-init`

---

## 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│ 全局记忆 (mcp__memorygraph__*)                               │
│ 数据库：~/.claude/memory/memory.db                           │
│ 内容：用户偏好、环境配置、项目注册表                          │
└─────────────────────────────────────────────────────────────┘
                              ↓ 自动继承
┌─────────────────────────────────────────────────────────────┐
│ 项目记忆 (mcp__memorygraph-project__*)                       │
│ 数据库：项目/.claude/memory/memory.db                        │
│ 内容：模块知识、Bug修复、依赖关系                             │
└─────────────────────────────────────────────────────────────┘
                              ↓ 结构化知识
┌─────────────────────────────────────────────────────────────┐
│ 代码图 (code-review-graph MCP) - 可选                        │
│ 数据库：项目/.code-review-graph/                             │
│ 内容：函数调用链、依赖关系、爆炸半径分析                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Skills 列表

| Skill | 功能 |
|-------|------|
| `/my-mem-init` | 初始化记忆系统 + 提示配置代码图 |
| `/my-mem-reflect` | 记忆整理维护 |
| `/my-mem-codegraph` | 代码图初始化/增量更新 |

---

## 使用流程

### 1. 全局安装（一次性）

运行安装脚本后，所有项目都能使用全局记忆。

### 2. 项目初始化

```bash
# 在项目目录
cd /path/to/your/project

# 在 Claude Code 中运行
/my-mem-init
```

### 3. 日常使用

```
# 会话开始 → 自动注入记忆上下文
# 开发过程 → AI 自动存储知识
# 会话结束 → 提醒存储重要内容

# 定期整理
/my-mem-reflect
```

---

## 文件结构

### 安装后全局文件

```
~/.claude/
├── skills/
│   ├── my-mem-init/
│   │   └── skill.md
│   ├── my-mem-reflect/
│   │   └── skill.md
│   └── my-mem-codegraph/
│       └── skill.md
├── memory/
│   └── memory.db        # 全局记忆数据库
└── memory-templates/    # 项目初始化模板
```

### 项目初始化后

```
项目目录/
├── .mcp.json                    # 项目 MCP 配置
├── .claude/
│   ├── memory/
│   │   └── memory.db            # 项目记忆数据库
│   ├── hooks/
│   │   ├── session-start-memory.js
│   │   ├── pre-compact-memory.js
│   │   └── stop-memory.js
│   └── settings.local.json
└── .remember/
    ├── core-memories.md
    ├── now.md
    └── recent.md
```

---

## 记忆存储规则

### 自动存储场景

| 触发条件 | 存储内容 |
|----------|----------|
| 同一模块读取超过 3 个文件 | 模块职责、核心类、依赖 |
| Bug 修复完成 | 问题+原因+解决方案 |
| 用户说"记住" | 用户偏好 |
| 发现跨模块依赖 | A 依赖 B 的关系 |

### 存储格式

```javascript
mcp__memorygraph__store_memory({
  type: "solution",
  title: "标题",
  summary: "一句话概述",  // 必填，用于快速检索
  content: "详细内容...",
  tags: ["项目名", "类型"],
  importance: 0.8
})
```

---

## 依赖要求

- Python 3.8+
- Node.js 16+ (用于 Hook 脚本)
- Claude Code CLI

---

## 可选组件

### code-review-graph

代码知识图谱，提供：
- 函数调用链分析
- 爆炸半径分析（改代码影响哪些文件）
- Token 节省（大项目可达 50x）

安装时选择安装，或后续运行 `/my-mem-codegraph`。

---

## 常见问题

### Q: 如何迁移现有项目？

A: 在项目目录运行 `/my-mem-init`，会自动创建所需配置。

### Q: 记忆存在哪里？

A: 全局记忆在 `~/.claude/memory/memory.db`，项目记忆在项目的 `.claude/memory/memory.db`。

### Q: 如何备份记忆？

A: 复制对应的 `.db` 文件即可。

### Q: 多人协作怎么办？

A: 项目级记忆可以提交到 git，团队共享。全局记忆是个人偏好，不提交。

---

## 许可证

MIT License
