# 常见问题

## 安装相关

### Q: 安装脚本报错 "Python not found"

**A:** 确保安装了 Python 3.8+ 并添加到 PATH。验证：
```bash
python --version
```

### Q: memorygraph 安装失败

**A:** 尝试升级 pip 后重试：
```bash
pip install --upgrade pip
pip install memorygraph
```

### Q: Windows 上脚本无法执行

**A:** 以管理员身份运行 PowerShell，执行：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 使用相关

### Q: /my-mem-init 没有反应

**A:**
1. 确认已重启 Claude Code
2. 检查 Skills 是否安装：`~/.claude/skills/my-mem-init/skill.md` 是否存在
3. 确认在项目目录中运行

### Q: 项目记忆工具不可用

**A:**
1. 检查 `.mcp.json` 是否正确创建
2. 确认已重启 Claude Code 会话
3. 检查 MCP 工具列表中是否有 `memorygraph-project`

### Q: 记忆没有被存储

**A:**
1. 确认存储时包含 `summary` 字段
2. 检查是否触发了新颖度检测（可能已存在相似记忆）
3. 手动运行 `/my-mem-reflect` 检查

---

## 记忆相关

### Q: 如何查看已存储的记忆？

**A:**
```javascript
mcp__memorygraph__recall_memories({query: "关键词", limit: 10})
```

### Q: 如何删除错误记忆？

**A:**
```javascript
mcp__memorygraph__delete_memory({memory_id: "记忆ID"})
```

### Q: 如何备份记忆？

**A:** 复制数据库文件：
- 全局：`~/.claude/memory/memory.db`
- 项目：`项目/.claude/memory/memory.db`

### Q: 记忆太多太乱怎么办？

**A:** 运行 `/my-mem-reflect` 进行整理，会：
- 合并重复记忆
- 降级过期记忆
- 清理冗余

---

## 多设备/团队协作

### Q: 如何在多台电脑使用？

**A:**
1. 在每台电脑运行安装脚本
2. 复制全局数据库 `~/.claude/memory/memory.db` 到新电脑
3. 项目级数据库随项目 git 提交

### Q: 团队如何共享项目记忆？

**A:**
1. `.claude/memory/memory.db` 可以提交到 git
2. 团队成员 clone 后自动获得项目记忆
3. 全局记忆（用户偏好）不共享

---

## 代码图相关

### Q: code-review-graph 有什么用？

**A:**
- 爆炸半径分析：改代码影响哪些文件
- 函数调用链：理解代码执行路径
- Token 节省：大项目可达 50x

### Q: 首次构建很慢怎么办？

**A:**
- 大项目首次构建需要几分钟，这是正常的
- 后续增量更新只需几秒
- 可以先用记忆系统，后续再配置代码图

---

## 故障排除

### Q: Hook 脚本报错

**A:**
1. 确认安装了 Node.js 16+
2. 检查 `.claude/settings.local.json` 中的路径是否正确
3. 查看 Claude Code 日志获取详细错误

### Q: MCP 连接失败

**A:**
1. 检查 `~/.claude.json` 配置
2. 确认 memorygraph 已安装：`memorygraph --version`
3. 重启 Claude Code
