# Claude Memory Kit 一键安装脚本 (Windows)
# 用法: ./install.ps1

param(
    [string]$MemoryDbPath = "",
    [switch]$SkipGlobal = $false
)

$ErrorActionPreference = "Stop"

Write-Host "=== Claude Memory Kit 安装程序 ===" -ForegroundColor Cyan
Write-Host ""

# 检测 Python
Write-Host "[1/5] 检测 Python 环境..." -ForegroundColor Yellow
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "错误: 未找到 Python，请先安装 Python 3.8+" -ForegroundColor Red
    exit 1
}
Write-Host "  Python: $($python.Source)" -ForegroundColor Green

# 安装 memorygraph
Write-Host ""
Write-Host "[2/5] 安装 memorygraph MCP..." -ForegroundColor Yellow
pip install memorygraph --quiet
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: memorygraph 安装失败" -ForegroundColor Red
    exit 1
}
Write-Host "  memorygraph 已安装" -ForegroundColor Green

# 安装 code-review-graph (可选)
Write-Host ""
Write-Host "[3/5] 安装 code-review-graph (可选)..." -ForegroundColor Yellow
$installCrg = Read-Host "是否安装 code-review-graph? (y/n)"
if ($installCrg -eq "y") {
    pip install code-review-graph --quiet
    Write-Host "  code-review-graph 已安装" -ForegroundColor Green
} else {
    Write-Host "  跳过 code-review-graph" -ForegroundColor Gray
}

# 配置全局 MCP
if (-not $SkipGlobal) {
    Write-Host ""
    Write-Host "[4/5] 配置全局 MemoryGraph..." -ForegroundColor Yellow

    $claudeConfigPath = "$env:USERPROFILE\.claude.json"

    # 确定数据库路径
    if ($MemoryDbPath -eq "") {
        $MemoryDbPath = "$env:USERPROFILE\.claude\memory\memory.db"
    }

    # 创建数据库目录
    $dbDir = Split-Path $MemoryDbPath -Parent
    if (-not (Test-Path $dbDir)) {
        New-Item -ItemType Directory -Path $dbDir -Force | Out-Null
    }

    # 读取现有配置
    if (Test-Path $claudeConfigPath) {
        $config = Get-Content $claudeConfigPath -Raw | ConvertFrom-Json
    } else {
        $config = @{}
    }

    # 添加 memorygraph MCP
    $memorygraphConfig = @{
        type = "stdio"
        command = "$env:USERPROFILE\.local\bin\memorygraph.exe"
        args = @()
        env = @{
            MEMORY_SQLITE_PATH = $MemoryDbPath
        }
    }

    if (-not $config.mcpServers) {
        $config | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue @{} -Force
    }

    # 转换为 PSCustomObject 以便添加属性
    $mcpServers = $config.mcpServers
    if ($mcpServers -is [System.Management.Automation.PSCustomObject]) {
        $mcpServers | Add-Member -NotePropertyName "memorygraph" -NotePropertyValue $memorygraphConfig -Force
    }

    # 保存配置
    $config | ConvertTo-Json -Depth 10 | Set-Content $claudeConfigPath -Encoding UTF8
    Write-Host "  全局配置已更新: $claudeConfigPath" -ForegroundColor Green
    Write-Host "  数据库路径: $MemoryDbPath" -ForegroundColor Gray
}

# 复制 Skills
Write-Host ""
Write-Host "[5/5] 安装 Skills..." -ForegroundColor Yellow

$skillsDir = "$env:USERPROFILE\.claude\skills"
if (-not (Test-Path $skillsDir)) {
    New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
}

# 复制 my-mem-init skill
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$initSkillDir = "$skillsDir\my-mem-init"
if (-not (Test-Path $initSkillDir)) {
    New-Item -ItemType Directory -Path $initSkillDir -Force | Out-Null
}
Copy-Item "$scriptDir\skills\my-mem-init.md" "$initSkillDir\skill.md" -Force
Write-Host "  my-mem-init 已安装" -ForegroundColor Green

# 复制 my-mem-reflect skill
$reflectSkillDir = "$skillsDir\my-mem-reflect"
if (-not (Test-Path $reflectSkillDir)) {
    New-Item -ItemType Directory -Path $reflectSkillDir -Force | Out-Null
}
Copy-Item "$scriptDir\skills\my-mem-reflect.md" "$reflectSkillDir\skill.md" -Force
Write-Host "  my-mem-reflect 已安装" -ForegroundColor Green

# 复制 my-mem-codegraph skill
$codegraphSkillDir = "$skillsDir\my-mem-codegraph"
if (-not (Test-Path $codegraphSkillDir)) {
    New-Item -ItemType Directory -Path $codegraphSkillDir -Force | Out-Null
}
Copy-Item "$scriptDir\skills\my-mem-codegraph.md" "$codegraphSkillDir\skill.md" -Force
Write-Host "  my-mem-codegraph 已安装" -ForegroundColor Green

# 复制模板到全局
$templatesDest = "$env:USERPROFILE\.claude\memory-templates"
if (-not (Test-Path $templatesDest)) {
    New-Item -ItemType Directory -Path $templatesDest -Force | Out-Null
}
Copy-Item "$scriptDir\templates\*" $templatesDest -Recurse -Force
Write-Host "  模板已安装到: $templatesDest" -ForegroundColor Green

Write-Host ""
Write-Host "=== 安装完成 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步:" -ForegroundColor White
Write-Host "1. 重启 Claude Code 使配置生效" -ForegroundColor Gray
Write-Host "2. 在项目目录运行 /my-mem-init 初始化项目记忆" -ForegroundColor Gray
Write-Host ""
