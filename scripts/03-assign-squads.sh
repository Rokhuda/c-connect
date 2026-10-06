#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# 03-assign-squads.sh
# Invites candidates to the org, adds them to their squad team, and assigns
# each squad's Sprint 0 and Sprint 1 tickets round-robin across its 3 members.
#
# Fill in backlog/candidates.csv first (copy candidates.example.csv).
# ---------------------------------------------------------------------------
set -euo pipefail
: "${GH_ORG:?Set GH_ORG}"
: "${GH_REPO:=c-connect}"
FULL="$GH_ORG/$GH_REPO"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROSTER="${ROSTER:-$HERE/../backlog/candidates.csv}"
[[ -f "$ROSTER" ]] || { echo "No roster at $ROSTER — copy candidates.example.csv and fill it in"; exit 1; }

team_slug() {
  case "$1" in
    squad:identity) echo sq1-identity ;;      squad:connectivity) echo sq2-connectivity ;;
    squad:colocation) echo sq3-colocation ;;  squad:payments) echo sq4-payments ;;
    squad:energy) echo sq5-energy ;;          squad:ai) echo sq6-ai-assistant ;;
    squad:infra) echo cl1-infrastructure ;; squad:platform) echo cl2-platform ;;
    squad:cicd) echo cl3-cicd ;;              squad:sre) echo cl4-sre ;;
    *) echo "" ;;
  esac
}

echo "==> Inviting candidates and adding them to squad teams"
declare -A MEMBERS
while IFS=, read -r handle name track squad role; do
  [[ -z "${handle// }" || "$handle" == "github_handle" || "${handle:0:1}" == "#" ]] && continue
  slug=$(team_slug "$squad")
  [[ -z "$slug" ]] && { echo "  ! unknown squad '$squad' for $handle"; continue; }
  gh api -X PUT "orgs/$GH_ORG/teams/$slug/memberships/$handle" -f role=member >/dev/null 2>&1 \
    && echo "  + $handle -> $slug ($name, $role)" \
    || echo "  ! could not add $handle (check the handle and your org admin scope)"
  MEMBERS[$squad]="${MEMBERS[$squad]:-} $handle"
done < "$ROSTER"

echo
echo "==> Assigning Sprint 0 and Sprint 1 tickets round-robin within each squad"
for squad in "${!MEMBERS[@]}"; do
  read -ra people <<<"${MEMBERS[$squad]}"
  ((${#people[@]})) || continue
  i=0
  for sprint in "Sprint 0" "Sprint 1"; do
    while read -r num; do
      [[ -z "$num" ]] && continue
      who="${people[$((i % ${#people[@]}))]}"
      gh issue edit "$num" --repo "$FULL" --add-assignee "$who" >/dev/null 2>&1 \
        && echo "  #$num -> $who"
      i=$((i+1))
    done < <(gh issue list --repo "$FULL" --state open --label "$squad" \
              --milestone "$sprint" --json number --jq '.[].number')
  done
done

echo
echo "Done. Candidates still need to accept their org invite by email."
