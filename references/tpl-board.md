# BOARD, digest and log templates

Index of templates: templates.md. Links rules: templates.md, Links.

## BOARD.md: `<store>/todo/BOARD.md`
```
# Board (schema 2, rebuilt YYYY-MM-DD HH:MM op=<OP-id>)

## [[<project id>]]
| id | title | type | priority | status | environment | start | due | next_action | waiting_on | parent |
|---|---|---|---|---|---|---|---|---|---|---|
```
Rows: every open task, plus done or cancelled tasks changed within BOARD_DONE_DAYS.
Projects are listed alphabetically. The `start` column is the planned `start` field, not `started_at`.
Under each project table, when wiki pages of that project changed within BOARD_DONE_DAYS: a line `Recent notes` and one bullet per page, `[[page]] - why it matters (YYYY-MM-DD)` (sync.md). Hub and roadmap pages are left out.
Drift checks (`tn doctor`) ignore table padding and empty rows, because Obsidian re-formats tables.
Cells: id as `[[T-0001]]`, parent as `[[T-0001]]` or empty. Titles are plain text.
Sort: a project with a roadmap is sorted by `phase`, then `step`, then id, with one line under its heading: `Roadmap order (phase, step). Roadmap: [[<slug>-roadmap]]`. Other projects: status doing, blocked, review, todo, then done and cancelled last. Inside a status: priority (high, normal, low), then due ascending (empty last), then id.

## Digest: `<store>/DIGEST_DIR/YYYY-MM-DD.md`
Written by `task remaining --save` and `report digest --save`. No secrets, no raw content.
```
# Digest YYYY-MM-DD (schema 2, op=<OP-id>)
Counts: overdue N, due soon N, doing N, blocked N, stale N, no date N, inbox N

## Overdue
- T-0001 <title> (due YYYY-MM-DD, N days late) next: <next_action>
## Due soon
## Doing
## Blocked
- T-0001 <title> waiting on: <waiting_on>
## Stale
## No date
## Inbox (unconfirmed)
## Done since last digest
```
Empty groups are omitted. Order inside a group: due ascending, then priority.

## log.md line
`YYYY-MM-DD HH:MM <command> <ids> op=<OP-id>`
