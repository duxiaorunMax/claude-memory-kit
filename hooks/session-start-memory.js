/**
 * Session Start Hook
 * 会话开始时自动检索并注入记忆上下文
 *
 * 功能：
 * 1. 检索全局用户偏好
 * 2. 检索项目核心知识（如果在项目中）
 * 3. 检查上次维护时间，提醒用户整理记忆
 */

const fs = require('fs');
const path = require('path');

// 维护记录文件
const MAINTENANCE_FILE = '.remember/.last_maintenance';
const MAINTENANCE_INTERVAL_DAYS = 7;

function main() {
  try {
    // 读取 stdin 传入的会话信息
    let input = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('readable', () => {
      let chunk;
      while ((chunk = process.stdin.read()) !== null) {
        input += chunk;
      }
    });
    process.stdin.on('end', () => {
      processSessionStart(input);
    });
  } catch (error) {
    process.stdout.write(input || '');
  }
}

function processSessionStart(input) {
  const lines = [];

  lines.push('');
  lines.push('=== 记忆上下文注入 ===');
  lines.push('');
  lines.push('## 会话启动任务（自动执行）');
  lines.push('');
  lines.push('请执行以下记忆检索：');
  lines.push('');
  lines.push('```javascript');
  lines.push('// 1. 检索全局用户偏好');
  lines.push('mcp__memorygraph__recall_memories({query: "用户偏好", limit: 5})');
  lines.push('');
  lines.push('// 2. 检索已初始化项目列表');
  lines.push('mcp__memorygraph__search_memories({tags: ["global", "projects", "registry"], limit: 1})');
  lines.push('');
  lines.push('// 3. 检索项目核心知识（如果在项目中）');
  lines.push('mcp__memorygraph-project__recall_memories({query: "项目核心 模块依赖", limit: 10})');
  lines.push('```');
  lines.push('');
  lines.push('## 存储提醒');
  lines.push('');
  lines.push('本次会话中，遇到以下场景时立即存储：');
  lines.push('- 同一模块读取超过 3 个文件 → 存储模块知识');
  lines.push('- Bug 修复完成 → 存储解决方案');
  lines.push('- 用户说"记住" → 存储用户偏好');
  lines.push('');

  // 检查是否需要维护提醒
  const maintenanceReminder = checkMaintenanceReminder();
  if (maintenanceReminder) {
    lines.push('## ⚠️ 记忆维护提醒');
    lines.push('');
    lines.push(maintenanceReminder);
    lines.push('');
  }

  lines.push('=====================');
  lines.push('');

  process.stdout.write(lines.join('\n') + (input || ''));
}

function checkMaintenanceReminder() {
  try {
    const maintenancePath = path.join(process.cwd(), MAINTENANCE_FILE);

    // 如果文件不存在，提示需要初始化
    if (!fs.existsSync(maintenancePath)) {
      return '记忆系统尚未进行过维护整理。\n\n' +
             '👉 建议运行: `/my-mem-reflect` 进行首次记忆整理';
    }

    // 读取上次维护时间
    const content = fs.readFileSync(maintenancePath, 'utf-8');
    const lastMaintenance = new Date(content.trim());
    const now = new Date();
    const daysSince = Math.floor((now - lastMaintenance) / (1000 * 60 * 60 * 24));

    if (daysSince >= MAINTENANCE_INTERVAL_DAYS) {
      return `距上次记忆整理已过 ${daysSince} 天。\n\n` +
             `👉 建议运行: \`/my-mem-reflect\` 整理记忆`;
    }

    return null;
  } catch (error) {
    return null;
  }
}

main();
