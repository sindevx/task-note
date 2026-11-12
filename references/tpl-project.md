# Project and hub templates

Index of templates: templates.md. Links rules: templates.md, Links.

## Project: `<store>/todo/projects/<slug>.md`
```
---
schema: 2
id: <slug>
status: active        # active | paused | done
owner: <name>
repo: <path or empty>
notes: "[[<slug>-notes]]"   # the project hub page (see Project hub below)
roadmap: "[[<slug>-roadmap]]" # roadmap and KPI page (roadmap.md), empty until `project roadmap`
---
## Goal
<one or two lines>

## Summary
<!-- tn:tasks:start -->
<!-- tn:tasks:end -->

## Tasks
![[project-tasks.base]]
```
A manager opens this page and must see, in this order: counts and progress, what was delivered (with proof), what needs attention, then the live task table. Details of the work are one click away in the hub `[[<slug>-notes]]`.

Live view: `![[project-tasks.base]]` is an Obsidian Bases file (core plugin, no community plugin) at `<store>/todo/project-tasks.base`. Views in this order: By project (tasks grouped by `project`, group header shows the count), Timeline (tasks and notes of the project, no grouping, newest `updated` first, so any column can be re-sorted), By name (tasks, no grouping, A to Z by `title`), Open (grouped by status, sorted by priority, phase, step), Roadmap (grouped by `phase`, sorted by `step`), Needs planning (open tasks with no `estimate` or `next_action`; `due` is optional because only 3 of 204 tasks had one), Done (newest first, with environment, outcome, ref). Grouped views sort only inside a group, so the two ungrouped views are the ones to use when the owner wants one order across everything. Every view except Timeline is limited to `todo/tasks`. Its filter is `(task folder or wiki folder) and (file.hasLink(this.file) or this.file.ext == "base")`: embedded in a project page it shows that project's tasks and notes; opened directly it shows every task and note, so it is never empty. Reason: `this` is the base file itself when the base is opened on its own. Every view except By project starts with Project and ID (shown as names, not `file.name`). Formulas: `priority_rank` (high first, text sort would give high, low, normal), `days_open`, `cycle_days`. Open sorts by priority, phase, step. Numbers `phase` and `step` and the dates are typed in `.obsidian/types.json`. Create both when a project is added, if missing. Exact `types.json` body (the base file follows it):
```json
{"types": {"phase": "number", "step": "number", "start": "date", "due": "date", "remind": "date", "environment_date": "date", "created": "date", "updated": "date"}}
```
Exact base file:

```yaml
# copy verbatim into <store>/todo/project-tasks.base (everything up to the closing fence)
filters:
  and:
    - or:
        - file.inFolder("todo/tasks")
        - file.inFolder("wiki")
    - or:
        - file.hasLink(this.file)
        - this.file.ext == "base"
formulas:
  priority_rank: 'if(priority == "high", 1, if(priority == "low", 3, 2))'
  days_open: 'if(created, (today() - created).days, "")'
  cycle_days: 'if(started_at && done_at, (done_at - started_at).days, "")'
properties:
  file.name:
    displayName: ID
  project:
    displayName: Project
  assignee:
    displayName: Assignee
  requester:
    displayName: Requester
  next_action:
    displayName: Next step
  waiting_on:
    displayName: Waiting on
  blocked_by:
    displayName: Blocked by
  done_at:
    displayName: Done
  formula.days_open:
    displayName: Days open
  formula.cycle_days:
    displayName: Cycle days
views:
  - type: table
    name: By project
    filters:
      and:
        - file.inFolder("todo/tasks")
    groupBy:
      property: project
      direction: ASC
    order:
      - file.name
      - title
      - status
      - type
      - phase
      - step
      - priority
      - assignee
      - requester
      - updated
    sort:
      - property: file.name
        direction: ASC
  - type: table
    name: Timeline
    filters:
      and:
        - type != "hub"
    order:
      - project
      - file.name
      - title
      - type
      - status
      - tags
      - assignee
      - requester
      - updated
    sort:
      - property: updated
        direction: DESC
  - type: table
    name: By name
    filters:
      and:
        - file.inFolder("todo/tasks")
    order:
      - project
      - title
      - file.name
      - status
      - type
      - tags
      - assignee
      - requester
      - updated
    sort:
      - property: title
        direction: ASC
  - type: table
    name: Open
    filters:
      and:
        - file.inFolder("todo/tasks")
        - status != "done"
        - status != "cancelled"
    groupBy:
      property: status
      direction: ASC
    order:
      - project
      - file.name
      - title
      - phase
      - step
      - priority
      - estimate
      - next_action
      - blocked_by
      - waiting_on
      - assignee
      - requester
      - formula.days_open
    sort:
      - property: formula.priority_rank
        direction: ASC
      - property: phase
        direction: ASC
      - property: step
        direction: ASC
  - type: table
    name: Roadmap
    filters:
      and:
        - file.inFolder("todo/tasks")
        - status != "cancelled"
    groupBy:
      property: phase
      direction: ASC
    order:
      - project
      - file.name
      - title
      - status
      - step
      - assignee
      - requester
      - tags
      - estimate
      - due
      - done_at
      - outcome
    sort:
      - property: phase
        direction: ASC
      - property: step
        direction: ASC
      - property: file.name
        direction: ASC
  - type: table
    name: Needs planning
    filters:
      and:
        - file.inFolder("todo/tasks")
        - status != "done"
        - status != "cancelled"
        - or:
            - "!estimate.isTruthy()"
            - "!next_action.isTruthy()"
    order:
      - project
      - file.name
      - title
      - status
      - assignee
      - requester
      - estimate
      - next_action
      - due
    sort:
      - property: file.name
        direction: ASC
  - type: table
    name: Done
    filters:
      and:
        - file.inFolder("todo/tasks")
        - status == "done"
    order:
      - project
      - file.name
      - title
      - phase
      - step
      - done_at
      - assignee
      - requester
      - formula.cycle_days
      - outcome
      - ref
    sort:
      - property: done_at
        direction: DESC
      - property: file.name
        direction: DESC
```

### Summary block (between the `tn:tasks` markers)
Written by the skill, only between the markers. It is plain Obsidian markdown (callouts, tables), no plugin, so git, terminal and Claude can read it too. It is a copy: task files stay the truth. Layout:

```
> [!summary] 4 open · 2 done · 1 cancelled · progress 2 of 6 (33%)
> Rebuilt YYYY-MM-DD HH:MM · op=<OP-id> · notes: [[<slug>-notes]]

**Delivered** (nothing delivered yet: write `Nothing delivered yet.`)
| Task | Done | Outcome | Ref |
|---|---|---|---|
| [[T-0010]] Enhance Customer Info API | 2026-10-01 | Customer Info API returns only business and savings accounts; 11 tests pass | commit#9972cc8 · [[customer-info-account-filtering]] |

**Needs attention**
- 🔴 [[T-0001]] Re-apply Acme fee: blocked, waiting on pricing mapping endpoint fix
- 🟣 [[T-0012]] Verify customer-info on real core data: in review
- ⏰ [[T-0013]] Deploy billing logging: overdue 2 days (due 2026-09-30)
```
- Counts and progress: progress = done / (open + done), cancelled left out. When the project has phases, count steps only (phase tasks excluded), matching the roadmap KPI Overall progress. Show `progress 0 of 0` as `no tasks yet`.
- Delivered = tasks done within BOARD_DONE_DAYS, newest first. Columns: `Task | Done | Outcome | Ref`.
  - Done = `done_at`. Outcome = the task `outcome` field (required to be done, see cmd-task.md).
  - Ref = the task `ref`, then ` · ` and every link in the task `notes` list. Empty parts are left out.
  - A reader must answer "what was delivered, where is the proof" from this table alone.
- Needs attention = blocked (with `waiting_on`), review, a bug with high priority, overdue (due before today, not done), stale (STALE_DAYS). Empty: write `Nothing blocked or overdue.`
- Open tasks are not repeated here. The live Open view in the Bases table and BOARD.md show them.
- Cancelled tasks appear only as a count. Their reason stays in the task file.
- Overdue and stale are computed at rebuild time. The "Rebuilt" stamp tells the reader how fresh they are.
- Tables stay at most 5 columns so they fit Obsidian's reading width.

### Project hub: `<store>/wiki/<slug>-notes.md`
One hub per project. It is the table of contents of the whole development lifecycle of that project, so a manager or a new developer finds any note in one click. Created by `project add`, kept current by every note command.
```
---
type: hub
project: "[[<slug>]]"
tags: [hub]
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: reviewed
---
# <Project> Notes
> Index of requirements, issues, development notes and decisions for [[<slug>]].

## Requirements
- [[page]] - one line (YYYY-MM-DD) - tasks: [[T-0001]]

## Issues
- [[page]] - one line (YYYY-MM-DD) - status: open|resolved - tasks: [[T-0002]]

## Development notes
- [[page]] - one line (YYYY-MM-DD) - tasks: [[T-0003]]

## Decisions
- [[page]] - one line (YYYY-MM-DD)

## Meetings
- [[page]] - one line (YYYY-MM-DD)

## Incidents
- [[page]] - one line (YYYY-MM-DD) - status: open|resolved - tasks: [[T-0004]]

## How-to and references
- [[page]] - one line (YYYY-MM-DD)

## Ideas
- [[page]] - one line (YYYY-MM-DD)

## Other notes
- [[page]] - one line (YYYY-MM-DD)
```
Omit a section when it is empty. Every wiki page of the project appears here exactly once, and its front matter `project:` points back to the project. Task front matter `notes:` points to the pages, the pages list the tasks, and the hub lists both: all links work in both directions.
