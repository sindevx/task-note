# The four places (sync rule)

Single source for "what changes where". Core rules: core.md. Draft first: core.md.

Every write ends with the four places in agreement. They are:
| Place | File | Holds |
|---|---|---|
| tasks | `todo/tasks/T-*.md` | the truth |
| board | `todo/BOARD.md` | one table per project, plus Recent notes |
| projects | `todo/projects/<slug>.md`, block `tn:tasks` | counts, Delivered, Needs attention, Recent notes |
| project-tasks | `todo/project-tasks.base` | live views (By project, Timeline, By name, Open, Roadmap, Needs planning, Done). Nothing is written to it per command: it reads tasks and notes that link the project, so the task or note must carry `project: "[[slug]]"` |

Also touched when they apply: hub `wiki/<slug>-notes.md`, `raw/`, `log.md`, one `tn:` commit.

## Sync receipt (last lines of every write reply)
After writing, read the four places back and print one line per place: what changed, or `no change`.
`tasks: T-0079 edited · board: row updated · projects: Delivered +1 · project-tasks: no change (reads tasks) · hub: unchanged`
Never leave a place out. A place that should have changed and did not is a failure: fix it, then reply.

## What each case changes
| Case | tasks | board | projects | project-tasks |
|---|---|---|---|---|
| New request (requirement, Redmine) | new task, status todo, Purpose filled | new row | open count | Open, Timeline |
| Bug, issue, incident | new task, type bug | new row | Needs attention if priority high | Open, Timeline |
| Start work | status doing, Timeline line | row moves group | counts | Open |
| Decision while working | Timeline line | no change | no change | Timeline (new `updated`) |
| Work finished (`note done`) | done, outcome, change map, environment only when the owner says it (else empty) | done row (BOARD_DONE_DAYS) | Delivered +1 with environment badge | Done, Timeline |
| Reached UAT or production | `environment` and `environment_date` edited on the same task | environment column | badge in Delivered | Done |
| Bug found after delivery | new bug task, Timeline says "caused by T-xxxx" | new row | Needs attention if priority high | Open |
| Requirement changed | Timeline line: was X, now Y, why, who, when; old note gets Superseded | no change | no change | Timeline |
| Waiting on someone | blocked, `waiting_on`, `remind` | blocked group | Needs attention | Open |
| Note only (idea, howto, reference, decision or meeting with no action) | no task | Recent notes line (under the table, or under the heading when the project has no task yet) | Recent notes line | Timeline shows the page |
| Meeting with actions | meeting page, then one task per action after the Draft is confirmed | new rows | counts | Open |
| Work with no commit (investigation, ops, config) | task kind investigation or ops, evidence is code or values actually read | row | Delivered with kind `investigation` or `ops` | Done |
| New project | none | heading appears with its first task (no task yet: heading plus Recent notes line, no table) | Goal from a confirmed Draft | empty table |
| Cancel, reopen | status plus reason in Timeline | row | counts | Open or All |
A Delivery is a task with status done. Every row of Delivered links a task. A delivery with no task is a defect: create the task by Draft, never leave it out. `project status` and `report` also list a Delivered row with no done task. A Delivered `ref` (for example a commit) that cannot be confirmed in git is written `(unknown)` in the Draft and listed under Not checked yet.

## Recent notes
Wiki pages whose `project:` points to the project, `updated` within BOARD_DONE_DAYS, hub and roadmap pages left out. One line each: `[[page]] - why it matters (YYYY-MM-DD)`. In BOARD it sits under the project table. In the project file it sits inside the `tn:tasks` block after Needs attention.

## Sorting
Grouped views sort only inside a group. Timeline and By name have no grouping, so the owner can re-sort any column across everything. Keep it that way.
