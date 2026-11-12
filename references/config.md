# Config (single source of truth for every number and default)

Other files refer to these names. Change a value here, nowhere else. Personal overrides go in `local.md` (git-ignored) and win over this table.

| Name | Value | Used by |
|---|---|---|
| SCHEMA_VERSION | 2 | `schema:` value in project and task files, BOARD header, digests |
| STORE_PATH | ~/task-note-store | folder of the store (raw, wiki, todo). Set it in `local.md`; SKILL.md reads it from there |
| TIMEZONE | UTC | every date and time written by the skill |
| WORKDAYS | Mon-Fri | scheduled digest runs only on these days |
| TODAY_WINDOW_DAYS | 3 | `task today`: show tasks due within this many days |
| DUE_SOON_DAYS | 7 | `task remaining`: "due soon" group (calendar days) |
| STALE_DAYS | 5 | doing task with no Progress log line for this long is stale |
| BOARD_DONE_DAYS | 14 | BOARD.md and project Summary blocks list open tasks plus tasks done or cancelled within this many days. Older ones stay in their files only, so BOARD never grows without limit |
| OPEN_TOO_LONG_DAYS | 7 | `wiki lint`: task open longer than this |
| DIGEST_TIME | 08:30 | when a scheduled digest should run |
| DIGEST_DIR | todo/digests | where `--save` writes snapshots |
| CONFIRM_TASK_THRESHOLD | 3 | Draft is always shown first; above this many tasks the Draft lists titles only |
| DUP_WINDOW_HOURS | 24 | E-DUP window for same title + project |
| LOCK_STALE_MINUTES | 10 | `.tn.lock` older than this counts as stale |
| LARGE_FILE_MB | 1 | raw larger than this is sampled, not fully read |
| DATE_FORMAT | YYYY-MM-DD | all date fields |
| TASK_TYPES | bug, feature, chore, ops, docs, test, investigation, release | allowed values of the task `type` field |
| INBOX_TAG | inbox | tag set on tasks created by ingest until confirmed |
| NOTE_LANGUAGE | en | language of polished notes (writing.md). Example override: `en`, `th` |
| TITLE_MAX_CHARS | 80 | task title length |
| DEV_NOTE_MAX_COMMITS | 30 | `note done`: most commits listed in one development note |
| READ_BUDGET_LINES | 200 | max lines read from one raw or task body at once (see token rules in SKILL.md) |
| SUBAGENT_RAW_MB | 1 | raw larger than this: ingest through a cheaper subagent (haiku), not the main model |

## Delivery of remaining-work reports
Default: reply in chat, and with `--save` write the snapshot to DIGEST_DIR.
Optional, only when the user asks for it: `--notify` shows a macOS notification with counts only.
Scheduling a daily digest (DIGEST_TIME on WORKDAYS) is created only after the user confirms. Sending to email or chat apps leaves the machine: show the exact text and ask every time.
