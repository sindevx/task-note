# Roadmap: phases, steps, developer log, KPI

Roadmap is opt-in: a project has phases only after `project roadmap`. No rule asks for one by task count.

Goal: a manager opens a project and sees the work in the order real development follows, from reading the documents to go-live, with progress per phase that can be measured for KPI. A developer records work as it happens with one short command.
Core rules: core.md. Fields: tpl-task.md. Base views: tpl-project.md. Numbers: config.md.

## Standard phases (fixed order)
Every project uses these 11 slots. Rename a phase to fit the project (keep the number). Leave out a phase the project does not need, never reorder.

| # | Phase | A developer does | Exit check |
|---|---|---|---|
| 1 | Analyse requirements | read every document and version, list rules, document mistakes, open questions with owner | every question answered or owned with a date |
| 2 | Design | layers, data model, flow, each decision with its reason, build plan, diagrams | a new developer can continue from the design alone |
| 3 | Set up project | repository, config, logging, Docker, Makefile, CI | `make run` (or equal) starts on a clean machine |
| 4 | Database | connection, tables, migrations, views, retention, DBA handoff | migrations run on the real database; DBA ran them |
| 5 | Sign-in and security | login integration, roles, token, limits, secrets | real account signs in, wrong one refused |
| 6 | Core features | domain rules, one step per feature or form (for example "6.3 Define form F1") | every feature has tests and matches the source document |
| 7 | Own API | endpoints, validation, error format, API docs | every endpoint tested; contract matches code |
| 8 | External integrations | one step per outside system call (login to the partner, send, receive, error codes), then UAT per feature or form | every feature or form passes partner UAT; failure cases tested |
| 9 | Hardening and documents | safe logs, runbook, handover guide, refactor for readability | reviewer finds no secret in logs; docs match code |
| 10 | End-to-end and user test | test with the frontend or partner team, load test, business acceptance | business owner signs; go or no-go recorded |
| 11 | Go live and operate | cutover, first real run, operations tasks | first real run confirmed |

Phase keyword map (used by `dev log` and `task add` when no phase is given). First match wins:
analyse, spec, document, question, requirement -> 1 · design, diagram, decision, plan -> 2 · setup, init, docker, config, makefile, CI -> 3 · db, database, table, migration, view, oracle, schema -> 4 · login, sign-in, auth, token, role, security -> 5 · form, F1..F22, rule, feature, module, calculate -> 6 · endpoint, API, controller, request, response -> 7 · partner, third-party, websocket, UAT, integrate -> 8 · log, runbook, handover, refactor, docs -> 9 · e2e, frontend, portal, load test, acceptance, joint test -> 10 · deploy, go-live, cutover, production, maintain -> 11.
A project may override words in its project file under `## Phase words` (one line per phase: `8: partner, websocket`).

## How phases are stored
- A phase is a task titled `Phase N: <name>` with tag `phase`, fields `phase: N` and `step: 0`. Its status is computed from its steps (status-rules.md).
- A step is a sub task of the phase. Title starts with `N.M ` (for example `8.12 Send all 15 forms to Partner UAT`). Fields `phase: N`, `step: M`.
- Task ids are history and never show order. Order comes from `phase` and `step`. A task created before the roadmap keeps its id: it gets `parent`, `phase`, `step` and a title prefix, with one Progress log line `reparent: moved under [[T-id]] as step N.M; title was '<old>'`.
- A step that has its own sub tasks (depth limit, E-DEPTH) becomes the phase itself, or its sub tasks stay and are listed as one group step `N.M` in the roadmap page.
- New step number = highest `step` in that phase + 1. Never renumber done steps.
- **One step per form or feature, never one step for "all of them".** When the project has repeated units (forms, reports, endpoints, partner APIs), phase 8 gets one step per unit, titled `8.M Integrate <unit> <name> with <partner> UAT`, in the partner's order. Each has the same Done-when chain: field check done (link the phase 6 check), sample data prepared and approved by the data owner, uploaded through our API, stored data visible, sent to the partner, first reply success, final result accepted (or error fixed and resent), tracker row filled. Phase 6 gets one check step per unit, phase 10 lists every unit in its Done-when. Reason: a manager tracks each unit until it is accepted.
- Write steps as a development team would: verb + object + system (`Integrate form F1 Balance with Partner UAT`). Leave out machine-speed details such as time of day or line counts of generated files; dates and commit hashes stay.

## Commands
| Command | Effect |
|---|---|
| `project roadmap <slug> [--from-git]` | Build the roadmap: create the phase tasks, map every existing task of the project to a phase (show the table, ask once), reparent them, and with `--from-git` backfill done steps from the repository history. Then write the roadmap page `wiki/<slug>-roadmap.md`, link it from the project page and hub, rebuild BOARD and Summary. Re-run is safe: existing phases and steps are kept, only missing ones are added. |
| `task add <title> --phase N` | Create step `N.M` under phase N with intake.md. Without `--phase`, use the keyword map, show the chosen phase. |
| `dev log [T-id] <text>` | Record work as it happens. See below. |
| `report kpi [--project] [--since 30d]` | KPI report, read only. See below. |

Natural phrases: "log งาน", "วันนี้ทำ ...", "ทำเสร็จ ...", "เริ่มทำ ...", "integrate form F1 ...", "db design ...", "developer log ..." -> `dev log`. "roadmap", "phase", "ลำดับงาน" -> `project roadmap`. "KPI", "ผลงาน", "progress ต่อ phase" -> `report kpi`.

## `dev log`: developer log -> task -> note in one step
1. Resolve the project (core.md). Resolve the step: the given id; else match the text against open step titles of the project (same nouns: form name, table, endpoint, system); else the keyword map gives the phase. Exactly one match: use it. Several: show up to 3 and ask. None: propose a new step `N.M` under the phase from the keyword map (intake.md) and create it after one yes.
2. Status: a `todo` step moves to `doing` (sets `started_at`). Words "done", "เสร็จ", "finished" propose `task done` with the outcome taken from the text; ask once if the text has no proof.
3. Evidence: in the project repository run `git log --since=<last Progress log time of the step> --format='%h %ad %s' --date=short`. Add new hashes to `ref` (`commit#hash`). Never invent a hash or a test result.
4. Write the Progress log line `log: <text in writing.md style> (commits: ...)`.
5. Text longer than 5 lines, or a decision, design or finding: also write or append the step's wiki page (dev note, decision or issue by capture.md) and put it in the step `notes`.
6. Missing `estimate` on a step that just moved to doing: ask once for it (KPI needs it). Missing `due` on a high-priority step: ask once.
7. Mutation procedure (core.md): rebuild BOARD, Summary, roadmap page counts, log.md, one commit.

## Backfill from git (`--from-git`)
- Group commits into steps by path or by commit scope (`feat(fdi)` -> feature fdi), one step per feature or module, never one per commit.
- Dates: `started_at` = first commit of the group, `done_at` = last commit. Say in Context: `Backfill from git; dates are commit dates; tests not seen in this session`.
- Outcome: what the commits delivered and `N commits, first <date>, last <date>`. Ref: the first and last hash.
- Built code is not verified code. A module that exists gets a done "build" step. Testing it in UAT or with users is a separate open step in phase 8 or 10 unless a test record exists.
- No estimate is written for backfilled steps. They do not count in on-time or estimate KPIs.
- Every backfilled task gets tag `backfill`, so a view shows at once that it was recorded after the work.

## KPI (what `report kpi` shows)
| KPI | Formula | Valid only when |
|---|---|---|
| Progress per phase | done steps / (all steps - cancelled) | always |
| Overall progress | done / (open + done) | always |
| Throughput | steps done per ISO week | `done_at` set |
| On-time rate | steps with `done_at <= due` / steps with `due` | step has `due` |
| Estimate accuracy | working days `started_at`..`done_at` / estimate days | step has `estimate`, not backfilled |
| Blocked time | days in blocked, from Progress log lines | always |
| Stale steps | doing with no Progress log line for STALE_DAYS | always |
| Defects found late | `bug` steps created in phase 8, 10 or 11 | always |
| Open effort | sum of `estimate` of open steps (`h` / 7.5) | say how many open steps have no estimate |
Never show a KPI from data that is not valid for it; print `not measurable: <reason>` instead.

## Roadmap page `wiki/<slug>-roadmap.md`
Front matter `type: note`, tags `[roadmap, kpi]`. Sections in order: How to read (phase order, ids are history, how to pick the Roadmap view), KPI snapshot (include units accepted, units checked, units tested with users), Unit tracker when the project has repeated units (Unit | Check | Integration step | Chain done | User test), Phases table (Phase | Name | Steps done | State | Started), one section per phase (developer work, output, exit check, step table: Step | Task | State | Date | Evidence), Waiting on others, Risks and not verified, Source. Generated parts (KPI snapshot, unit tracker, phases table, phase sections) sit between `<!-- tn:roadmap:start -->` and `<!-- tn:roadmap:end -->`. Every write to the project and `board rebuild` rebuild only that block from the task files; text outside the markers is written by people and never touched. Reason: counts drifted when they were written once.
First lines of How to read: Roadmap view in Obsidian, ids are history, `backfill` tag meaning, numbers between markers are rebuilt.
