<#
.SYNOPSIS
Install the Startup Stress Test skills into local agent skill directories (Windows).

.EXAMPLE
.\scripts\install.ps1 -Target claude-code,codex -Scope user -Lang both

.EXAMPLE
.\scripts\install.ps1 -Target all -Scope project -Lang zh -Force

.EXAMPLE
.\scripts\install.ps1 -DryRun
#>
[CmdletBinding()]
param(
    [string]$Target = "claude-code,codex",
    [ValidateSet("user", "project")]
    [string]$Scope = "user",
    [ValidateSet("en", "zh", "both")]
    [string]$Lang = "both",
    [string]$ProjectRoot = (Get-Location).Path,
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$SkillsDir = Join-Path $RepoRoot "skills"
$UserHome = $env:USERPROFILE

switch ($Lang) {
    "en"   { $SkillNames = @("startup-stress-test") }
    "zh"   { $SkillNames = @("startup-stress-test-zh") }
    "both" { $SkillNames = @("startup-stress-test", "startup-stress-test-zh") }
}

if ($Target -eq "all") { $Target = "claude-code,codex,copilot" }
$TargetList = $Target.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

$DestRoots = @()
foreach ($item in $TargetList) {
    switch ($item) {
        "claude-code" {
            if ($Scope -eq "user") { $DestRoots += (Join-Path $UserHome ".claude\skills") }
            else { $DestRoots += (Join-Path $ProjectRoot ".claude\skills") }
        }
        "codex" {
            if ($Scope -eq "user") { $DestRoots += (Join-Path $UserHome ".agents\skills") }
            else { $DestRoots += (Join-Path $ProjectRoot ".agents\skills") }
        }
        "agents" {
            if ($Scope -eq "user") { $DestRoots += (Join-Path $UserHome ".agents\skills") }
            else { $DestRoots += (Join-Path $ProjectRoot ".agents\skills") }
        }
        "copilot" {
            if ($Scope -eq "user") {
                Write-Warning "GitHub Copilot skills are project-scoped; skipping user scope for 'copilot'."
            }
            else { $DestRoots += (Join-Path $ProjectRoot ".github\skills") }
        }
        default { throw "Unknown -Target value '$item'. Use: claude-code, codex, copilot, agents, all" }
    }
}

$UniqueRoots = @()
foreach ($root in $DestRoots) {
    if ($UniqueRoots -notcontains $root) { $UniqueRoots += $root }
}

Write-Host "Repository : $RepoRoot"
Write-Host "Scope      : $Scope"
Write-Host "Languages  : $Lang ($($SkillNames -join ', '))"
Write-Host "Targets    : $($UniqueRoots -join ', ')"
if ($DryRun) { Write-Host "Mode       : DRY RUN (no changes)" }
Write-Host ("-" * 60)

$Stamp = Get-Date -Format "yyyyMMddHHmmss"
$Installed = 0

foreach ($destRoot in $UniqueRoots) {
    foreach ($name in $SkillNames) {
        $src = Join-Path $SkillsDir $name
        $dest = Join-Path $destRoot $name

        if (-not (Test-Path -LiteralPath (Join-Path $src "SKILL.md"))) {
            throw "Missing skill source: $src\SKILL.md"
        }

        if (Test-Path -LiteralPath $dest) {
            if (-not $Force) {
                Write-Host "SKIP    $dest (already exists; use -Force to replace)"
                continue
            }
            $backupName = "$name.bak.$Stamp"
            $backupPath = Join-Path $destRoot $backupName
            Write-Host "BACKUP  $dest -> $backupPath"
            if (-not $DryRun) { Rename-Item -LiteralPath $dest -NewName $backupName }
        }

        Write-Host "INSTALL $src -> $dest"
        if (-not $DryRun) {
            if (-not (Test-Path -LiteralPath $destRoot)) {
                New-Item -ItemType Directory -Path $destRoot -Force | Out-Null
            }
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            Copy-Item -Path (Join-Path $src "*") -Destination $dest -Recurse -Force
        }
        $Installed += 1
    }
}

Write-Host ""
if ($DryRun) {
    Write-Host "Dry run complete: $Installed install(s) planned."
}
else {
    Write-Host "Done: $Installed install(s). Restart your agent (or run /reload-plugins in Claude Code) to pick up the skills."
    Write-Host "Claude Code: /startup-stress-test or just describe your startup idea."
    Write-Host 'Codex CLI  : $startup-stress-test (or let it match your prompt automatically).'
}
