# Evals: regression cases for the skill

Run by hand after any change to a reference file. Feed the input, compare with Expected. A failed case means the change broke a rule: fix the change, not the case.
The feedback loop (feedback.md) adds one case here for every lesson that is not a Preference.

`*` = inferred value, marked in Context and in the reply.

| # | Input | Expected |
|---|---|---|
| 1 | `fix customer-info missing savings account urgent by friday` | task: type bug, priority high*, due resolved to a date, estimate*, 2 to 5 Done-when checks. High priority: table shown for one confirmation before create. |
| 2 | Pasted JSON containing `"password": "abc"` | Raw stored with `[REDACTED:password]`, reply gives type and count only, value never printed (E-SECRET), rotate warning. |
| 3 | Same text noted twice | Second run returns the first R-id, writes nothing (formats.md, same hash). |
| 4 | `decision: use Redis dedup window 60s because duplicate payments` | One `type: decision` page, listed once in the hub, no task unless a follow-up is stated. |
| 5 | Meeting text with 2 action items and 1 bug | Pages: meeting plus issue. 2 action tasks and 1 fix task, tag inbox until confirmed, each task has `notes` link. |
| 6 | `note` text with no project and cwd not a project | Raw stored, project `unassigned`, no page, one question: which project. |
| 7 | Topic that already has a wiki page | Dated `## Update` section appended, `updated:` changed, no near duplicate page. |
| 8 | `task done T-0042` with an unticked Done-when item | Refused: E-CONFIRM-REQUIRED or split into a verification task. No file written. |
| 9 | `task done T-0042` with no outcome | E-OUTCOME-REQUIRED. No file written. |
| 10 | 5 tasks would be created from one note | Proposal shown first (above CONFIRM_TASK_THRESHOLD), created only after one answer. |
| 11 | `howto: restart wallet service` with 3 steps | `type: howto` page, steps copied exactly, a missing step is `(unknown)`. |
| 12 | Reply after any write | Compact table of final values, ids, op id, `Quality: N/10`. No raw content. |
| 13 | Open `todo/project-tasks.base` directly in Obsidian | Rows of every project are shown (filter `or this.file.ext == "base"`); embedded in a project page only that project's tasks show. |
| 14 | `dev log integrated form F1 with Partner UAT, got success` in ~/Project/acme-portal | Step 8.11 (or the F1 step) found, todo -> doing, new commit hashes added to `ref`, one log line; no new task unless no step matches. |
| 15 | `task add design the reconciliation table` with no phase | Phase 4 chosen by the keyword map (table), shown in the reply, title `4.M ...`, `phase: 4`, `step: M`. |
| 16 | `report kpi --project acme-portal` | Progress per phase printed; on-time rate and estimate accuracy say `not measurable` for backfilled steps without due or estimate. |
| 17 | `project roadmap acme-portal` on a project with 15 forms | Phase 6 has 15 check steps, phase 8 has 15 steps `Integrate form Fn ... with Partner UAT` with the same 7-item chain, phase 10 lists 15 forms; roadmap page has a form tracker. No single 'all forms' step. |
| 18 | New page says Partner refuses duplicates (code 00003) while an older page says Partner has no dedup | Older page gets a `Superseded` callout under its first line in the same write; old text kept. |
| 19 | `project roadmap --from-git` backfills 20 steps | Every backfilled step has tag `backfill`; roadmap page numbers sit inside `tn:roadmap` markers; BOARD section in phase/step order. |
| 20 | `note` for a commit: dev note and task for work in git | Every class, method, table and system named in the task and the note appears in `git show <hash>`; no vendor or product name that the commit lacks; unverified Done-when items become a verification task; raw evidence file, hub row, BOARD, Summary, log.md and one `tn:` commit exist. |
| 21 | Open `project-tasks.base` embedded in a project without phases | First view is Open (rows visible); view Needs planning lists open tasks with no `due`, `estimate` or `next_action`. |
| 22 | `tn doctor` on a store where a project has 12 tasks and no roadmap | Reports the project and proposes `project roadmap`; reports the count of open tasks with no `due` or `estimate`. |
| 23 | `note done` after a login change that the user designed in a chat session | Draft cites the purpose and decisions from the session, names only classes and methods found in the real code, lists untested things under Not checked yet, creates no extra task. |
| 24 | User says "idea: use a queue for SMS retries" (no action) | One `type: idea` page, hub line, board and project Recent notes, Timeline view shows it, no task, sync receipt lists all four places. |
| 25 | Any write | The reply ends with the sync receipt: one line each for tasks, board, projects, project-tasks. A place with no change says `no change`. |
| 26 | Project page lists a Delivered row | The row links a done task. A delivery with no task is reported and the Draft for its task is shown. |
| 27 | Task text written for a finance team | English, no tables inside the note, no words like robust or seamless, concrete names and numbers, no empty headings. |
| 28 | A bug appears after a task was delivered | New bug task with Timeline line "caused by T-xxxx"; the delivered task is not reopened. |
| 29 | `task rewrite T-0011` | Draft in the new template, old Timeline lines kept word for word, written only after ok. |
| 30 | Open `project-tasks.base` in a project page | First tab is Timeline, ungrouped; clicking a column sorts across all rows. By name lists tasks A to Z. |

| 31 | `note done` for a feature built from 4 tickets, owner asks for a short note | Draft is one parent task (`Integrate <system> with <service>`, status review) plus 4 sub tasks, each a title, a one-sentence Outcome and one Not-checked line. Wiki page is a first line, two short paragraphs, task links, source. No tables, no full sections in chat. |
| 32 | Release report for a service with 4 endpoints (balance, mini statement, statement, inquiry) | One task per endpoint, subject says what the customer gets, description starts with Business purpose and has real request/response fields. Shared code is one `Build the shared ...` task. Story description lists the 4 endpoints. |
| 33 | Redmine push where Applications label is not given | Ask once for the exact label (or N/A). No guessed labels, no 422 loop. After the push, read the story: own estimate 0, total = sum of children. |
