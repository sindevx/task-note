# Core rules (read for every command)

Grammar: `<noun> <verb> [args] [--flags]`. Nouns: note, task, project, wiki, board, report. System helpers: `tn doctor`, `tn undo`, `tn version`.
Status rules: status-rules.md. The four places and the sync receipt: sync.md. Error codes: errors.md. Numbers and defaults (days, thresholds, timezone): config.md. Do not repeat them here.

## Global flags
- `--project <id>` override project resolution.
- `--dry-run` show what would change, write nothing.
- `--yes` skip confirmation (never skips E-SECRET or E-BAD-TRANSITION).
- `--brief` (default) changed ids + new status + op id. `--full` adds the diff.

## Ids
- Task `T-0001`, sub task `T-0001.1`, raw `R-YYYYMMDD-NNN`, project slug `[a-z0-9-]`.
- Short form `42` means `T-0042`. If more than one match: E-AMBIGUOUS, ask, never guess.
- New task id = highest existing + 1. List `todo/tasks/` first, every time.

## Links in files
Front matter and BOARD hold wiki links (templates.md, Links). Accept user input as plain `42`, `T-0042` or `teller-service`. When matching with `grep`, match both `project: "[[x]]"` and `project: x`. Always write the wrapped form.

## Project resolution (when `--project` not given)
1. Current directory name equals a file in `todo/projects/`.
2. `repo:` field of a project matches the current directory.
3. Otherwise E-NO-PROJECT: ask the user.

## Mutation procedure (every command that writes)
1. Acquire `.tn.lock`. Held by another live session: E-LOCK. Older than LOCK_STALE_MINUTES: tell the user, then take it.
2. Read target files. Validate frontmatter (E-SCHEMA) and the rule for this command.
3. Create op id `OP-YYYYMMDD-HHMM-xx`.
4. Write temp file, then rename (atomic). Never leave a half-written file.
5. Recompute parent status. Rebuild BOARD.md and the Summary block of each project file the command touched (only between the `tn:tasks` markers, never outside). If the command wrote or changed a wiki page, update that project's hub `<slug>-notes` (templates.md) in the same step.
5b. Read tasks, board, projects and project-tasks back and build the sync receipt (sync.md). A place that did not change when it should have is a failure: fix it first.
6. Append the Timeline line (date and a plain sentence) and the log.md line. log.md and the commit message carry the op id.
7. `git add` only the files this command changed (never `.tn.lock`, never `git add -A`), then `git commit`: `tn: <command> <ids> op=<OP-id>`. Local only. The skill never pushes the store to a remote; only the owner does, by hand.
8. Release lock. Print brief result.

Read-only commands skip steps 1, 3-8.

## Draft first
Before any write that creates or rewrites text (task add, note, task done outcome, project Goal, rewrite of an earlier task or note), show the Draft in chat as the finished text, in human voice (writing.md), and wait for "ok" or edits. Only then run the mutation procedure.
- No Draft needed: status moves, one-line Timeline entries, rebuilds of BOARD and Summary. Report them in one line afterwards.
- Never create a follow-up task on your own. Write it as a line under "Not checked yet" and ask whether it should become a task.
- **Keep the Draft short.** Show a feature as one parent task plus one sub task per delivered unit. Each task in the chat Draft is a title, a one-sentence Outcome and one "Not checked yet" line. The full sections (Purpose, What happened, change map, Timeline) go only in the written file. The wiki page is a first line, two short paragraphs and links. Long text only when the owner asks for it.
- A Draft states only facts from Evidence (writing.md rule 10). A fact that cannot be found is left out or marked `(unknown)`, and at most one question is asked.

## Manual edits (for example in Obsidian)
Task files are plain markdown, so the user may edit them by hand. Read the file fresh before every write and treat it as the truth. Never overwrite text outside the fields and blocks the command owns. Manual status edits skip the transition check and the Progress log: `tn doctor` reports them. Tell the user to change status with commands.

## Secrets
Scan every input before any write: token, Bearer, JWT, private key, password, card number 13-19 digits (Luhn), account number, PIN.
On a hit: store only the redacted copy (`[REDACTED:<type>]`), never the original. Tell the user type and count, never the value (E-SECRET). Also tell the user the value is already in this session's history and should be rotated if it was real.

## Natural language shortcuts (Thai example)
| Phrase | Command |
|---|---|
| งานค้าง, งานที่เหลือ, อะไรเหลือบ้าง | `task remaining` |
| งานทั้งหมดที่ยังไม่เสร็จ | `task list` |
| งานวันนี้ | `task today` |
| ควรทำอะไรต่อ | `task next` |
| งานที่รอยืนยัน | `task inbox` |
| สรุปประจำวัน | `report digest` |
| สรุปสัปดาห์ | `report week` |
| จดไว้ <ข้อความ หรือ json หรือ issue> | `note <input>` (one-stop) |
| log งาน, วันนี้ทำ ..., เริ่มทำ ..., ทำเสร็จ ..., integrate form F1 ..., db design ... | `dev log <text>` (roadmap.md) |
| roadmap, phase, ลำดับงาน, ทำตั้งแต่ 0 | `project roadmap <slug>` |
| KPI, ผลงาน, progress ต่อ phase | `report kpi` |

## Acceptance checks per command
1. Normal run: files change as specified, op id appears in Progress log, log.md and commit.
2. Run twice: no duplicate.
3. Violated rule: error code from errors.md, no file written.
4. `--dry-run`: no file changes.
5. `tn undo`: restores the state before the command.
