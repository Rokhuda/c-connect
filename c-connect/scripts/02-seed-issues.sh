#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# 02-seed-issues.sh
# Reads backlog/backlog.psv, creates one GitHub issue per row, adds it to the
# Kanban board and sets Squad / Track / Priority / Sprint / Estimate / Status.
#
# Safe to re-run: rows whose title already exists as an issue are skipped.
#
# Usage:
#   export GH_ORG=... GH_REPO=c-connect
#   ./scripts/02-seed-issues.sh              # everything
#   ./scripts/02-seed-issues.sh "Sprint 0"   # one sprint only
# ---------------------------------------------------------------------------
set -euo pipefail

: "${GH_ORG:?Set GH_ORG}"
: "${GH_REPO:=c-connect}"
FULL="$GH_ORG/$GH_REPO"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKLOG="${BACKLOG:-$HERE/../backlog/backlog.psv}"
ONLY_SPRINT="${1:-}"

# shellcheck source=/dev/null
source "$HERE/.project-env" 2>/dev/null || { echo "Run 01-create-project-board.sh first"; exit 1; }

say() { printf '\033[1;36m==> %s\033[0m\n' "$*"; }

# ------------------------------------------------- cache project field metadata
FIELDS_JSON=$(gh project field-list "$PROJECT_NUMBER" --owner "$GH_ORG" --format json)
field_id()  { jq -r --arg n "$1" '.fields[] | select(.name==$n) | .id' <<<"$FIELDS_JSON"; }
option_id() { jq -r --arg n "$1" --arg o "$2" \
  '.fields[] | select(.name==$n) | .options[] | select(.name==$o) | .id' <<<"$FIELDS_JSON"; }

F_STATUS=$(field_id "Status");  F_SQUAD=$(field_id "Squad")
F_TRACK=$(field_id "Track");    F_PRIORITY=$(field_id "Priority")
F_SPRINT=$(field_id "Sprint");  F_ESTIMATE=$(field_id "Estimate")

# map squad label -> Squad field option name
squad_option() {
  case "$1" in
    squad:identity)      echo "SQ1 Identity" ;;
    squad:connectivity)  echo "SQ2 Connectivity" ;;
    squad:colocation)    echo "SQ3 Colocation" ;;
    squad:payments)      echo "SQ4 Payments" ;;
    squad:energy)        echo "SQ5 Energy" ;;
    squad:ai)            echo "SQ6 AI Assistant" ;;
    squad:infra)  echo "CL1 Infrastructure" ;;
    squad:platform)      echo "CL2 Platform" ;;
    squad:cicd)          echo "CL3 CI/CD" ;;
    squad:sre)           echo "CL4 SRE & FinOps" ;;
    *)                   echo "Cross-cutting" ;;
  esac
}

track_label() {
  case "$1" in Software) echo "track:software" ;; Cloud) echo "track:cloud" ;; *) echo "" ;; esac
}

set_select() { # item_id field_id option_id
  [[ -z "$3" || "$3" == "null" ]] && return 0
  gh project item-edit --id "$1" --project-id "$PROJECT_ID" --field-id "$2" \
     --single-select-option-id "$3" >/dev/null 2>&1 || true
}

created=0; skipped=0

while IFS='|' read -r ref track squad sprint type priority estimate title summary; do
  [[ -z "${ref// }" || "${ref:0:1}" == "#" ]] && continue
  [[ -n "$ONLY_SPRINT" && "$sprint" != "$ONLY_SPRINT" ]] && continue

  # idempotency: skip if an issue with this ref prefix already exists
  if gh issue list --repo "$FULL" --state all --search "\"[$ref]\" in:title" --json title \
       --jq 'length' 2>/dev/null | grep -qv '^0$'; then
    skipped=$((skipped+1)); continue
  fi

  body=$(cat <<EOF
> **$ref** · $track · $sprint · $priority · estimate $estimate

## Summary
$summary

## Acceptance criteria
- [ ] _Refine these with your squad before moving this ticket to **Ready**._
- [ ] 
- [ ] 

## Definition of Done
See [docs/WAYS-OF-WORKING.md](../blob/develop/docs/WAYS-OF-WORKING.md#definition-of-done).
Short version: reviewed, tested, CI green, scanned, documented, deployed to staging, demoed.

## Notes for the squad
- Break this into smaller tickets if it will take one person more than two days.
- If you make a design decision here, write an ADR and link it in a comment.
EOF
)

  labels="$squad,type:$type,$priority"
  tl=$(track_label "$track"); [[ -n "$tl" ]] && labels="$labels,$tl"
  [[ "$sprint" == "Sprint 0" ]] && labels="$labels,good-first-ticket"
  [[ "$ref" =~ -D[0-9]$ ]] && labels="$labels,devops"

  url=$(gh issue create --repo "$FULL" \
        --title "[$ref] $title" \
        --body "$body" \
        --label "$labels" \
        --milestone "$sprint")

  item_id=$(gh project item-add "$PROJECT_NUMBER" --owner "$GH_ORG" --url "$url" --format json | jq -r .id)

  set_select "$item_id" "$F_STATUS"   "$(option_id "Status"   "Backlog")"
  set_select "$item_id" "$F_SQUAD"    "$(option_id "Squad"    "$(squad_option "$squad")")"
  set_select "$item_id" "$F_TRACK"    "$(option_id "Track"    "$track")"
  set_select "$item_id" "$F_PRIORITY" "$(option_id "Priority" "$priority")"
  set_select "$item_id" "$F_SPRINT"   "$(option_id "Sprint"   "$sprint")"
  gh project item-edit --id "$item_id" --project-id "$PROJECT_ID" \
     --field-id "$F_ESTIMATE" --number "$estimate" >/dev/null 2>&1 || true

  created=$((created+1))
  printf '  [%s] %s\n' "$ref" "$title"
done < "$BACKLOG"

say "Created $created issues, skipped $skipped already present"
say "Board: $PROJECT_URL"
echo
echo "Now move the Sprint 0 tickets from Backlog to Ready with each squad during refinement."
