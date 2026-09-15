# Facilitator Setup Guide

Everything needed to go from nothing to 30 candidates working a live Kanban board.
Budget about **two hours** for the setup, plus a half-day cohort onboarding session.

---

## 0. Before you start

| Need | Detail |
|---|---|
| GitHub organisation | Create one, e.g. `c-connect-wrp-2026`. **GitHub Team plan** if you want branch protection on private repos; otherwise make the repo public and use the Free plan. |
| GitHub CLI | `gh --version` ≥ 2.40, plus `jq` |
| Auth scopes | `gh auth login --scopes "repo,project,read:org,admin:org,workflow"` |
| Cloud account | One account/subscription with a hard budget cap and billing alerts, before day one |
| Candidate handles | 30 GitHub usernames collected in advance — chasing these later costs you a day |

**Set your budget cap first.** Thirty people learning cloud without a cap is the most
common way these programmes lose money in week two.

---

## 1. Run the scripts

```bash
git clone <this-scaffold> c-connect && cd c-connect

export GH_ORG="c-connect-wrp-2026"
export GH_REPO="c-connect"

./scripts/00-bootstrap-repo.sh        # repo, 31 labels, 6 milestones, 12 teams, protection
./scripts/01-create-project-board.sh  # Projects v2 board + custom fields
./scripts/02-seed-issues.sh           # 132 tickets onto the board
```

If the repo is empty, `00-bootstrap-repo.sh` will tell you to push an initial commit
before it can create `develop`. Do this, then re-run it:

```bash
git init && git add . && git commit -m "chore: project scaffold"
git branch -M main
git remote add origin "git@github.com:$GH_ORG/$GH_REPO.git"
git push -u origin main
```

Then edit `.github/CODEOWNERS` and `.github/ISSUE_TEMPLATE/config.yml`, replacing `ORG`
with your real org name, and commit.

---

## 2. Finish the board by hand (about five minutes)

The GitHub API cannot do these three things, so do them in the board UI:

1. **WIP limits** — on each column's `⋯` menu, set the limit from
   `docs/WAYS-OF-WORKING.md`. `In Progress` is the one that matters.
2. **Saved views** — create the five views listed in the same document. The
   **By squad** view is what each stand-up runs from.
3. **Built-in workflows** — Project → Settings → Workflows, enable:
   - *Item added to project* → set `Status` = **Backlog**
   - *Pull request merged* → set `Status` = **Testing**
   - *Item closed* → set `Status` = **Done**

That third one is what makes the board stay accurate without nagging anyone.

---

## 3. Onboard the 30 candidates

```bash
cp backlog/candidates.example.csv backlog/candidates.csv
# fill in real handles, names, tracks and squads
./scripts/03-assign-squads.sh
```

This invites everyone to the org, adds them to their squad team, and assigns the
Sprint 0 and Sprint 1 tickets round-robin within each squad.

Candidates still have to accept the org invite from their email. Check on day one
who has not — there are always three.

---

## 4. Cohort kickoff agenda (half a day)

| Time | Session |
|---|---|
| 30 min | The brief. Read `docs/PROJECT-BRIEF.md` together. Personas, the open-source stack, what is out of scope. |
| 20 min | **Why this is hard on purpose.** Read `docs/COMPETENCY-FRAMEWORK.md` together — the escalation ladder, and the fact that facilitators will not rescue them. Agree to it out loud (ticket `XX-04`). |
| 20 min | Squad reveal and introductions. Each squad picks a name. |
| 45 min | Board walkthrough. Everyone opens the board, finds their ticket, moves one card. Practise the whole loop on a throwaway ticket. |
| 30 min | Git and PR workflow live demo. One volunteer does branch → commit → PR → review → merge on the projector, while everyone follows along. |
| 60 min | First refinement. Each squad refines its Sprint 0 tickets to Definition of Ready. |
| 30 min | Rules of engagement. WIP limits, escalation, the 4-hour blocked rule, how to ask for help. |
| 15 min | Cloud budget and the cost dashboard. Show them what a forgotten environment costs. |

---

## 5. Running the programme

**Daily, 15 minutes per squad.** Stand around the board, not around a table.
Three questions, per card not per person: what moved, what is stuck, what is next.

**Weekly.** Refinement Wednesday. Cloud squad office hours. Publish the cost report.

**Every 10 working days.** Day 8 code freeze at 16:00, day 9 stabilise, day 10 demo,
retro, and rotate the squad roles. Full shape in `docs/SPRINT-RHYTHM.md`.

**Watch for these failure modes:**

| Symptom | What it usually means | Response |
|---|---|---|
| Cards sitting in **In Review** | Nobody is reviewing | Make review the first thing after stand-up, before new work |
| One person's name on everything | The squad has a hero and two spectators | Force role rotation; assign the hero to review-only for a sprint |
| Nothing in **Blocked**, but velocity is flat | People are stuck silently | Enforce the 4-hour rule out loud for a week |
| Cloud squads idle in Sprint 0 | Product squads have nothing to deploy yet | Cloud squads build the golden path against a hello-world service |
| Cloud squads deploying other squads' services | The platform team is being too helpful | Redirect to office hours. Software squads own `D1`–`D6` for their own service |
| Candidates asking you first | The escalation ladder is not being enforced | Hold the three-question budget. Answer with questions for a week |
| Board diverges from reality | The board is being updated for the facilitator, not for the squad | Run stand-up *only* off the board and never ask for a verbal status |

---

## 6. Assessment

Assess what the board and repo already record — do not invent a separate rubric that
requires new evidence.

| Dimension | Evidence |
|---|---|
| Delivery | Tickets moved to Done, points completed, cycle time |
| Code quality | PR size, test coverage on their own changes, review comments received |
| Collaboration | Reviews given, quality of review comments, pairing across squads |
| Communication | Demo presentations, ADR clarity, ticket write-ups |
| Ownership | Bugs raised on their own work, incidents handled, runbooks written |
| Growth | Sprint 0 output compared with Sprint 5 output |

Export the raw data for scoring:

```bash
gh issue list --repo "$GH_ORG/$GH_REPO" --state all --limit 500 \
  --json number,title,assignees,labels,milestone,closedAt,state > assessment-issues.json

gh pr list --repo "$GH_ORG/$GH_REPO" --state all --limit 500 \
  --json number,author,additions,deletions,reviews,mergedAt > assessment-prs.json
```

---

## 7. Guardrails

- **Naming.** Call it a training project everywhere. Do not use Cassava Technologies
  logos, trademarks, real APIs or real customer data. Get written sign-off from the
  company before using their name in anything public-facing or on candidate CVs.
- **Data.** All data comes from the synthetic generator in ticket `XX-03`. No exceptions.
- **Payments.** Sandbox provider only. No real cards, no real money, no PCI scope.
- **Cloud spend.** Hard cap plus alerts at 50%, 80% and 100%. CL4 owns the weekly report.
- **Access.** Candidates get `write` on the repo. Only facilitators get `admin`.
  Nobody gets long-lived cloud credentials; use short-lived federated access from CI.
