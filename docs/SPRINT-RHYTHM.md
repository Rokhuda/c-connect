# Sprint Rhythm — 10 working days

Every sprint is **10 working days**, Monday to Friday over two weeks. The shape is the
same every time. Repetition is deliberate: by Sprint 3 nobody should need to ask what
happens on a Thursday.

| Day | | What happens | Who |
|---|---|---|---|
| **1** | Mon | **Sprint planning** (60 min per squad). Pull from Ready, commit to a sprint goal in one sentence. Rotate roles: lead, quality owner, scribe. | Squad |
| **2** | Tue | Build. Stand-up 09:15. First PRs open by end of day — if nothing is in review after two days, the tickets were too big. | Squad |
| **3** | Wed | Build. **Refinement** (45 min): groom the next sprint's tickets to Definition of Ready. **Cost report** published. | Squad + facilitator |
| **4** | Thu | Build. **Platform office hours** — each cloud squad runs a 45-min clinic; software squads bring deployment problems. | Cross-squad |
| **5** | Fri | Build. **Mid-sprint check** (20 min): is the sprint goal still reachable? If not, cut scope now rather than on day 10. | Squad |
| **6** | Mon | Build. **Cross-squad pairing** (90 min): swap one person with your buddy squad for the session. | Pairs |
| **7** | Tue | Build. **Code review clinic** (45 min): a squad reads someone else's PR aloud and reviews it together. | Cohort |
| **8** | Wed | Build. **Refinement**. **Code freeze for the demo at 16:00** — anything not merged is next sprint's problem. | Squad |
| **9** | Thu | Stabilise, verify on staging, write the demo script. No new tickets started. Tidy the board. | Squad |
| **10** | Fri | **Demo day** (90 min, all 30 + guests), then **retrospective** (45 min per squad), then **role rotation** for the next sprint. | Cohort |

## Fixed daily rhythm

| Time | | |
|---|---|---|
| 09:15 | Stand-up, 15 min, standing at the board | Per squad |
| 09:30 | **Review first.** Clear the In Review column before opening your own editor. | Everyone |
| 15:00 | **Help hour.** Anyone stuck raises it here, publicly, if it has not been solved already. | Cohort |
| 16:30 | Update your tickets. A board that is wrong at 17:00 makes tomorrow's stand-up useless. | Everyone |

## Why day 8 has a code freeze

Two full days between freeze and demo feels generous. It is not. The gap is where
candidates learn that "it works on my machine" and "it works on staging in front of
guests" are different claims — and that closing the gap takes real time. Do not
compress it, however loudly they ask.

## Why day 6 and 7 exist

Pairing and the review clinic are not filler. Placement interviews and the first
months of a real job test whether someone can read unfamiliar code and explain their
thinking out loud. Those two sessions are the only structured practice for it.

## Capacity

Assume **6 productive days out of 10** per person. The rest goes to ceremonies,
reviewing, being blocked, and learning the tooling. A squad of three planning more
than about 12 points into a sprint is planning to fail, and will discover it on day 9.
