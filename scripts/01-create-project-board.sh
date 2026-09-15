#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# 01-create-project-board.sh
# Creates the "C Connect Delivery" Kanban board (GitHub Projects v2),
# adds the custom fields, links it to the repo, and rewrites the built-in
# Status column options to the full Kanban flow.
#
# Writes scripts/.project-env so 02-seed-issues.sh can find the board.
# ---------------------------------------------------------------------------
set -euo pipefail

: "${GH_ORG:?Set GH_ORG}"
: "${GH_REPO:=c-connect}"
BOARD_TITLE="${BOARD_TITLE:-C Connect Delivery}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

say() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

# ------------------------------------------------------------ create board
say "Creating project board: $BOARD_TITLE"
EXISTING=$(gh project list --owner "$GH_ORG" --format json \
  | jq -r --arg t "$BOARD_TITLE" '.projects[] | select(.title==$t) | .number' | head -1)

if [[ -n "$EXISTING" ]]; then
  NUMBER="$EXISTING"; echo "    already exists (#$NUMBER)"
else
  NUMBER=$(gh project create --owner "$GH_ORG" --title "$BOARD_TITLE" --format json | jq -r .number)
  echo "    created #$NUMBER"
fi

PROJECT_ID=$(gh project view "$NUMBER" --owner "$GH_ORG" --format json | jq -r .id)
PROJECT_URL=$(gh project view "$NUMBER" --owner "$GH_ORG" --format json | jq -r .url)

# --------------------------------------------------------- link to the repo
say "Linking board to $GH_ORG/$GH_REPO"
gh project link "$NUMBER" --owner "$GH_ORG" --repo "$GH_ORG/$GH_REPO" >/dev/null 2>&1 \
  || echo "    link failed or already linked"

# --------------------------------------------- rewrite built-in Status field
say "Setting Kanban columns on the Status field"
STATUS_FIELD_ID=$(gh project field-list "$NUMBER" --owner "$GH_ORG" --format json \
  | jq -r '.fields[] | select(.name=="Status") | .id')

if [[ -n "$STATUS_FIELD_ID" && "$STATUS_FIELD_ID" != "null" ]]; then
  gh api graphql -f query='
    mutation($field: ID!) {
      updateProjectV2Field(input: {
        fieldId: $field,
        singleSelectOptions: [
          {name: "Backlog",     color: GRAY,   description: "Raised, not yet refined"},
          {name: "Ready",       color: BLUE,   description: "Meets Definition of Ready"},
          {name: "In Progress", color: YELLOW, description: "Actively being worked — max 2 per person"},
          {name: "In Review",   color: PURPLE, description: "Pull request open"},
          {name: "Testing",     color: ORANGE, description: "On staging, being verified"},
          {name: "Blocked",     color: RED,    description: "Waiting on something external"},
          {name: "Done",        color: GREEN,  description: "Meets Definition of Done"}
        ]
      }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } }
    }' -f field="$STATUS_FIELD_ID" >/dev/null \
    && echo "    Status columns set" \
    || echo "    Could not rewrite Status via API — set the columns by hand at $PROJECT_URL/settings"
fi

# ----------------------------------------------------------- custom fields
say "Creating custom fields"
mkfield() {
  local name="$1" type="$2" opts="${3:-}"
  local exists
  exists=$(gh project field-list "$NUMBER" --owner "$GH_ORG" --format json \
    | jq -r --arg n "$name" '.fields[] | select(.name==$n) | .id')
  if [[ -n "$exists" ]]; then echo "    $name exists"; return; fi
  if [[ -n "$opts" ]]; then
    gh project field-create "$NUMBER" --owner "$GH_ORG" --name "$name" \
      --data-type "$type" --single-select-options "$opts" >/dev/null
  else
    gh project field-create "$NUMBER" --owner "$GH_ORG" --name "$name" --data-type "$type" >/dev/null
  fi
  echo "    $name"
}

mkfield "Squad" SINGLE_SELECT "SQ1 Identity,SQ2 Connectivity,SQ3 Colocation,SQ4 Payments,SQ5 Energy,SQ6 AI Assistant,CL1 Infrastructure,CL2 Platform,CL3 CI/CD,CL4 SRE & FinOps,Cross-cutting"
mkfield "Track" SINGLE_SELECT "Software,Cloud,Cross-cutting"
mkfield "Priority" SINGLE_SELECT "P0,P1,P2,P3"
mkfield "Sprint" SINGLE_SELECT "Sprint 0,Sprint 1,Sprint 2,Sprint 3,Sprint 4,Sprint 5"
mkfield "Estimate" NUMBER

# ------------------------------------------------------------------- output
cat > "$HERE/.project-env" <<EOF
PROJECT_NUMBER=$NUMBER
PROJECT_ID=$PROJECT_ID
PROJECT_URL=$PROJECT_URL
EOF

say "Board ready: $PROJECT_URL"
cat <<'NEXT'

Two things still to do by hand in the board UI (about five minutes):

  1. Set WIP limits per column       — see docs/WAYS-OF-WORKING.md
  2. Create the saved views          — Kanban, By squad, My work, Blocked & aging, Cloud platform
  3. Turn on the built-in workflows  — Settings > Workflows:
       "Item added to project"  -> set Status = Backlog
       "Pull request merged"    -> set Status = Testing
       "Item closed"            -> set Status = Done

Next: ./scripts/02-seed-issues.sh
NEXT
