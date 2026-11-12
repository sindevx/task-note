---
name: task-note
description: Notes, tasks and project tracking in one central markdown store, usable from any project directory. Use when the user says "note this", "add a task", "start/block/finish a task", "what is remaining", "what should I do next", "project status", "daily digest", "dev log", "log my work", "roadmap", "KPI", or pastes text, JSON, logs or an issue to record. Also Thai: งานค้าง, งานวันนี้, จดไว้, สรุปสัปดาห์, log งาน. Also when the user says a result is not OK or needs a redo: the skill fixes it and learns from it.
version: 1.0.0
---

# task-note

One central store for notes and tasks. Works from any project directory. Claude does all the work by judgement and by the references. No script is used.

**Setup:** read `local.md` first if it exists (personal, git-ignored; copy `local.example.md`). It sets `STORE_PATH`, overrides any value in `config.md`, and holds your preferences and the lesson Log. `lessons.md` holds only the shared Active checks. No `local.md`: use `config.md` defaults and ask the user for the store folder once.

**Redmine push:** `task push` follows the review, confirm, push rule in `cmd-task.md`. If a companion skill `redmine-report` is installed, call it first to prepare the draft.

## Load only what the command needs
Check the folder in STORE_PATH exists first (E-STORE-MISSING if not). Read `references/core.md`, then the files for the request:

| Request | Also read |
|---|---|
| `note <input>`, any pasted text, JSON, log, issue, commit hash | `intake.md`, `cmd-note.md`, `capture.md`, `formats.md`, `writing.md`, `tpl-project.md` (hub entry), `sync.md`, `lessons.md` (Active checks). A commit hash or finished work also loads the `development finished` row |
| add a task or sub task | `intake.md`, `cmd-task.md`, `tpl-task.md`, `status-rules.md`, `lessons.md` (Active checks) |
| start, block, done, log, edit, reopen, cancel | `cmd-task.md`, `status-rules.md` |
| `task push`, `task pull`, Redmine, estimate, spent time, support case | `cmd-task.md` (Push to Redmine), `intake.md` (estimate), `tpl-task.md`, `config.md`, `lessons.md` (Active checks) |
| what is left, today, next, list, groom | `cmd-task.md`, `intake.md` (groom) |
| development finished, write it up | `dev-note.md`, `intake.md`, `writing.md`, `tpl-task.md`, `lifecycle.md`, `status-rules.md`, `sync.md`, `lessons.md` (Active checks) |
| `project`, `wiki`, `board`, `report`, `tn doctor` | `cmd-admin.md` |
| `dev log`, `task add --phase`, `project roadmap`, `report kpi`, phases, KPI, "log my work", "integrate form F1" | `roadmap.md`, `cmd-task.md`, `tpl-task.md`, `status-rules.md`, `lessons.md` (Active checks) |
| requirement, issue, "what was asked / what went wrong / what was built", reports for a manager | `lifecycle.md`, `writing.md`, `tpl-project.md` |
| what changes where for each case, sync receipt, Recent notes | `sync.md` |
| error codes, numbers and defaults | `errors.md`, `config.md` |
| unsure how a result should look, or after changing a reference file | `examples/` (`evals.md` = regression cases) |
| user is not OK with a result, asks for a redo, corrects or rewrites what the skill wrote, `tn undo`, "improve the skill" | `feedback.md`, `lessons.md`, `local.md` (Log) |

Do not read the other files.

## The one rule that matters
**Never store only what the user typed, and never store a guess.** Every task and note passes `intake.md`. Facts come from the real code, git, results actually seen and the owner's own words. The owner sees a Draft in human voice first (`core.md`, Draft first). A write ends with the sync receipt of the four places: tasks, board, projects, project-tasks (`sync.md`). No task is created without the owner's ok.

## Hard rules
- **Learn from "not OK" and from issues found.** When the user is unhappy with a result, or a push, check or read-back shows a problem (feedback.md signals), fix the result first, then find the cause, patch the owner reference file, log it in the Log of local.md (feedback.md), and sweep the store for the same defect. Every write command also runs the Active checks in lessons.md before replying.
- Never edit a file in `raw/` after capture.
- Redact secrets before any write. Never print a secret value.
- Notes are written in English (NOTE_LANGUAGE), in human voice (`writing.md`, Human voice). Chat follows the user's language.
- Never write to Redmine or any external system except through `task push` with confirmation.
- Every write follows the mutation procedure in core.md: validate, write, rebuild BOARD and project Summary block, update the project hub, log.md, one local commit with the op id.
- Task files are the truth. BOARD.md and project Summary blocks are copies.
- Never guess an ambiguous id or project. Ask.
- Bad input: print the error code from errors.md and write nothing.
- Notes and task text follow writing.md: professional wording, facts exact, nothing invented.
- Reply in the user's language. Keep ids, commands and error codes exact.
- After a write, reply with a compact table of the final values, the ids changed, the op id, `Quality: N/10` (lifecycle.md Quality bar) and the sync receipt. No raw content.

## Token rules
- List and status questions: read `todo/BOARD.md` once. Open a task file only when its details are needed.
- Find one task: `grep -l` in `todo/tasks/`, then read that file only.
- Next id: list file names in `todo/tasks/`. Do not open the files.
- Read at most READ_BUDGET_LINES lines of a raw or task body at once. Sample larger input (formats.md).
- Raw larger than SUBAGENT_RAW_MB: ingest through a cheaper subagent and take back only the summary.
- Never paste raw content into the reply. Give ids and counts.

## Entry points
- Routing: pasted text, JSON, a log or a link is `note`. A short imperative that names work ("fix X", "add X", "retest X") is `task add`. Unsure which: ask once.
- One stop: `note <anything>` (text, JSON, file path, `redmine#id`, issue URL).
- Work: `dev log <text>` (developer log: finds the step, logs, links commits), `task add` (`--parent` makes a sub task), `task start/log/block/done/groom`.
- Plan: `project roadmap <slug> [--from-git]` (11 phases from analysis to go-live), `task add <title> --phase N`.
- Review: `report kpi`, `task remaining`, `task next`, `task today`, `task list`, `task tree`, `task inbox`, `project status`, `report digest`, `report week`.
- Health: `wiki lint`, `tn doctor`, `tn undo`.
- Scheduled or external delivery of a digest: only after the user confirms (config.md).
