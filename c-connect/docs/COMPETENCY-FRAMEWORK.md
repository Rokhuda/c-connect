# What This Programme Is Actually For

The product is the pretext. Three outcomes matter, and every mechanism in this repo
exists to serve one of them.

| Outcome | What it looks like on the last day |
|---|---|
| **Solve problems independently** | Given an unfamiliar failure, the candidate forms a hypothesis, tests it, reads the source, and reaches an answer without being handed one. |
| **Ready for placement** | Can explain their own architecture to a stranger, read someone else's code, take feedback, and evidence their work. |
| **Work in a collaborative team** | Reviews well, asks for help early and in public, hands work over cleanly, and does not need to be the one who wrote it to fix it. |

---

## 1. Independence

### The escalation ladder

Print this. Put it on the wall. Ticket `XX-04` makes the cohort agree to it on day one.

```
 1.  30 minutes on your own          — read the error, read the logs, form a hypothesis
 2.  Read the actual documentation   — the real docs or the source, not a search summary
 3.  Ask your squad                  — out loud, in the room
 4.  Ask another squad               — in the shared channel, never a DM
 5.  Ask a facilitator               — and only after you can say what you already tried
```

Step 5 requires three sentences: what you expected, what happened, what you have ruled
out. A question without those goes back one rung.

### The facilitator answer budget

**Each facilitator answers at most three direct technical questions per squad per day.**
Everything else is met with a question: *What have you tried? What does the log say?
Where would you look first?*

This will feel unkind in week one. It is the single highest-leverage thing in the
programme. The candidates who go to placement having always been rescued are the ones
who stall in month two.

### Deliberate difficulty

Some tickets are written to be under-specified on purpose — `LZ-01`, `EN-06`, `PL-07`,
`AI-02`, `CO-08`. They ask a question rather than describe a solution. The output is an
ADR. Resist the urge to answer these. The discomfort is the exercise.

### Signals to watch

| Green | Amber | Red |
|---|---|---|
| Arrives with a hypothesis | Arrives with an error message | Arrives with "it doesn't work" |
| Reads a stack trace before asking | Asks in the channel straight away | Waits silently for two days |
| Says "I was wrong about X" | Defends the first idea | Blames the tooling |

---

## 2. Placement readiness

### Artefacts every candidate leaves with

- A public or shareable repo with their commits and PRs in it
- **At least two ADRs** they wrote, showing a decision and its trade-offs
- A **service runbook** someone else successfully followed (ticket `D6`)
- A **Grafana dashboard and SLO** they defined for their own service (`D4`, `D5`)
- A recorded demo of them presenting their work
- **Three STAR stories** written up from their own tickets (`XX-10`)

That last one matters more than it looks. Most junior candidates fail interviews not
for lack of experience but because they cannot narrate the experience they have. The
tickets are the raw material; `XX-10` turns them into answers.

### Placement rehearsal, Sprint 5

- **Mock technical interview**, 45 min each, run by a facilitator they have not worked
  with. Two questions on their own code, one on something they have never seen.
- **Whiteboard your architecture**, 15 min, no notes.
- **Debug an unfamiliar service**: swap squads and fix a seeded bug in someone else's
  code within 90 minutes. This is the closest simulation of week one at a placement.

### Employability, day one

Candidates should update their CV and profile in Sprint 1, not Sprint 5, and revise it
each sprint while the detail is fresh. Set the expectation early.

---

## 3. Collaboration

### Mechanisms already built into the repo

| Mechanism | Where | What it teaches |
|---|---|---|
| Role rotation each sprint | `docs/TEAM-STRUCTURE.md` | Nobody becomes the permanent lead or the permanent spectator |
| One approval required to merge | branch protection | Reviewing is real work, not a formality |
| CODEOWNERS per service | `.github/CODEOWNERS` | Ownership is explicit and visible |
| Buddy squad pairing, day 6 | `docs/SPRINT-RHYTHM.md` | Reading unfamiliar code |
| Review clinic, day 7 | `docs/SPRINT-RHYTHM.md` | Explaining reasoning out loud |
| Platform office hours | cloud squads | Being a customer, and having customers |
| Cross-squad tickets | `XX-06`, `XX-08` | Coordination cost is real and must be planned for |
| Shared on-call on game day | `D6`, `OB-08` | You are responsible for what you shipped |

### The rule that does the most work

**Ask in public, never in a DM.** A question in the shared channel teaches four people.
The same question in a DM teaches one and hides the fact that the docs were unclear.

---

## Assessment rubric

Score 1–4 at the end of each sprint. All evidence already exists in GitHub — do not
invent a separate process that needs new paperwork.

| Dimension | 1 | 2 | 3 | 4 |
|---|---|---|---|---|
| **Independence** | Needs step-by-step direction | Solves familiar problems alone | Solves unfamiliar problems with a nudge | Unblocks others |
| **Code quality** | Works, barely | Tested and readable | Considers failure modes | Others copy their patterns |
| **DevOps ownership** | Someone else deploys it | Deploys with help | Owns build, deploy and dashboard | Improves the platform for everyone |
| **Review** | Approves without reading | Catches obvious issues | Catches design issues, explains why | Teaches through review |
| **Communication** | Silent when stuck | Asks late | Asks early with context | Explains clearly to non-experts |
| **Ownership** | Waits for assignment | Finishes what is assigned | Raises problems they find | Fixes things nobody asked them to |

Sprint 1 scores are a baseline, not a judgement. What you are assessing at the end is
the **slope**, not the height.

Pull the raw evidence with:

```bash
gh issue list --repo "$GH_ORG/$GH_REPO" --state all --limit 800 \
  --json number,title,assignees,labels,milestone,closedAt > assessment-issues.json
gh pr list --repo "$GH_ORG/$GH_REPO" --state all --limit 800 \
  --json number,author,additions,deletions,reviews,mergedAt > assessment-prs.json
```
