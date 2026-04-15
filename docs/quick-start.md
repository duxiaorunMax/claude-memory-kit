# 快速开始指南

## 安装步骤

### 1. 克隆或下载

```bash
git clone https://github.com/your-repo/claude-memory-kit.git
cd claude-memory-kit
```

### 2. 运行安装脚本

**Windows:**
```powershell
./install.ps1
```

**Linux/Mac:**
```bash
chmod +x install.sh
./install.sh
```

### 3. 重启 Claude Code

关闭并重新打开 Claude Code，使配置生效。

---

## 初始化项目

### 1. 进入项目目录

```bash
cd /path/to/your/project
```

### 2. 运行初始化

在 Claude Code 中输入：
```
/my-mem-init
```

### 3. 选择是否配置代码图

初始化完成后会询问是否配置代码图：
- 选 `y` → 自动安装 code-review-graph
- 选 `n` → 跳过，后续可运行 `/my-mem-codegraph`

### 4. 重启会话

重启 Claude Code 会话，项目记忆系统生效。

---

## 日常使用

### 会话开始

每次会话开始，AI 会自动：
1. 检索你的用户偏好
2. 加载项目核心知识
3. 检查是否需要整理记忆

### 开发过程中

AI 会在以下场景自动存储：
- 理解了新模块 → 存储模块知识
- 修复了 Bug → 存储解决方案
- 你说"记住" → 存储用户偏好

### 定期维护

运行 `/my-mem-reflect` 整理记忆，建议每周一次。

---

## 验证安装

### 检查全局记忆

```
在 Claude Code 中输入：
检索我的用户偏好
```

AI 应该能调用 `mcp__memorygraph__recall_memories` 工具。

### 检查项目记忆

初始化项目后，重启会话，输入：
```
检索项目核心知识
```

AI 应该能调用 `mcp__memorygraph-project__recall_memories` 工具。

---

## 下一步

- 查看 [架构设计](architecture.md) 了解系统原理
- 查看 [FAQ](faq.md) 解决常见问题
