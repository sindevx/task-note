# Status rules (single source of truth)

Statuses: todo, doing, blocked, review, done, cancelled.

## Allowed transitions
Anything not listed is E-BAD-TRANSITION.

| From | To |
|---|---|
| todo | doing, blocked, cancelled |
| doing | blocked, review, done, cancelled |
| blocked | doing, cancelled |
| review | doing, done |
| done | doing (only via `task reopen`) |
| cancelled | doing (only via `task reopen`) |

## Reason required
Moving to blocked or cancelled, and any reopen, needs a reason (E-REASON-REQUIRED). The reason goes into the Progress log line.

## Parent status (computed from sub tasks, never set by hand)
Evaluate top to bottom, first match wins. Cancelled sub tasks are ignored. If every sub task is cancelled, the parent keeps its last status.

| Sub tasks | Parent |
|---|---|
| all done | review |
| any doing or review, or any done | doing |
| any blocked (none doing, review or done) | blocked |
| all todo | todo |

Commands on a task that has sub tasks: `start`, `unblock`, `block`, `review` are refused (E-PARENT-STATUS) because its status is computed. `log`, `edit`, `done`, `reopen` and `cancel` are allowed. `done` and `cancel` need every sub task done or cancelled (E-SUB-OPEN).

- Only a person moves a parent from review to done (`task done`). Reason: sub tasks finishing does not prove the whole job was checked.
- Adding a sub task to a parent in review sets the parent back to doing.
- Max depth is 2 (task, sub task). A sub task cannot have sub tasks (E-DEPTH).

## Blocked needs a waiting target
Moving to blocked also needs `waiting_on` (who or what). Reason says why, `waiting_on` says who must act (E-WAITING-REQUIRED). `waiting_on` is cleared when the task leaves blocked.

## Dates and auto fields
- `start`, `due`, `remind`, `estimate`, `next_action` are typed by the user. Format: DATE_FORMAT (config.md).
- `started_at` = date of the first move to doing. Never changes after. Set by the skill only.
- `done_at` = date of the move to done. Cleared on reopen. Set by the skill only.
- Backfill (the owner asked, or `note done` on past commits): the skill sets `started_at` and `done_at` from the commit dates and writes two Timeline lines per step, both marked `backfill`: `- <date> todo -> doing: backfill from git ...` and `- <date> doing -> done: backfill from git ...`.
- `start` after `due` is E-DATE-ORDER. `--yes` does not skip it.
- Derived, never stored: days overdue (today after `due`, not done), age (today minus `created`), stale (doing and no Progress log line for STALE_DAYS), slip (`done_at` minus `due`), cycle time (`done_at` minus `started_at`).
- Today means the date in TIMEZONE.

## Inbox
Tasks created by ingest carry tag INBOX_TAG until `task confirm`. Inbox tasks are excluded from `task next`. They are listed in their own group in `task remaining`.

## Timeline line (the Progress log)
`- YYYY-MM-DD <plain sentence>`. A status change starts with `<old> -> <new>:`, for example `- 2026-10-07 doing -> done: login saves playerId after the password check`. The op id lives in log.md and in the commit message, not in the line. Plain `task log` uses the same shape without the arrow. Never delete or edit old lines. Older tasks keep their old lines, which end with `(op=OP-...)`.
