# Init Memory Skill

一键初始化项目的记忆系统。

## ⚠️ 重要区分

| 操作 | 命令 | 用途 |
|------|------|------|
| **本项目** | `/my-mem-init` | 新项目首次初始化（创建配置） |
| **存储知识** | `mcp__memorygraph__store_memory` | 日常存储知识到数据库 |

**本项目只用于初始化，不用于存储知识！**

## 触发

- 用户请求：`初始化记忆`、`/my-mem-init`
- 首次进入新项目时建议执行

## 执行步骤

### 1. 检测当前项目

确认当前工作目录，检测是否已有记忆配置：
- 检查 `.mcp.json` 是否已包含 memorygraph-project
- 检查 `.claude/memory/` 目录是否存在

### 2. 检测组件路径

自动检测以下组件的安装路径：

| 组件 | 检测路径 |
|------|----------|
| memorygraph | `~/.local/bin/memorygraph.exe` (Windows) 或 `~/.local/bin/memorygraph` (Linux/Mac) |
| code-review-graph | `~/.local/bin/code-review-graph` 或 Python Scripts 目录 |

### 3. 创建/更新项目配置

创建以下文件结构：

```
项目目录/
├── .mcp.json                    # MCP 配置
├── .claude/
│   ├── memory/                  # 记忆数据库目录
│   ├── hooks/                   # 会话生命周期 Hook
│   │   ├── session-start-memory.js
│   │   ├── pre-compact-memory.js
│   │   └── stop-memory.js
│   └── settings.local.json      # Hook 配置
└── .remember/                   # 文档记忆目录
    ├── core-memories.md
    ├── now.md
    └── recent.md
```

### 4. 处理已存在的配置

如果 `.mcp.json` 已存在（如项目已有其他 MCP 配置）：
- **自动添加** `memorygraph-project` 配置（不覆盖现有配置）
- **自动修复** `code-review-graph` 短路径为完整路径

### 5. .mcp.json 模板

```json
{
  "mcpServers": {
    "memorygraph-project": {
      "type": "stdio",
      "command": "C:/Users/你的用户名/.local/bin/memorygraph.exe",
      "args": [],
      "env": {
        "MEMORY_SQLITE_PATH": "./.claude/memory/memory.db"
      }
    }
  }
}
```

**注意**：路径使用正斜杠 `/`，兼容所有环境。

### 6. 更新项目注册表

初始化完成后，更新全局项目注册表：

```javascript
mcp__memorygraph__search_memories({
  tags: ["global", "projects", "registry"],
  limit: 1
})
// 然后更新项目列表
```

### 7. 检查代码图（可选增强）

记忆系统初始化完成后，检查是否已配置代码知识图谱：

```bash
# 检查代码图目录是否存在
if [ ! -d ".code-review-graph" ]; then
  echo "💡 检测到尚未配置代码图"
  # 询问用户是否继续配置
fi
```

**询问用户**：
```
💡 检测到尚未配置代码知识图谱（code-review-graph）

代码图可以让 AI：
- 精确知道改代码会影响哪些文件（爆炸半径分析）
- 理解函数调用链和依赖关系
- 大幅减少 token 消耗（大项目可节省 50x+）

是否继续初始化代码图？(y/n)
```

- **用户选 y** → 执行 `/my-mem-codegraph`
- **用户选 n** → 跳过，完成记忆系统初始化

### 8. 最终输出

```
✅ 项目记忆系统初始化完成

创建的文件：
├── .mcp.json                # MCP 配置
├── .claude/memory/          # 记忆数据库目录
├── .claude/hooks/           # 会话生命周期 Hook
├── .claude/settings.local.json  # Hook 配置
└── .remember/               # 文档记忆

可用的工具：
├── mcp__memorygraph__*               # 全局记忆（自动可用）
└── mcp__memorygraph-project__*       # 项目记忆（重启后可用）

下一步：
1. 重启会话使配置生效
2. AI 会自动学习项目知识并存储
```

## 路径配置指南

### Windows 用户

**统一使用正斜杠 `/`**：

```json
// ❌ 错误 - 反斜杠可能被转义
"command": "G:\\FeiJiang\\Anaconda2\\python.exe"

// ✅ 正确 - 正斜杠兼容所有环境
"command": "G:/FeiJiang/Anaconda2/python.exe"
```

### 查找组件路径

```bash
# Windows (Git Bash)
which memorygraph
which code-review-graph

# 或查找 Python Scripts 目录
ls G:/FeiJiang/Anaconda2/envs/python3/Scripts/

# Linux/Mac
which memorygraph
which code-review-graph
```

### 手动配置示例

如果自动检测失败，手动修改 `.mcp.json`：

```json
{
  "mcpServers": {
    "memorygraph-project": {
      "type": "stdio",
      "command": "C:/Users/你的用户名/.local/bin/memorygraph.exe",
      "args": [],
      "env": {
        "MEMORY_SQLITE_PATH": "./.claude/memory/memory.db"
      }
    },
    "code-review-graph": {
      "command": "你的Python路径/Scripts/code-review-graph.exe",
      "args": ["serve"],
      "type": "stdio"
    }
  }
}
```

## 记忆系统架构

```
┌─────────────────────────────────────────────┐
│ 全局记忆 (mcp__memorygraph__*)              │
│ 数据库：~/.claude/memory/memory.db          │
│ 内容：用户偏好、环境配置、项目注册表         │
└─────────────────────────────────────────────┘
          ↓ 自动继承
┌─────────────────────────────────────────────┐
│ 项目记忆 (mcp__memorygraph-project__*)      │
│ 数据库：项目/.claude/memory/memory.db       │
│ 内容：模块知识、Bug修复、依赖关系            │
└─────────────────────────────────────────────┘
```

## 已初始化项目

查询全局项目注册表：
```javascript
mcp__memorygraph__search_memories({
  tags: ["global", "projects", "registry"]
})
```

## 注意事项

- 全局记忆 (`mcp__memorygraph__*`) 无需初始化，自动可用
- 项目记忆需要重启会话才能加载新的 MCP 工具
- **路径使用正斜杠 `/`**，兼容 Windows 和 Unix
- 已存在 `.mcp.json` 时会自动合并配置，不覆盖
