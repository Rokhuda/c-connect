# Contributing

Read `docs/WAYS-OF-WORKING.md` first. This is the short version you keep open in a tab.

## The loop

1. Open the **C Connect Delivery** board, filter to your squad.
2. Take the top ticket from **Ready**. Assign yourself. Move it to **In Progress**.
   You may have at most **two** tickets in progress.
3. Branch off `develop`:
   ```bash
   git switch develop && git pull
   git switch -c feat/42-coverage-lookup
   ```
4. Commit in small steps, Conventional Commits style:
   ```
   feat(connectivity): add fibre coverage lookup endpoint (#42)
   fix(payments): correct rounding on mixed-currency totals (#57)
   docs(adr): record decision to use a hosted identity provider (#31)
   ```
5. Open a PR into `develop`. Write `Closes #42` in the description.
   Move the ticket to **In Review**.
6. Get one approval and a green CI run. Merge. The ticket moves to **Testing**.
7. Verify it on staging, tick the acceptance criteria, move it to **Done**.

## Reviewing someone else's pull request

You will review more code than you write, and that is the point.

- Aim to give a first response within **4 working hours**.
- Comment on what you do not understand, not only on what is wrong.
- Distinguish **blocking** ("this leaks another tenant's data") from **non-blocking**
  ("I'd name this differently"). Prefix the latter with `nit:`.
- Approve when it is good enough to ship, not when it is what you would have written.

## Architecture Decision Records

Any decision that would be expensive to reverse gets an ADR in `docs/adr/`,
numbered `0001-short-title.md`:

```markdown
# 0001 Use a hosted identity provider

## Status
Accepted — 2026-09-18

## Context
What was true when we decided. Constraints, deadlines, skills, budget.

## Decision
What we chose.

## Consequences
What gets easier. What gets harder. What we will have to revisit.

## Alternatives considered
What we rejected and why.
```

## Things that will get a PR rejected

- Secrets, credentials, `.env` files, real personal data, or real Cassava assets
- Infrastructure created by clicking in a cloud console instead of in Terraform
- A change with no test and no explanation of why a test was not possible
- A 2,000-line pull request
- Anything merged straight to `main`
