# Team Structure — 30 candidates

18 software engineers + 12 cloud engineers = **10 squads of 3**.

Three people is deliberate: big enough for real code review and pairing, small enough
that nobody can hide. Every squad owns a vertical slice end-to-end.

---

## Software squads (18 seats)

| Squad | Name | Label | Seats | Owns |
|---|---|---|---|---|
| SQ1 | Identity & Access | `squad:identity` | 3 | Sign-up, login, MFA, org/roles/permissions, session management |
| SQ2 | Connectivity | `squad:connectivity` | 3 | Coverage lookup, service catalogue, order + install tracking |
| SQ3 | Colocation | `squad:colocation` | 3 | Rack inventory, power/space capacity, remote-hands tickets |
| SQ4 | Payments & Billing | `squad:payments` | 3 | Invoices, wallet, top-ups, payment webhooks, statements |
| SQ5 | Energy Telemetry | `squad:energy` | 3 | Site metering ingest, solar/battery dashboards, alerting |
| SQ6 | AI Assistant | `squad:ai` | 3 | Retrieval over account data, support copilot, guardrails |

## Cloud squads (12 seats)

| Squad | Name | Label | Seats | Owns |
|---|---|---|---|---|
| CL1 | Infrastructure & IaC | `squad:infra` | 3 | OpenTofu, compute, private networking, WireGuard, OpenBao secrets, OPA policy |
| CL2 | Container Platform | `squad:platform` | 3 | Kubernetes, Traefik, cert-manager, Cilium policies, Helm chart library, autoscaling |
| CL3 | CI/CD & Developer Experience | `squad:cicd` | 3 | Reusable Actions workflow, Harbor, Argo CD GitOps, preview environments, rollbacks |
| CL4 | Observability, SRE & Cost | `squad:sre` | 3 | Prometheus, Grafana, Loki, Tempo, Alertmanager, SLO tooling, OpenCost, game days |

---

## Roles inside each squad

Rotate these **every sprint** so all 30 candidates practise each one.

| Role | Responsibility |
|---|---|
| **Squad Lead** | Runs stand-up, keeps the board honest, unblocks, reports at demo |
| **Quality Owner** | Reviews every PR before merge, guards the Definition of Done, writes tests |
| **Scribe / Demo Owner** | Keeps the squad's docs + ADRs current, presents at sprint demo |

Nobody is a permanent lead. Rotation is the point — the programme is about work readiness,
not about producing one hero and two spectators.

---

## Software squads do DevOps

Each software squad also ships six `devops`-labelled tickets (`D1`–`D6`) for its own
service: containerise it, own its CI pipeline, own its Helm chart and deploy it, add
metrics/logs/traces and a dashboard, define an SLO, write a runbook and take an on-call
shift. Cloud squads build golden paths and run office hours. **They do not operate
other squads' services.**

If a software squad has never watched its own deployment fail, the platform squads have
been too helpful.

## Cross-squad structure

- **Guilds** (30 min, weekly, optional): Frontend, Backend, Security, Cloud.
- **Platform office hours**: each cloud squad runs a 45-min slot per week where product
  squads bring deployment problems. Teaches both sides how a real platform team works.
- **Pairing across the split**: each software squad is buddied with a cloud squad —
  SQ1↔CL1, SQ2↔CL2, SQ3↔CL3, SQ4↔CL4, SQ5↔CL1, SQ6↔CL2. On **day 6 of every sprint**
  the buddies swap one person for a 90-minute pairing session.

---

## Roster template

Fill in `backlog/candidates.example.csv`, save it as `candidates.csv`, then run
`./scripts/03-assign-squads.sh`. Columns:

```
github_handle,full_name,track,squad_label,role_sprint1
```

- `track` — `software` or `cloud`
- `squad_label` — one of the labels above
- `role_sprint1` — `lead`, `quality`, or `scribe`

## GitHub org teams

`00-bootstrap-repo.sh` creates a GitHub team per squad plus two parent teams
(`software-track`, `cloud-track`). Teams get **write** access to the repo; only
facilitators get **admin**. Branch protection means nobody can push to `main` directly.
