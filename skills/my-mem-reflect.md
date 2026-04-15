# Memory Reflect Skill

会话结束时的记忆反思和整理。

## 触发

- 用户请求：`反思记忆`、`整理记忆`、`/my-mem-reflect`
- **自动触发**：Stop Hook 在会话结束时自动提醒
- **定期提醒**：SessionStart 检测超过 7 天未维护时提醒

## 会话生命周期

```
SessionStart Hook
    ↓
注入上下文 + 检查维护时间（超7天提醒）
    ↓
用户对话...（过程中触发存储条件立即存储）
    ↓
PreCompact Hook → 提醒存储重要知识
    ↓
Stop Hook → 检查本次会话存储
    ↓
用户运行 /my-mem-reflect → 整理记忆 + 更新维护时间
```

## 核心原则

1. **不删除，而是降级**：Active → Dormant → Archived
2. **存储带摘要**：每条记忆包含 summary 和 content 两层
3. **新颖度检测**：避免存储重复内容

## 执行步骤

### 1. 回顾本次会话

分析本次会话中：
- 读取了哪些新文件/模块
- 解决了什么问题
- 发现了什么依赖关系
- 学习了什么新知识

### 2. 检查是否需要存储

| 知识类型 | 重要性 | 存储? | 存储位置 |
|----------|--------|-------|----------|
| 新模块职责 | 0.9 | ✅ | 项目记忆 |
| 新依赖关系 | 0.7 | ✅ | 项目记忆 |
| Bug修复方案 | 0.8 | ✅ | 项目记忆 |
| 用户偏好 | 0.9 | ✅ | 全局记忆 |
| 临时信息 | 0.3 | ❌ | - |
| 已有知识 | - | ❌ | - |

### 3. 新颖度检测

存储前必须检查：

```javascript
const existing = mcp__memorygraph__search_memories({
  query: title,
  tags: tags,
  limit: 3
})

if (existing.length > 0) {
  if (isDuplicate(newContent, existing[0].content)) {
    return {action: "skip", reason: "记忆已存在"}
  } else if (isRelated(newContent, existing[0].content)) {
    return {
      action: "merge",
      memory_id: existing[0].id,
      mergedSummary: existing[0].summary + "; " + newSummary
    }
  }
}
return {action: "store"}
```

### 4. 存储格式（带摘要）

```javascript
mcp__memorygraph__store_memory({
  type: "solution",
  title: "修复: <问题>",
  summary: "<问题>由<原因>导致，通过<方案>解决",  // 必填！
  content: "## 问题\n...\n## 原因\n...\n## 解决\n...",
  tags: ["project", "bugfix"],
  importance: 0.8
})
```

### 5. 记忆降级检查

```javascript
R = importance × exp(-λ × 未访问天数)
if (R < 0.3 && importance < 0.5) {
  importance *= 0.7  // 降级而非删除
}
```

### 6. 更新维护时间记录

整理完成后，更新维护时间：

```javascript
// 写入维护时间到文件
Write({
  file_path: ".remember/.last_maintenance",
  content: new Date().toISOString()
})
```

## 输出格式

```
📊 记忆反思报告 [日期]

## 本次会话学习
- ✅ 模块: supp_workflow → 已存储（新建）
- ✅ 依赖: bm_contract → supp_fileupload → 已合并
- ⏭️ 临时调试信息 → 跳过（新颖度不足）
- ⏭️ 重复知识 → 跳过（已存在）

## 记忆统计
- 全局记忆: 5 条
- 项目记忆: 15 条
- 本次合并: 1 条

## 建议降级
| 记忆 | 当前 | 建议 | 原因 |
|------|------|------|------|
| 测试数据 | 0.5 | 0.35 | 30天未访问 |

## 维护记录已更新 ✅
下次提醒时间: 7 天后
```

## 注意事项

- **存储前必须新颖度检测**
- **每条记忆必须有 summary 字段**
- 更新/合并优先于新建
- **降级优先于删除**
- 保留用户标记的重要记忆（importance = 1.0）
- **整理完成后更新维护时间文件**
