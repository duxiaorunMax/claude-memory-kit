# 架构设计

## 三层记忆体系

| 层级 | 工具 | 存储 | 内容 |
|------|------|------|------|
| 全局级 | `mcp__memorygraph__*` | ~/.claude/memory/ | 用户偏好、环境配置 |
| 项目级 | `mcp__memorygraph-project__*` | 项目/.claude/memory/ | 模块知识、Bug修复 |
| 文档级 | - | .remember/, CLAUDE.md | 结构化知识、规则 |

## 会话生命周期

```
SessionStart Hook
    ↓
注入记忆上下文 + 检查维护时间
    ↓
用户对话...
    ↓
[触发存储条件] → 立即存储
    ↓
PreCompact Hook → 提醒存储
    ↓
Stop Hook → 会话结束提醒
    ↓
/my-mem-reflect → 整理记忆
```

## 存储原则

1. **不删除，只降级**：Active → Dormant → Archived
2. **带摘要存储**：每条记忆有 summary 和 content 两层
3. **新颖度检测**：避免存储重复内容

## 与 code-review-graph 的关系

| 系统 | 用途 | 数据来源 |
|------|------|----------|
| MemoryGraph | 语义记忆（业务逻辑、决策） | AI 理解 |
| code-review-graph | 代码结构（AST、调用链） | 静态分析 |

两者互补，配合使用效果最佳。
