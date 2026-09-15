#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# setup.sh — one command to stand up C Connect on GitHub.
#
#   export GH_ORG="your-github-org"
#   ./setup.sh
#
# Creates: repo, 31 labels, 6 sprint milestones, 12 squad teams,
#          branch protection, the Kanban board with custom fields,
#          and 88 seeded tickets on the board.
# ---------------------------------------------------------------------------
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

: "${GH_ORG:?Set GH_ORG first, e.g. export GH_ORG=c-connect-wrp-2026}"
export GH_REPO="${GH_REPO:-c-connect}"

step() { printf '\n\033[1;35m######  %s  ######\033[0m\n' "$*"; }

for tool in gh jq git; do
  command -v "$tool" >/dev/null || { echo "Missing: $tool"; exit 1; }
done
gh auth status >/dev/null 2>&1 || {
  echo "Not logged in. Run:"
  echo '  gh auth login --scopes "repo,project,read:org,admin:org,workflow"'
  exit 1
}

step "1/5  Repository, labels, milestones, teams"
./scripts/00-bootstrap-repo.sh

step "2/5  Pushing this scaffold"
if [ ! -d .git ]; then
  git init -q && git add -A
  git -c user.email=setup@local -c user.name="Setup" commit -qm "chore: C Connect project scaffold"
  git branch -M main
  git remote add origin "https://github.com/$GH_ORG/$GH_REPO.git"
fi
git push -u origin main 2>/dev/null || echo "    push skipped or already up to date"

step "3/5  Re-running bootstrap to create and protect develop"
./scripts/00-bootstrap-repo.sh

step "4/5  Kanban board and custom fields"
./scripts/01-create-project-board.sh

step "5/5  Seeding 132 tickets"
./scripts/02-seed-issues.sh

# shellcheck source=/dev/null
source scripts/.project-env
cat <<EOF

============================================================
  C Connect is live.

  Repo:  https://github.com/$GH_ORG/$GH_REPO
  Board: $PROJECT_URL

  Still to do:
    1. Replace ORG with "$GH_ORG" in .github/CODEOWNERS
       and .github/ISSUE_TEMPLATE/config.yml, then commit.
    2. In the board UI: set WIP limits, create the five saved
       views, enable the three built-in workflows.
       (docs/FACILITATOR-SETUP-GUIDE.md, section 2)
    3. Fill in backlog/candidates.csv and run
       ./scripts/03-assign-squads.sh
============================================================
EOF
