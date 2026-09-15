#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# 00-bootstrap-repo.sh
# Creates the GitHub repo, labels, milestones, squad teams and branch protection.
#
# Prerequisites:
#   gh auth login --scopes "repo,project,read:org,admin:org,workflow"
#   jq installed
#
# Usage:
#   export GH_ORG="c-connect-wrp-2026"
#   export GH_REPO="c-connect"
#   ./scripts/00-bootstrap-repo.sh
# ---------------------------------------------------------------------------
set -euo pipefail

: "${GH_ORG:?Set GH_ORG to your GitHub organisation, e.g. export GH_ORG=c-connect-wrp-2026}"
: "${GH_REPO:=c-connect}"
FULL="$GH_ORG/$GH_REPO"

command -v gh >/dev/null || { echo "gh CLI not found"; exit 1; }
command -v jq >/dev/null || { echo "jq not found"; exit 1; }

say() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

# --------------------------------------------------------------- repository
say "Creating repository $FULL"
if gh repo view "$FULL" >/dev/null 2>&1; then
  echo "    already exists, skipping"
else
  gh repo create "$FULL" --private \
    --description "C Connect — work readiness programme project (training, not affiliated with Cassava Technologies)"
fi

# ------------------------------------------------------------------- labels
say "Creating labels"

mklabel() { gh label create "$1" --repo "$FULL" --color "$2" --description "$3" --force >/dev/null; }

# squads
mklabel "squad:identity"      "5319e7" "SQ1 — Identity & Access"
mklabel "squad:connectivity"  "1d76db" "SQ2 — Connectivity"
mklabel "squad:colocation"    "0e8a16" "SQ3 — Colocation"
mklabel "squad:payments"      "fbca04" "SQ4 — Payments & Billing"
mklabel "squad:energy"        "d93f0b" "SQ5 — Energy Telemetry"
mklabel "squad:ai"            "b60205" "SQ6 — AI Assistant"
mklabel "squad:infra"  "006b75" "CL1 — Infrastructure & IaC"
mklabel "squad:platform"      "0052cc" "CL2 — Container Platform"
mklabel "squad:cicd"          "5a32a3" "CL3 — CI/CD & Developer Experience"
mklabel "squad:sre"           "c2185b" "CL4 — Observability, SRE & FinOps"
mklabel "squad:cross-cutting" "444444" "Work spanning multiple squads"

# tracks
mklabel "track:software"      "c5def5" "Software engineering track"
mklabel "track:cloud"         "bfd4f2" "Cloud engineering track"
mklabel "devops"              "1f883d" "You build it, you run it — owned by the squad that wrote the service"

# types
mklabel "type:story"          "0075ca" "User-facing capability"
mklabel "type:task"           "cfd3d7" "Technical work"
mklabel "type:spike"          "d4c5f9" "Timeboxed investigation, output is a decision"
mklabel "type:bug"            "d73a4a" "Something is broken"
mklabel "type:chore"          "e4e669" "Housekeeping"

# priority
mklabel "P0"                  "b60205" "Blocks the sprint goal"
mklabel "P1"                  "d93f0b" "Important this sprint"
mklabel "P2"                  "fbca04" "Nice to have"
mklabel "P3"                  "0e8a16" "Someday"

# workflow
mklabel "blocked"             "000000" "Waiting on something external"
mklabel "good-first-ticket"   "7057ff" "A safe place for a first pull request"
mklabel "needs-refinement"    "e99695" "Does not yet meet Definition of Ready"

# ---------------------------------------------------------------- milestones
say "Creating milestones (sprints)"
create_milestone() {
  local title="$1" desc="$2" due="$3"
  local existing
  existing=$(gh api "repos/$FULL/milestones?state=all" --jq ".[] | select(.title==\"$title\") | .number" || true)
  if [[ -n "$existing" ]]; then echo "    $title exists"; return; fi
  gh api "repos/$FULL/milestones" -f title="$title" -f description="$desc" -f due_on="$due" >/dev/null
  echo "    $title"
}

# Adjust these dates to your programme calendar.
create_milestone "Sprint 0" "Foundations — environments, contracts, golden paths" "2026-09-11T17:00:00Z"
create_milestone "Sprint 1" "Walking skeleton — one thin slice deployed end to end" "2026-09-25T17:00:00Z"
create_milestone "Sprint 2" "Core journeys — the main customer flows work"        "2026-10-09T17:00:00Z"
create_milestone "Sprint 3" "Integration — services talk to each other"            "2026-10-23T17:00:00Z"
create_milestone "Sprint 4" "Hardening — security, cost, accessibility, resilience" "2026-11-06T17:00:00Z"
create_milestone "Sprint 5" "Showcase — polish, docs and demo day"                 "2026-11-20T17:00:00Z"

# --------------------------------------------------------------------- teams
say "Creating org teams"
if [[ -n "${SKIP_TEAMS:-}" ]]; then
  echo "    SKIP_TEAMS set — skipping team creation"
else
mkteam() {
  local slug="$1" name="$2" parent="${3:-}"
  if gh api "orgs/$GH_ORG/teams/$slug" >/dev/null 2>&1; then echo "    $slug exists"; return; fi
  if [[ -n "$parent" ]]; then
    local pid; pid=$(gh api "orgs/$GH_ORG/teams/$parent" --jq .id)
    gh api "orgs/$GH_ORG/teams" -f name="$name" -f privacy=closed -F parent_team_id="$pid" >/dev/null
  else
    gh api "orgs/$GH_ORG/teams" -f name="$name" -f privacy=closed >/dev/null
  fi
  echo "    $name"
  gh api -X PUT "orgs/$GH_ORG/teams/$slug/repos/$GH_ORG/$GH_REPO" -f permission=push >/dev/null 2>&1 || true
}

mkteam "software-track" "Software Track"
mkteam "cloud-track"    "Cloud Track"
for t in "sq1-identity:SQ1 Identity:software-track" \
         "sq2-connectivity:SQ2 Connectivity:software-track" \
         "sq3-colocation:SQ3 Colocation:software-track" \
         "sq4-payments:SQ4 Payments:software-track" \
         "sq5-energy:SQ5 Energy:software-track" \
         "sq6-ai-assistant:SQ6 AI Assistant:software-track" \
         "cl1-infrastructure:CL1 Infrastructure:cloud-track" \
         "cl2-platform:CL2 Platform:cloud-track" \
         "cl3-cicd:CL3 CICD:cloud-track" \
         "cl4-sre:CL4 SRE:cloud-track"; do
  IFS=: read -r slug name parent <<<"$t"
  mkteam "$slug" "$name" "$parent"
done

fi

# ------------------------------------------------------------------ branches
say "Creating develop branch and protecting main + develop"
DEFAULT_BRANCH=$(gh api "repos/$FULL" --jq .default_branch)
if ! gh api "repos/$FULL/branches/develop" >/dev/null 2>&1; then
  SHA=$(gh api "repos/$FULL/git/ref/heads/$DEFAULT_BRANCH" --jq .object.sha 2>/dev/null || true)
  if [[ -n "$SHA" ]]; then
    gh api -X POST "repos/$FULL/git/refs" -f ref="refs/heads/develop" -f sha="$SHA" >/dev/null
    echo "    develop created"
  else
    echo "    repo is empty — push an initial commit, then re-run this script"
  fi
fi

protect() {
  local branch="$1"
  gh api -X PUT "repos/$FULL/branches/$branch/protection" \
    --input - >/dev/null <<'JSON' || echo "    could not protect $branch (private repos need GitHub Team/Enterprise)"
{
  "required_status_checks": { "strict": true, "contexts": ["ci"] },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
}
protect "$DEFAULT_BRANCH"
protect "develop"

say "Done. Next: ./scripts/01-create-project-board.sh"
