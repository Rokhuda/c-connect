# Ways of Working

## The Kanban board

The board is **C Connect Delivery** (GitHub Projects v2). Every ticket lives here.
If it is not on the board, it is not work.

### Columns and WIP limits

| Column | Meaning | WIP limit |
|---|---|---|
| **Backlog** | Raised, not yet refined. No estimate needed. | — |
| **Ready** | Meets Definition of Ready. Anyone on the squad could pick it up. | 12 per squad |
| **In Progress** | Someone is actively working it. Assignee is set. | **2 per person** |
| **In Review** | PR is open and awaiting review. | 4 per squad |
| **Testing** | Merged to `develop`, deployed to staging, being verified. | 6 per squad |
| **Blocked** | Waiting on something external. Must have a `blocked-by` comment. | — |
| **Done** | Meets Definition of Done, deployed, demoed. | — |

The **2-per-person WIP limit in `In Progress`** is the single most important rule.
Starting a third ticket means stopping and helping someone finish theirs instead.

### Custom fields on the board

| Field | Type | Values |
|---|---|---|
| `Status` | single select | Backlog, Ready, In Progress, In Review, Testing, Blocked, Done |
| `Squad` | single select | the 10 squad names |
| `Track` | single select | Software, Cloud, Cross-cutting |
| `Priority` | single select | P0, P1, P2, P3 |
| `Estimate` | number | story points: 1, 2, 3, 5, 8 |
| `Sprint` | iteration | 2-week iterations, Sprint 0 → Sprint 5 |

### Board views to create

1. **Kanban (default)** — group by `Status`.
2. **By squad** — group by `Squad`, filter `Sprint = @current`.
3. **My work** — filter `assignee:@me`, group by `Status`.
4. **Blocked & aging** — filter `Status = Blocked` or updated more than 3 days ago.
5. **Cloud platform** — filter `Track = Cloud`.

---

## Definition of Ready

A ticket may only enter **Ready** when it has:

- [ ] A clear title in the form `<verb> <thing>` (e.g. "Add fibre coverage lookup endpoint")
- [ ] A user story or a stated technical outcome
- [ ] Acceptance criteria that can be objectively passed or failed
- [ ] An estimate, a squad label, and a priority
- [ ] No unanswered open question in the comments

## Definition of Done

A ticket may only enter **Done** when:

- [ ] Acceptance criteria all pass
- [ ] Code is reviewed and approved by at least one squad member who did not write it
- [ ] Automated tests cover the new behaviour and CI is green
- [ ] No new high/critical findings from the security scan step
- [ ] Docs updated (README, API spec, or an ADR if a decision was made)
- [ ] Deployed to staging and verified there — not just on a laptop
- [ ] Demoed or screen-recorded, and linked in the ticket

---

## Git workflow

Trunk-ish with a shared integration branch:

```
main        ← protected, production. Only release PRs from develop.
develop     ← protected, staging. All feature PRs land here.
feat/…      ← short-lived branches off develop
```

**Branch naming:** `<type>/<issue-number>-<short-slug>`
Examples: `feat/42-coverage-lookup`, `fix/57-invoice-rounding`, `chore/61-tf-fmt`

**Commit messages:** Conventional Commits.
`feat(connectivity): add fibre coverage lookup endpoint (#42)`

**Pull requests:**
- Keep them under ~400 changed lines. Split anything bigger.
- Link the issue with `Closes #42` so the board moves automatically.
- One approval required; CI must be green; no direct pushes to `main` or `develop`.
- If a PR sits unreviewed for more than 24h, the Quality Owner escalates at stand-up.

---

## Cadence

Sprints are **10 working days**. The full day-by-day shape is in
`docs/SPRINT-RHYTHM.md` — planning on day 1, refinement on days 3 and 8, pairing on
day 6, review clinic on day 7, code freeze at 16:00 on day 8, demo and retro on day 10.

## Escalation

Follow the ladder in `docs/COMPETENCY-FRAMEWORK.md`: 30 minutes alone, then the docs,
then your squad, then another squad, then a facilitator.

Blocked more than **4 working hours** → move the card to `Blocked`, comment with what
you need and who from, and raise it in the shared channel — never a DM. Blocked more
than **1 day** → a facilitator picks it up.

Silent blockage is the failure mode this programme exists to break. Facilitators answer
at most three direct technical questions per squad per day; everything else comes back
as a question. That is intentional.
