/**
 * Pre-Compact Hook
 * 上下文压缩前自动存储重要知识
 *
 * 功能：
 * 1. 检测本次会话是否有重要知识
 * 2. 输出存储提醒
 * 3. 提醒记忆整理
 */

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
      processPreCompact(input);
    });
  } catch (error) {
    process.stdout.write(input || '');
  }
}

function processPreCompact(input) {
  const lines = [];

  lines.push('');
  lines.push('=== 压缩前记忆存储 ===');
  lines.push('');
  lines.push('## 请检查是否需要存储以下内容：');
  lines.push('');
  lines.push('| 场景 | 存储内容 | 工具 |');
  lines.push('|------|----------|------|');
  lines.push('| 本次理解了新模块 | 模块职责、核心类、依赖 | store_memory |');
  lines.push('| 本次修复了 Bug | 问题+原因+解决方案 | store_memory |');
  lines.push('| 用户表达了偏好 | 偏好内容 | store_memory (全局) |');
  lines.push('| 发现了依赖关系 | A 依赖 B | create_relationship |');
  lines.push('');
  lines.push('## 存储格式');
  lines.push('');
  lines.push('```javascript');
  lines.push('mcp__memorygraph__store_memory({');
  lines.push('  type: "solution",  // 或 technology, general');
  lines.push('  title: "标题",');
  lines.push('  summary: "一句话概述",  // 必填');
  lines.push('  content: "详细内容...",');
  lines.push('  tags: ["项目名", "类型"],');
  lines.push('  importance: 0.8');
  lines.push('})');
  lines.push('```');
  lines.push('');
  lines.push('## 记忆整理');
  lines.push('');
  lines.push('如发现记忆混乱或有重复，可运行：');
  lines.push('👉 `/my-mem-reflect` 进行记忆整理');
  lines.push('');
  lines.push('=====================');
  lines.push('');

  process.stdout.write(lines.join('\n') + (input || ''));
}

main();
