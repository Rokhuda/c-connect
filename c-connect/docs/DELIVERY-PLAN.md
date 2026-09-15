# Delivery Plan — six sprints of 10 working days

12 working weeks. Sprint shape is in `docs/SPRINT-RHYTHM.md`.

| Sprint | Theme | Must be true at demo day |
|---|---|---|
| **0** | Foundations | Cluster exists as code. CI runs. Every candidate has merged one PR. Every software squad's service is containerised and running in dev. |
| **1** | Walking skeleton | One thin slice works in staging: log in via Keycloak, look up coverage, see it on a page. Argo CD syncs everything. A trace follows the request across services. Each squad owns its own pipeline and chart. |
| **2** | Core journeys | Order connectivity, reserve a rack, pay an invoice, view a site dashboard. Preview environments per PR. Every service has its own Grafana dashboard, built by the squad that wrote it. |
| **3** | Integration | Services talk over NATS. Order to invoice to payment works end to end. The assistant answers grounded questions. Every squad has published an SLO. Cost dashboard live. |
| **4** | Hardening | Threat model actioned, accessibility audit passed, game day run with software squads on call, concurrency and rounding bugs closed. |
| **5** | Showcase | Polish, runbooks, placement portfolios, mock interviews, and a demo to invited guests. |

## Ticket distribution

**132 tickets.** 48 software feature tickets, 36 DevOps tickets (six per software
squad), 36 cloud platform tickets, 12 cross-cutting.

| Sprint | Tickets | Points |
|---|---|---|
| Sprint 0 | 22 | 71 |
| Sprint 1 | 28 | 113 |
| Sprint 2 | 26 | 122 |
| Sprint 3 | 27 | 110 |
| Sprint 4 | 26 | 92 |
| Sprint 5 | 3 | 9 |

That works out at roughly **8 to 12 points per squad per sprint** — about right for
three people who are also learning the tooling. Expect squads to add 30–50% more
tickets as they refine. That is healthy. A sprint where nothing new was raised usually
means nobody looked closely enough.

## Sequencing constraints

- Cloud squads run one sprint ahead on infrastructure. CL3's reusable workflow (`CD-01`)
  and CL2's chart library (`PL-04`) must exist before software squads can do `D2` and `D3`.
- `XX-02` (API contract style guide) must land in Sprint 0, or six services diverge and
  Sprint 3 integration costs twice as much.
- `OB-03` (tracing) belongs in Sprint 1 while there are two or three services.
  Retrofitting it across six is a different, much worse job.
- `AI-04` (tenant isolation) blocks any public demo of the assistant. Non-negotiable.
- `LZ-10` (restore) must land before `OB-09` (data-loss game day), or the game day
  becomes a demonstration that nobody can recover anything.
- `D6` and `OB-08` are the same event. The game day only works if software squads are
  genuinely on call for services they wrote.

## Demo day, day 10

90 minutes, all 30 candidates, guests invited.

- Six minutes per squad: what we committed to, what we shipped, what broke, what we learned
- Live demo, not slides. A recorded fallback is allowed but must be declared as one.
- Every candidate presents at least twice across the programme.
- Guests ask questions directly. Candidates answer — facilitators stay quiet.
