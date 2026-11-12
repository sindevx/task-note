# Evals: regression cases for the skill

Run by hand after any change to a reference file. Use a scratch store (set `STORE_PATH` to a temp folder) and keep your personal `local.md` out of the run. Feed the input, compare with Expected. A failed case means the change broke a rule: fix the change, not the case.
The feedback loop (feedback.md) adds one case here for every lesson that is not a Preference.

`*` = inferred value, marked in What happened and in the reply.

| # | Input | Expected |
|---|---|---|
| 1 | `fix customer-info missing savings account urgent by friday` | Routed to `task add` (short imperative, SKILL.md routing). Task: type bug, priority high*, due resolved to a date, estimate* (proposed for a high priority task), a Purpose line, at least one Not checked yet line. High priority: table shown for one confirmation before create. |
| 2 | Pasted JSON containing `"password": "abc"` | Raw stored with `[REDACTED:password]`, reply gives type and count only, value never printed (E-SECRET), rotate warning. |
| 3 | Same text noted twice | Second run returns the first R-id, writes nothing (formats.md, same hash). |
| 4 | `decision: use Redis dedup window 60s because duplicate payments` | One `type: decision` page, listed once in the hub, no task unless a follow-up is stated. |
| 5 | Meeting text with 2 action items and 1 bug | Pages: meeting plus issue. 2 action tasks and 1 fix task, tag inbox until confirmed, each task has `notes` link. |
| 6 | `note` text with no project and cwd not a project | Raw stored, project `unassigned`, no page, one question: which project. |
| 7 | Topic that already has a wiki page, and the new input adds to it without contradicting it | Dated `## Update` section appended, `updated:` changed, no near duplicate page. |
| 8 | `task done T-0042` on a task with an unticked Done-when item (old task or roadmap step) | Refused: E-CONFIRM-REQUIRED (outcome is checked first). No file written. The unchecked item is listed; a verification task is offered only if the owner says yes. |
| 9 | `task done T-0042` with no outcome | E-OUTCOME-REQUIRED. No file written. |
| 10 | 5 tasks would be created from one note | Proposal shown first (above CONFIRM_TASK_THRESHOLD: at exactly 3 tasks the Draft is full, titles only starts at 4), created only after one answer. |
| 11 | `howto: restart wallet service` with 3 steps | `type: howto` page, steps copied exactly, a missing step is `(unknown)`. |
| 12 | Reply after any write | Compact table of final values, ids, op id, `Quality: N/10`. No raw content. |
| 13 | Open `todo/project-tasks.base` directly in Obsidian | Rows of every project are shown (filter `or this.file.ext == "base"`); embedded in a project page only that project's tasks show. |
| 14 | `dev log integrated form F1 with Partner UAT, got success` in ~/Project/acme-portal | Step 8.11 (or the F1 step) found, todo -> doing, new commit hashes added to `ref`, one log line; asks once for the missing estimate (none invented); no new task unless no step matches. |
| 15 | `task add design the reconciliation table` with no phase | Phase 2 chosen by the keyword map (`design` matches the earlier phase row), shown in the reply, title `2.N ...`, `phase: 2`, `step: N`. |
| 16 | `report kpi --project acme-portal` | Progress per phase printed; on-time rate and estimate accuracy say `not measurable` for backfilled steps without due or estimate. |
| 17 | `project roadmap acme-portal` on a project with 15 forms | Phase 6 has 15 check steps, phase 8 has 15 steps `Integrate form Fn ... with Partner UAT` with the same 8-item chain, phase 10 lists 15 forms; roadmap page has a Unit tracker. No single 'all forms' step. |
| 18 | New page says Partner refuses duplicates (code 00003) while an older page says Partner has no dedup | Older page gets a `Superseded` callout directly under its `# title` line (writing.md rule 8) in the same write; old text kept; the new page is in the hub. |
| 19 | `project roadmap --from-git` backfills 20 steps | Every backfilled step has tag `backfill`; roadmap page numbers sit inside `tn:roadmap` markers; BOARD section in phase/step order (rows are open tasks and done ones within BOARD_DONE_DAYS, tpl-board.md). |
| 20 | `note` for a commit: dev note and task for work in git | Every class, method, table and system named in the task and the note appears in `git show <hash>`; no vendor or product name that the commit lacks; a code comment that the code body does not back is not repeated; unverified items sit under Not checked yet (a verification task is offered in the Draft, created only on the owner's yes); raw evidence file, hub row, BOARD, Summary, log.md and one `tn:` commit exist. |
| 21 | Open `project-tasks.base` embedded in a project without phases | First view is By project; the Open view shows rows; Needs planning lists open tasks with no `estimate` or no `next_action` (`due` is optional). |
| 22 | `tn doctor` on a store where a project has 12 tasks and no roadmap | Reports the project as information only (a roadmap is opt-in, nothing is pushed); reports the count of open tasks with no `estimate` or no `next_action` and proposes `task groom`. |
| 23 | `note done` after a login change that the user designed in a chat session | Draft cites the purpose and decisions from the session, names only classes and methods found in the real code, lists untested things under Not checked yet, creates no extra task. |
| 24 | User says "idea: use a queue for SMS retries" (no action) | One `type: idea` page, hub line, board and project Recent notes, Timeline view shows it (without Obsidian: check the base parses and the page links the project, and mark STATIC), no task, sync receipt lists all four places. |
| 25 | Any write | The reply ends with the sync receipt: one line each for tasks, board, projects, project-tasks. A place with no change says `no change`. |
| 26 | Project page lists a Delivered row | The row links a done task. A delivery with no task is reported and the Draft for its task is shown. |
| 27 | Task text written for a finance team | English, no tables inside the note, no words like robust or seamless, concrete names and numbers, no empty headings. |
| 28 | A bug appears after a task was delivered (priority as the owner states it; Needs attention only when high) | New bug task with Timeline line "caused by T-xxxx"; the delivered task is not reopened. |
| 29 | `task rewrite T-0011` | Draft in the new template, old Timeline lines kept word for word, written only after ok. |
| 30 | Open `project-tasks.base` in a project page | The Timeline view is ungrouped; clicking a column sorts across all rows. By name lists tasks A to Z. Order of views: By project, Timeline, By name, Open, Roadmap, Needs planning, Done. |

| 31 | `note done` for a feature built from 4 tickets, owner asks for a short note | Draft is one parent task (`Integrate <system> with <service>`, status review) plus 4 sub tasks, each a title, a one-sentence Outcome and one Not-checked line. Wiki page is a first line, two short paragraphs, task links, source. No tables, no full sections in chat. |
| 32 | Release report for a service with 4 endpoints (balance, mini statement, statement, inquiry) | One task per endpoint, subject says what the customer gets, description starts with Business purpose and has real request/response fields. Shared code is one `Build the shared ...` task. Story description lists the 4 endpoints. |
| 33 | Redmine push where Applications label is not given | Ask once for the exact label (or N/A). No guessed labels, no 422 loop. After the push, read the story: own estimate 0, total = sum of children. |
