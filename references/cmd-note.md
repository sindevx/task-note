# note commands
Core rules: core.md. Raw type handling: formats.md.

## note: capture and process raw
| Command | Effect |
|---|---|
| `note <input>` (no verb) **one-stop** | `input` = pasted text, pasted JSON, file path, `redmine#id`, an issue URL, or commit hash(es) in the current repo (a commit hash routes to the `note done` flow, dev-note.md). Runs `note add` then `note ingest` in one go, then prints: raw id, wiki page touched, tasks created (ids), anything redacted. Shows a Draft first (core.md); tasks are proposed in the Draft and created only after "ok". Empty input: ask once what to note. |
| `note add <text\|path\|redmine#id> [--type auto\|text\|json\|log\|csv\|redmine\|issue\|image] [--project] [--title]` | Detect type, scan secrets, store in `raw/`, add row to `raw/INDEX.md` status `new`. Same sha256 as an existing raw: return that id, write nothing. |
| `note list [--new] [--project] [--since 7d]` | List raw files and status. Read only. |
| `note show <R-id>` | Type, project, size, status, wiki pages and tasks created from it. Read only. |
| `note ingest <R-id\|path\|--new> [--dry-run] [--yes]` | Summarize into wiki, extract tasks, update index and log. Always show the proposal first. Ask to confirm if more than CONFIRM_TASK_THRESHOLD tasks. Tasks are created only from a confirmed Draft; a note with no action creates no task (sync.md, Note only). |
| `note ignore <R-id> <reason>` | Set `skipped`. Reason required. |

Raw states: new, proposed, ingested, failed, skipped. A failed ingest must end as `failed` with a reason (E-INGEST-FAILED), never half done.
Raw files are never edited after capture. Format handling: formats.md.

## note: lifecycle records
Stages and linking rules: lifecycle.md. Page layouts: writing.md.
| Command | Effect |
|---|---|
| `note requirement <text\|path\|redmine#id>` | Capture raw, write a `type: requirement` page, add it to the project hub, propose tasks (intake.md). Missing acceptance criteria: ask once. |
| `note issue <text\|path\|log\|redmine#id>` | Capture raw, write a `type: issue` page (symptom, evidence, impact, cause, status), add it to the hub, propose a fix task. |
| `note done [T-id]` | Development note for finished work (dev-note.md). Updates task `outcome`, `notes`, `ref`, the hub and the Summary block. |
| `note hub <slug>` | Rebuild the project hub `wiki/<slug>-notes.md` from the front matter of the wiki pages. Report pages missing from it. |

## Trigger words: note, task, or both
Pick the command from the moment. Page types for `note <input>` come from intake.md (`type:`). `note decision`, `note meeting` and the other types are not commands: the user starts the text with "decision:", "meeting:", "incident:", "idea:", "howto:" or "ref:" and the one-stop `note <input>` sets the page type. Without a prefix, capture.md triage picks the type. Capture first, ask later (capture.md).
| Moment | User says | Creates | Run |
|---|---|---|---|
| New request | `note requirement` + ticket, chat or doc | note + task | `note requirement`, then `task add` |
| Bug or prod log | `note issue` + log or error | note + task | `note issue`, then `task add` |
| Any raw input | `note <anything>` | raw + page + inbox tasks | `note <input>`, then `task confirm` |
| Decision made | "decision: ... because ..." | note (decision) + log line | `note <input>`, then `task log` |
| Meeting | "meeting: ..." | note (meeting) + action tasks | `note <input>` |
| Start, progress, block, review, edit, reopen | "start/log/block/review T-id ..." | task only | matching `task` command |
| Finished coding | "I finished T-id, note my work" | dev note + done task + follow-ups | `note done`, `task done` |
| Extra work found | "add task ..., from T-id" | task linked to note | `task add` |
Rule: input with a reason or evidence (request, log, meeting, decision) gets a note first, then a task that lists the page in `notes`. A pure state change gets a task only. Finished work always gets both.
