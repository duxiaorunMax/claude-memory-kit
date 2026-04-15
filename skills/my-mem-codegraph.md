---
name: my-mem-codegraph
description: 代码图初始化和更新 - 首次使用构建图，之后增量更新
---

## 代码图管理

管理当前项目的代码知识图谱。

### 使用场景

- 新项目首次配置
- 代码修改后更新图
- 查看图状态

### 命令

```bash
# code-review-graph 路径（根据实际安装位置调整）
# Windows 默认路径：
CRG="code-review-graph"

# 如果不在 PATH 中，使用完整路径：
# CRG="G:\\FeiJiang\\Anaconda2\\envs\\python3\\Scripts\\code-review-graph.exe"

# 检查是否已初始化
if [ -d ".code-review-graph" ]; then
  echo ">>> 更新代码图..."
  "$CRG" update
else
  echo ">>> 首次配置代码图..."
  "$CRG" install --platform claude-code
  "$CRG" build
fi

# 显示状态
"$CRG" status
```

### 工作流

1. **首次运行** → 安装配置 + 构建完整图
2. **之后运行** → 增量更新（只处理变化的文件）
3. **显示状态** → 文件数、节点数、边数

### 大项目提示

- 首次构建可能需要几分钟
- 增量更新通常几秒完成
- 图存储在 `.code-review-graph/` 目录

### 与 MemoryGraph 的关系

| 系统 | 用途 | 工具 |
|------|------|------|
| code-review-graph | 代码结构（AST、调用链、爆炸半径） | crg-* MCP 工具 |
| MemoryGraph | 语义记忆（业务逻辑、决策） | mcp__memorygraph-* |

两者互补，配合使用效果最佳。
