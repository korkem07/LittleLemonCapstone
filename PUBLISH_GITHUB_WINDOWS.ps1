# Little Lemon Capstone: create & publish your own public GitHub repository.
# Requires Git and GitHub CLI (gh). Run in PowerShell after unzipping the project.
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is not installed. Install Git for Windows first.'
}
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw 'GitHub CLI (gh) is not installed. Install it from https://cli.github.com/.'
}

& gh auth status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Please sign in to YOUR GitHub account:' -ForegroundColor Yellow
    & gh auth login
    if ($LASTEXITCODE -ne 0) { throw 'GitHub login failed.' }
}

$login = (& gh api user --jq .login).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($login)) {
    throw 'Could not determine your GitHub username.'
}
$repo = 'LittleLemonCapstone'

& git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) { & git init }
if ($LASTEXITCODE -ne 0) { throw 'git init failed.' }

& git add -A
if ($LASTEXITCODE -ne 0) { throw 'git add failed.' }
& git diff --cached --quiet
if ($LASTEXITCODE -eq 1) {
    & git commit -m 'Complete Little Lemon iOS capstone'
    if ($LASTEXITCODE -ne 0) {
        throw 'git commit failed. You may need git config --global user.name and user.email.'
    }
}
& git branch -M main
if ($LASTEXITCODE -ne 0) { throw 'Could not set branch main.' }

& gh repo view "$login/$repo" --json name *> $null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Repository $login/$repo already exists. Pushing updates..."
    & git remote get-url origin *> $null
    if ($LASTEXITCODE -ne 0) {
        & git remote add origin "https://github.com/$login/$repo.git"
    }
    & git push -u origin main
    if ($LASTEXITCODE -ne 0) { throw 'Failed to push. Check your access permissions and remote URL.' }
} else {
    Write-Host 'Creating a PUBLIC GitHub repository and uploading files...' -ForegroundColor Yellow
    & gh repo create $repo --public --source=. --remote=origin --push
    if ($LASTEXITCODE -ne 0) { throw 'GitHub repo creation or upload failed.' }
}

Write-Host ''
Write-Host 'SUCCESS. Copy this link into Coursera:' -ForegroundColor Green
Write-Host "https://github.com/$login/$repo" -ForegroundColor Cyan
Write-Host 'Project title: Little Lemon iOS Capstone Project'
