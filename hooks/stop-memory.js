/**
 * Stop Hook (Session End)
 * 会话结束时检查是否需要存储记忆
 *
 * 功能：
 * 1. 提示 AI 回顾本次会话
 * 2. 建议存储重要知识
 * 3. 提醒记忆整理
 */

const fs = require('fs');
const path = require('path');

const MAINTENANCE_FILE = '.remember/.last_maintenance';
const MAINTENANCE_INTERVAL_DAYS = 7;

function main() {
  try {
    let input = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('readable', () => {
      let chunk;
      while ((chunk = process.stdin.read()) !== null) {
        input += chunk;
      }
    });
    process.stdin.on('end', () => {
      processStop(input);
    });
  } catch (error) {
    process.stdout.write(input || '');
  }
}

function processStop(input) {
  const lines = [];

  lines.push('');
  lines.push('=== 会话结束记忆检查 ===');
  lines.push('');
  lines.push('## 本次会话回顾');
  lines.push('');
  lines.push('请检查本次会话是否有以下内容需要存储：');
  lines.push('');
  lines.push('- [ ] 新理解的模块/功能');
  lines.push('- [ ] 修复的问题及解决方案');
  lines.push('- [ ] 用户表达的偏好');
  lines.push('- [ ] 发现的依赖关系');
  lines.push('- [ ] 理解的业务流程');
  lines.push('');
  lines.push('## 如有，执行存储');
  lines.push('');
  lines.push('```javascript');
  lines.push('// 记得包含 summary 字段');
  lines.push('mcp__memorygraph__store_memory({');
  lines.push('  title: "...",');
  lines.push('  summary: "一句话概述",');
  lines.push('  content: "详细内容",');
  lines.push('  tags: [...],');
  lines.push('  importance: 0.8');
  lines.push('})');
  lines.push('```');
  lines.push('');

  // 检查是否需要维护提醒
  const maintenanceReminder = checkMaintenanceReminder();
  if (maintenanceReminder) {
    lines.push('## 记忆整理提醒');
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

    if (!fs.existsSync(maintenancePath)) {
      return '⚠️ 记忆系统尚未进行过维护整理\n👉 建议运行: `/my-mem-reflect`';
    }

    const content = fs.readFileSync(maintenancePath, 'utf-8');
    const lastMaintenance = new Date(content.trim());
    const now = new Date();
    const daysSince = Math.floor((now - lastMaintenance) / (1000 * 60 * 60 * 24));

    if (daysSince >= MAINTENANCE_INTERVAL_DAYS) {
      return `⚠️ 距上次记忆整理已过 ${daysSince} 天\n👉 建议运行: \`/my-mem-reflect\``;
    }

    return null;
  } catch (error) {
    return null;
  }
}

main();
