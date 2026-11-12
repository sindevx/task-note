# Error codes (single source of truth)

Message format: `<CODE> <id-or-field>: <rule that failed>. Use: <fix>`
Never print secret values. Name the field and the rule only.
Example: `E-BAD-TRANSITION T-0042: status done -> doing violates transition table. Use: task reopen T-0042 <reason>`

| Code | When | Writes files? |
|---|---|---|
| E-STORE-MISSING | store folder not found | no |
| E-NOT-FOUND | id not found. Show up to 3 close ids | no |
| E-AMBIGUOUS | id or project name matches more than one | no |
| E-NO-PROJECT | project not given and cannot be resolved. Exception: `note` commands still store the raw with project `unassigned` (capture.md), then ask | no (`note`: raw and INDEX row only) |
| E-BAD-TRANSITION | status change not in status-rules.md | no |
| E-SUB-OPEN | `task done` on a parent with sub tasks not done | no |
| E-REASON-REQUIRED | block, cancel, reopen or ignore without reason | no |
| E-DEPTH | sub task under a sub task | no |
| E-DUP | same title + project, still open, created within DUP_WINDOW_HOURS. Skip with `--yes` | no |
| E-SECRET | secret found in input. Value redacted before any write | yes (redacted copy only) |
| E-LOCK | another session holds .tn.lock | no |
| E-SCHEMA | frontmatter missing or invalid. Name file and field | no |
| E-INGEST-FAILED | ingest stopped midway. Raw set to `failed` with reason | yes (INDEX only) |
| E-PARENT-STATUS | start, unblock, block or review on a task that has sub tasks (its status is computed) | no |
| E-CONFIRM-REQUIRED | `task done` on a task that has a "Done when" section (old tasks, roadmap steps) with unticked items Ask the user, then repeat with `--yes` | no |
| E-OUTCOME-REQUIRED | `task done` without an `outcome` (one line: what was delivered and the proof). Use: `task edit <id> --outcome "..."` | no |
| E-GIT-FAILED | a git command in the store failed. Message carries git's own error | no |
| E-DIRTY | `tn undo` while the store has uncommitted changes | no |
| E-WAITING-REQUIRED | block without `--waiting` | no |
| E-DATE-FORMAT | date field not DATE_FORMAT, or not a real calendar date. Name the field | no |
| E-DATE-ORDER | `start` after `due`. Name both values | no |
| E-PUSH-INCOMPLETE | `task push` with an empty required field (cmd-task.md, Gate before upload). Name every empty field | no |
