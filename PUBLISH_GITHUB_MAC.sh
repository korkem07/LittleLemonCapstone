#!/usr/bin/env bash
# After unzipping: cd LittleLemonCapstone && bash PUBLISH_GITHUB_MAC.sh
set -euo pipefail
cd "$(dirname "$0")"
command -v git >/dev/null || { echo "Install git"; exit 1; }
command -v gh >/dev/null || { echo "Install GitHub CLI: https://cli.github.com/"; exit 1; }
gh auth status >/dev/null 2>&1 || gh auth login
login="$(gh api user --jq .login)"
repo="LittleLemonCapstone"
if [ ! -d .git ]; then git init; fi
git add -A
if ! git diff --cached --quiet; then git commit -m "Complete Little Lemon iOS capstone"; fi
git branch -M main
if gh repo view "$login/$repo" --json name >/dev/null 2>&1; then
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$login/$repo.git"
  git push -u origin main
else
  gh repo create "$repo" --public --source=. --remote=origin --push
fi
echo "SUCCESS. Paste this into Coursera: https://github.com/$login/$repo"
