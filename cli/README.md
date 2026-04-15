# CLI 工具说明

本项目包含一个可选的 CLI 工具 `memory-cli`，用于记忆系统的高级维护。

## 安装

```bash
cd cli
pip install -e .
```

## 命令

```bash
memory-cli init -n <项目名>     # 初始化项目
memory-cli eval --quick         # 快速评估记忆系统
memory-cli maintain             # 维护记忆
memory-cli status               # 查看状态
```

## 是否必须？

**不需要 CLI 也可以使用记忆系统。**

CLI 主要用于：
- 自动化批量维护
- 脚本集成
- 高级诊断

日常使用推荐用 Skills：
- `/my-mem-init` - 初始化
- `/my-mem-reflect` - 整理
- `/my-mem-codegraph` - 代码图
