# SFIA 9 Mapping — C Connect

**Honest framing first:** this project was designed around three outcomes (independent
problem solving, placement readiness, collaboration), not designed backwards from SFIA.
The alignment below is real but it is *incidental* — so it is strong in places, thin in
others, and has two genuine holes worth closing. Those are named at the end rather than
buried.

SFIA 9 is the current version, published October 2024. SFIA 10 is in consultation, so
if your programme runs past its release you may want to re-check codes before publishing
anything candidate-facing.

**On levels:** SFIA proficiency is attained by practising a skill at that level in a
real-world situation. A simulated programme produces *evidence toward* a level, not a
level itself. Read every "L2" below as "generates defensible evidence at Level 2", and
say it that way to employers too — overclaiming here damages the candidate more than a
modest claim would.

**On licensing:** SFIA is free or low-cost to use but the terms depend on how you use it.
If you intend to put SFIA levels on certificates, marketing or candidate profiles, check
your licence position with the SFIA Foundation before you do.

---

## Software Engineer track — 18 candidates

### Strong evidence

| Skill | Code | Evidenced by | Level evidence supports |
|---|---|---|---|
| Programming/software development | PROG | Every feature ticket; PR review; Conventional Commits | 2, reaching 3 |
| Systems and software lifecycle engineering | SLEN | `D1`–`D6` — the whole DevOps ownership set | 2–3 |
| Functional testing | TEST | Tests required by Definition of Done; `CN-08`, `PY-08` written test-first | 2 |
| Software design | SWDN | Service design, ADRs, `ID-07`, `AI-02` | 2 |
| Requirements definition and management | REQM | Refinement, Definition of Ready, acceptance criteria | 2 |
| Deployment | DEPL | `D3` — squads deploy their own service via Argo CD | 2 |
| Configuration management | CFMG | Git discipline, CODEOWNERS, Helm values owned by squad | 2 |
| Systems integration and build | SINT | `CN-07` event schema, `XX-06` end-to-end integration test | 2 |
| Application support | ASUP | `D6` runbook plus an on-call shift on a service they wrote | 2 |
| Incident management | USUP | `OB-08` game day, with software squads genuinely paged | 2 |
| Quality assurance | QUAS | One-approval merge rule; Quality Owner role rotation | 2 |
| Measurement | MEAS | `D4` dashboards, `D5` SLO and error budget | 2 |
| Knowledge management | KNOW | ADRs, runbooks, `XX-02` contract style guide | 2 |

### Partial evidence

| Skill | Code | Where it shows up | Why only partial |
|---|---|---|---|
| Systems design | DESN | `ID-05` gateway policy, `AI-02` retrieval design | Architecture is largely given to them in the brief |
| Non-functional testing | NFTS | `CO-07` concurrency, `AI-07` guardrails, `PL-05` load test | Ad hoc rather than a discipline they own |
| Data modelling and design | DTAN | `PY-01` money type, `EN-04` aggregation, `CO-01` inventory | No explicit modelling ticket |
| Database design | DBDS | `EN-06` storage spike, PostGIS in `CN-02` | Incidental |
| Accessibility and inclusion | ACIN | `XX-07` WCAG 2.2 AA audit | One ticket, late in the programme |
| Information security | SCTY | `XX-08` threat model, Trivy in CI, `AI-04` tenant isolation | Distributed, never owned by anyone |
| Methods and tools | METL | Board discipline, git flow, tooling choices | Mostly adopted rather than chosen |

### Not covered
`RESD` real-time/embedded · `SFEN`/`SFAS` safety · `PORT` software configuration ·
`PRTS` process testing · `URCH`/`UNAN`/`HCEV`/`USEV` the UX skills · `PROD` product
management · `DLMG`/`DEMG` development and delivery management (deliberate — these are
Level 4+ skills and not appropriate pre-placement).

---

## Cloud / Infrastructure Engineer track — 12 candidates

### Strong evidence

| Skill | Code | Evidenced by | Level evidence supports |
|---|---|---|---|
| Infrastructure operations | ITOP | `LZ-04`, `PL-01` — the whole estate provisioned and operated as code | 2–3 |
| Systems and software lifecycle engineering | SLEN | `CD-01` reusable workflow, `CD-03` GitOps, `CD-08` developer path | 3 |
| Infrastructure design | IFDN | `LZ-01` baseline ADR, `LZ-03` network module | 2 |
| Configuration management | CFMG | OpenTofu modules, `LZ-06` drift detection, state discipline | 2–3 |
| Deployment | DEPL | `CD-03` Argo CD, `CD-07` progressive delivery and rollback | 3 |
| Release management | RELM | `CD-04` promotion with the same signed artefact | 2 |
| Change control | CHMG | Approval gate on promotion, branch protection, PR discipline | 2 |
| Incident management | USUP | `OB-05` on-call simulation, `OB-08` game day | 2–3 |
| Problem management | PBMG | Blameless incident review after the game day | 2 |
| Security operations | SCAD | `LZ-07` OpenBao, `LZ-08` OPA policy, Harbor scanning | 2 |
| Identity and access management | IAMT | `LZ-04` least privilege, `PL-06` workload identity and mTLS | 2 |
| System software administration | SYSP | Kubernetes distribution, node OS, `PL-08` upgrade rehearsal | 2 |
| Service level management | SLMO | `OB-04` SLOs and error budgets agreed with each squad | 2 |
| Availability management | AVMT | `PL-05` autoscaling and PDBs, SLO burn tracking | 2 |
| Cost management | COMG | `OB-06` OpenCost, `OB-07` budget alerts and idle shutdown | 2 |
| Measurement | MEAS | `OB-02` metrics, `OB-03` tracing | 2 |

### Partial evidence

| Skill | Code | Where it shows up | Why only partial |
|---|---|---|---|
| Network design | NTDS | `LZ-03` network module, `PL-03` Cilium policies | No routing, segmentation or WAN design work |
| Systems installation and removal | HSIN | `LZ-04` provisioning, `PL-08` upgrades | Nothing is ever decommissioned |
| Storage management | STMG | MinIO in `LZ-05` | Provisioned once, never operated under pressure |
| Database administration | DBAD | `LZ-05` modules, `CD-06` migrations, `LZ-09`/`LZ-10` backup and restore | No performance tuning |
| Capacity management | CPMG | `PL-05` load test, quotas in `PL-03` | Reactive, no forecasting |
| Vulnerability assessment | VUAS | Trivy in `CD-01`, `XX-08` threat model | Tool output, not analysis |
| Sustainability | SUST | `OB-07` idle shutdown saves energy and cost | Framed as cost, never as sustainability |

### Not covered
`ASMG` asset management ·
`NTAS` network support · `DCMA` facilities · `PENT` penetration testing ·
`ITMG` technology service management.

---

## The two holes — now closed

Both were things a placement employer will assume a junior can do. Six tickets have been
added to the backlog to cover them; they are listed below and are already in
`backlog/backlog.psv`.

### 1. Continuity management (COPL) and backup/restore (DBAD)

There was no backup, restore or disaster-recovery ticket anywhere in the original backlog.
A candidate who has never restored a database has not been prepared for their first
on-call rotation. This was the single biggest gap.

Added:

| Ref | Squad | Sprint | Title |
|---|---|---|---|
| `LZ-09` | CL1 Infrastructure | 3 | Automated backups for PostgreSQL and MinIO, with retention and encryption |
| `LZ-10` | CL1 Infrastructure | 4 | Prove it: restore the staging database from backup and time the recovery |
| `PL-09` | CL2 Platform | 4 | Cluster disaster recovery — rebuild staging from code and backups, document RTO and RPO |
| `OB-09` | CL4 SRE | 4 | Add a data-loss scenario to the game day |

`LZ-10` is the one that matters. A backup nobody has restored is not a backup.

### 2. Service acceptance and decommissioning (SEAC, HSIN, ASMG)

Nothing was ever formally accepted into service, or torn down. Both are routine in a
real placement.

Added:

| Ref | Squad | Sprint | Title |
|---|---|---|---|
| `XX-11` | Cross-cutting | 4 | Service acceptance checklist — a service is not "live" until it passes it |
| `XX-12` | Cross-cutting | 5 | Decommission the preview and dev environments, and evidence that nothing was orphaned |

### Smaller gaps, take or leave

- **User experience (URCH, UNAN, HCEV, USEV).** Only accessibility is covered. If any
  of your 18 are heading for front-end placements, one user-research and one usability-test
  ticket per squad would fix it cheaply.
- **Non-functional testing (NFTS) as a discipline.** It is scattered across five tickets
  owned by nobody. Consider making it one squad's `D7`.
- **Sustainability (SUST).** `OB-07` already does the work; it just needs reframing so
  candidates can name the skill in an interview.

---

## Using this for assessment

Map the SFIA codes onto the six-dimension rubric in `docs/COMPETENCY-FRAMEWORK.md`
rather than running two parallel systems:

| Rubric dimension | SFIA skills it evidences |
|---|---|
| Independence | PROG, ITOP, SLEN — depth in their own track |
| Code quality | PROG, TEST, SWDN, QUAS |
| DevOps ownership | SLEN, DEPL, CFMG, ASUP, MEAS |
| Review | QUAS, KNOW |
| Communication | KNOW, REQM, CNSL (lightly) |
| Ownership | USUP, PBMG, SLMO, AVMT, COPL, SEAC |

Facilitators doing this assessment are exercising **LEDA — competency assessment**.
If you have an accredited SFIA assessor on staff, their sign-off makes the evidence
considerably more portable for candidates at placement.
