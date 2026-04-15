#!/bin/bash
# Claude Memory Kit 一键安装脚本 (Linux/Mac)
# 用法: ./install.sh

set -e

echo "=== Claude Memory Kit 安装程序 ==="
echo ""

# 检测 Python
echo "[1/5] 检测 Python 环境..."
if ! command -v python3 &> /dev/null; then
    echo "错误: 未找到 Python，请先安装 Python 3.8+"
    exit 1
fi
echo "  Python: $(which python3)"

# 安装 memorygraph
echo ""
echo "[2/5] 安装 memorygraph MCP..."
pip3 install memorygraph --quiet
echo "  memorygraph 已安装"

# 安装 code-review-graph (可选)
echo ""
echo "[3/5] 安装 code-review-graph (可选)..."
read -p "是否安装 code-review-graph? (y/n): " install_crg
if [ "$install_crg" = "y" ]; then
    pip3 install code-review-graph --quiet
    echo "  code-review-graph 已安装"
else
    echo "  跳过 code-review-graph"
fi

# 配置全局 MCP
echo ""
echo "[4/5] 配置全局 MemoryGraph..."

CLAUDE_CONFIG="$HOME/.claude.json"
MEMORY_DB_PATH="$HOME/.claude/memory/memory.db"

# 创建数据库目录
mkdir -p "$(dirname "$MEMORY_DB_PATH")"

# 创建或更新配置
if [ -f "$CLAUDE_CONFIG" ]; then
    # 使用 Python 更新 JSON
    python3 << EOF
import json

with open("$CLAUDE_CONFIG", "r") as f:
    config = json.load(f)

if "mcpServers" not in config:
    config["mcpServers"] = {}

config["mcpServers"]["memorygraph"] = {
    "type": "stdio",
    "command": "$HOME/.local/bin/memorygraph",
    "args": [],
    "env": {
        "MEMORY_SQLITE_PATH": "$MEMORY_DB_PATH"
    }
}

with open("$CLAUDE_CONFIG", "w") as f:
    json.dump(config, f, indent=2)

print("  全局配置已更新")
EOF
else
    python3 << EOF
import json

config = {
    "mcpServers": {
        "memorygraph": {
            "type": "stdio",
            "command": "$HOME/.local/bin/memorygraph",
            "args": [],
            "env": {
                "MEMORY_SQLITE_PATH": "$MEMORY_DB_PATH"
            }
        }
    }
}

with open("$CLAUDE_CONFIG", "w") as f:
    json.dump(config, f, indent=2)

print("  全局配置已创建")
EOF
fi

echo "  数据库路径: $MEMORY_DB_PATH"

# 复制 Skills
echo ""
echo "[5/5] 安装 Skills..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

mkdir -p "$SKILLS_DIR"

# 复制 my-mem-init skill
mkdir -p "$SKILLS_DIR/my-mem-init"
cp "$SCRIPT_DIR/skills/my-mem-init.md" "$SKILLS_DIR/my-mem-init/skill.md"
echo "  my-mem-init 已安装"

# 复制 my-mem-reflect skill
mkdir -p "$SKILLS_DIR/my-mem-reflect"
cp "$SCRIPT_DIR/skills/my-mem-reflect.md" "$SKILLS_DIR/my-mem-reflect/skill.md"
echo "  my-mem-reflect 已安装"

# 复制 my-mem-codegraph skill
mkdir -p "$SKILLS_DIR/my-mem-codegraph"
cp "$SCRIPT_DIR/skills/my-mem-codegraph.md" "$SKILLS_DIR/my-mem-codegraph/skill.md"
echo "  my-mem-codegraph 已安装"

# 复制模板到全局
TEMPLATES_DEST="$HOME/.claude/memory-templates"
mkdir -p "$TEMPLATES_DEST"
cp -r "$SCRIPT_DIR/templates/"* "$TEMPLATES_DEST/"
echo "  模板已安装到: $TEMPLATES_DEST"

echo ""
echo "=== 安装完成 ==="
echo ""
echo "下一步:"
echo "1. 重启 Claude Code 使配置生效"
echo "2. 在项目目录运行 /my-mem-init 初始化项目记忆"
echo ""
