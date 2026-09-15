# Getting C Connect onto GitHub

Three ways, from least effort to most control. Pick one.

---

## Option A — Let GitHub set itself up (recommended, no software to install)

Everything runs inside GitHub Actions. You never open a terminal.

1. **Create an empty repo** on GitHub named `c-connect`, inside your organisation.
   Tick *Add a README* so the repo is not empty.
2. **Upload this folder.** On the repo page: *Add file → Upload files*, drag in
   everything from the unzipped folder, commit to `main`.
   (Upload the *contents*, not the folder itself. Note that GitHub's uploader skips
   dot-folders — if `.github/` does not appear, see the note at the bottom.)
3. **Create a token.** GitHub → *Settings → Developer settings → Personal access tokens
   → Tokens (classic) → Generate new token*, with scopes:
   `repo`, `project`, `read:org`, `admin:org`, `workflow`.
   Copy it.
4. **Add it as a secret.** Repo → *Settings → Secrets and variables → Actions →
   New repository secret*. Name it exactly `BOOTSTRAP_TOKEN`, paste the token.
5. **Run it.** Repo → *Actions* tab → **Bootstrap C Connect** → *Run workflow*.

Two to three minutes later you have the board, 31 labels, 6 milestones, 12 squad
teams, branch protection and all 132 tickets. The run summary links straight to the board.

Then: fill in `backlog/candidates.csv`, commit it, and the **Onboard Candidates**
workflow runs by itself — inviting all 30 people and assigning their first tickets.

---

## Option B — GitHub Codespaces (browser terminal, nothing installed locally)

1. Do steps 1–2 above.
2. Repo page → *Code → Codespaces → Create codespace on main*.
3. In the terminal that opens:

   ```bash
   gh auth login --scopes "repo,project,read:org,admin:org,workflow"
   export GH_ORG="your-org-name"
   ./setup.sh
   ```

`gh`, `git` and `jq` are already installed by `.devcontainer/devcontainer.json`.

---

## Option C — Your own machine

Needs `gh`, `git` and `jq`.

```bash
gh auth login --scopes "repo,project,read:org,admin:org,workflow"
export GH_ORG="your-org-name"
./setup.sh
```

`setup.sh` creates the repo for you, so you do not need to make one first.

---

## What still needs a human

Three things the GitHub API cannot do. All in the board UI, about five minutes total:

1. **WIP limits** per column — the `In Progress` limit of 2 per person is the one
   that matters. Column `⋯` menu → *Set limit*.
2. **Saved views** — Kanban, By squad, My work, Blocked & aging, Cloud platform.
   Listed in `docs/WAYS-OF-WORKING.md`.
3. **Built-in workflows** — Project → *Settings → Workflows*, turn on:
   *Item added to project* → Status **Backlog**;
   *Pull request merged* → Status **Testing**;
   *Item closed* → Status **Done**.

Also unavoidable: **candidates must accept their own org invite** from their email,
and **you must create the token yourself** — nobody else can authenticate as you.

---

## Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| `.github/` folder missing after upload | GitHub's drag-and-drop uploader ignores dot-folders | Use Codespaces (Option B), or `git push` from your machine, or create the files via *Add file → Create new file* and type the path `.github/workflows/bootstrap.yml` |
| Workflow fails on branch protection | Private repo on the Free plan | Make the repo public, or upgrade to GitHub Team. The rest still succeeds |
| `could not add <handle>` during onboarding | Wrong username, or token lacks `admin:org` | Check the handle; regenerate the token with `admin:org` |
| Board created but fields are empty | Token missing the `project` scope | Regenerate with `project` and re-run |
| Status column names did not change | Older GraphQL schema | Set the seven columns by hand once, in the board's Status field settings |
