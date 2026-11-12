# Intake: turn typed words into a complete, professional task or note

Rule: never store only what the user typed. Every new task, sub task and note passes intake. The user types a few words. The record that comes out is what a careful project lead would write.
Claude does this by judgement. No script. Templates: templates.md (index). Wording: writing.md. Page type and find-before-create: capture.md.

## Principles
1. **Keep every fact exactly.** Names, ids, numbers, dates, error text, URLs.
2. **Fill only what evidence supports.** Evidence is the real code, git history, results actually seen, and the owner's own words, including the conversation where the work was designed. A field with no evidence stays empty or becomes one question.
3. **Never invent facts.** Inferred values come from the rubrics below, are labelled `(inferred)` in the "What happened" section, and are shown to the user.
4. **Ask little.** Ask at most two questions, only for facts that change the work: the project when it cannot be resolved, the due date of a high priority task. Otherwise decide, create, and show what was inferred.
5. **Empty is honest.** If neither the input nor a rule gives an honest value, leave the field empty and list it under "still open" in the reply.
6. **Draft first.** The owner sees the finished, human-worded text before anything is written (core.md, Draft first).
7. **No self-made tasks.** Follow-ups, risks and unchecked items go into the task as lines under "Not checked yet". A task is created only when the owner says so.

## Field rubric (task)
| Field | How to fill |
|---|---|
| title | Verb + object + system, up to TITLE_MAX_CHARS. Exact system, form and endpoint names. Project with a roadmap (project `roadmap:` set): prefix `N.M ` (phase.step), for example `8.11 Integrate form F1 Balance with Partner UAT end to end`. One title per unit of work (one form, one table, one endpoint), never "all forms" (roadmap.md). |
| phase / step | Project with a roadmap: phase from `--phase` or the keyword map in roadmap.md (show it), step = highest step in that phase + 1. Set parent to the phase task. No roadmap: empty. |
| type | One of TASK_TYPES. fix, error, wrong, bug -> `bug`. add, new, support, design, build, implement -> `feature`. config, deploy, restart, monitor, access -> `ops`. test, verify, retest, UAT -> `test`. why, check, analyse -> `investigation`. write doc, update doc -> `docs`. go-live, release, deploy to production -> `release`. cleanup, refactor, upgrade -> `chore`. No keyword matches: pick the closest type, mark it `(inferred)` and give the reason in What happened. |
| priority | **high**: production or customer-visible failure; security, audit or regulatory item; hard deadline within TODAY_WINDOW_DAYS; blocks other people or teams; the user says urgent, ด่วน or ASAP. **low**: cleanup, nice to have, docs with no deadline; the user says "when free". **normal**: everything else. Say the reason in What happened. |
| start | Only when the user states or implies it ("today", "from Monday"). Else empty = not scheduled. `started_at` is never typed. |
| due | An explicit date, or a relative phrase converted to YYYY-MM-DD in TIMEZONE ("Friday" = the next Friday after today, unless the user said today). Show the resolved date. High priority without a date: propose one and ask. Otherwise leave empty. |
| estimate | Leave empty unless the owner gives one or agrees to one. Propose only when asked, or when the task will be pushed to Redmine: then propose hours by the table in cmd-task.md (Estimate rule), marked `*`, and wait for the owner. A high priority task also gets a proposed estimate marked `*` in the Draft. The push stays blocked until the owner confirms. After ok, write the estimate and keep the `(inferred)` reason in What happened. |
| purpose | One line, first in the task: why this exists. From the owner or the real conversation. Never guessed. If unknown, ask once. |
| what happened | Short paragraphs in plain words: who asked, what was decided and why, what was done. Every `(inferred)` value is marked with its reason. |
| change map | For development: one line per layer actually touched (database, entity or DTO, repository, service, controller or API, config, security and logs, outside systems, tests, deploy), read from the real code. Also what was not done, and why. |
| kind, environment | kind: code, investigation, ops or docs. environment: dev, UAT or production, the furthest place the work has reached, set from what the owner says and never guessed from branch names. |
| not checked yet | What nobody saw: tests not run, environments not tried, gaps found in the code. Plain lines, not checkboxes, and not tasks. |
| next_action | One concrete first step starting with a verb. |
| requester / assignee | From the words ("asked by", "with <person name>", "for QA"). Assignee defaults to the store owner. People names exactly as typed. |
| blocked_by / waiting_on | "after X", "needs Y first" -> `blocked_by` (a task id when it exists, else the text). If the task cannot move now, status `blocked` with `waiting_on` (who or what) and a follow-up `remind` date. |
| ref | Ticket numbers, PR numbers, commit hashes, URLs. |
| feature built in several units | Work already built from several tickets or units: one parent task named for what was integrated (`Integrate <system> with <new service>`), plus one done sub task per unit. The parent stays `review` until the owner confirms its outcome (status-rules.md). Each Outcome says in one sentence what the system does now. |
| tags | Systems, modules, customers (for example `acme`, `pricing`, `reports`). Not the type. Add INBOX_TAG when the task came from ingest. |
| sub tasks | Propose sub tasks when the work has 3 or more distinct steps or needs more than 2 days. Create them after the user agrees. |

## Process
1. **Extract** the facts present in the input and, for development work, in git history.
2. **Infer** the missing fields with the rubric. Keep a short reason for each.
3. **Check duplicates**: read BOARD.md for the same title, the same `ref`, or the same system and action. If found, point to it and ask whether to update instead of creating.
4. **Create** the task by the mutation procedure in core.md.
5. **Reply** with the sync receipt (sync.md) and a short table of the final values. Mark inferred ones `*`. End with "still open: ..." when something stayed empty.

Always show the Draft first (core.md). After the write, reply with the sync receipt (sync.md) and a short table of the final values.

## Note intake (wiki page from raw input)
- Write the page by writing.md with the front matter below, so Obsidian can filter and link it.
- Pull out **Key facts** (verbatim values) and **Action items**. Each action item goes through task intake above.
- Every page also gets: an entry in the project hub `<slug>-notes` (tpl-project.md), a `## Tasks` section, and `notes:` set on each task it creates or explains. Chain and quality bar: lifecycle.md.
- A note is professional when a stranger can act on it: why it matters, what happened, what was decided, what is open, who owns it, by when.

Wiki page front matter:
```
---
type: note              # note | requirement | issue | dev-note | decision | meeting | incident | idea | howto | reference | hub
project: "[[<project id>]]"
tags: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: <R-id or file name>
status: draft           # draft | reviewed
---
```

## Grooming (`task groom`)
Run when the user asks to clean up, or before a weekly review.
1. Read BOARD.md. Select open tasks missing any of: `type`, `due`, `estimate`, `next_action`, a real Purpose.
2. Read only those task files. Propose values with the rubric in one table (id, field, proposed value, reason).
3. Apply after the user approves, per task: update fields, set `updated`, add the Progress log line `groom: <fields> (op=...)`, then follow the mutation procedure.
4. Never change `status`, `started_at`, `done_at`, or existing non-empty values without asking.

A parent task of several units lists its sub task Not-checked lines under its own Not checked yet, or says `see sub tasks`.

## Example
The table is the content of the task file. The chat Draft stays short (core.md, Draft first).
User types: `fix customer-info missing savings account urgent by friday`, today is Wednesday 2026-10-01.

| Field | Value |
|---|---|
| title | Fix customer-info missing savings account |
| type | bug |
| priority | high* (user said urgent, due in 2 days) |
| due | 2026-10-03 (Friday) |
| estimate | 4h* |
| purpose | customer-info response omits the savings account. Return it so tellers see the full account list. |
| what happened | Reported as urgent by the user. (inferred) priority high: urgent + due within 3 days. (inferred) estimate 4h: one endpoint fix plus tests. Environment: not stated. |
| not checked yet | fix verified in UAT; unit test for an affected customer not run yet |
| next_action | Reproduce with a customer that has a savings account and compare the response |
| assignee | store owner |

Still open: requester, ref (no ticket number given). Priority is high, so the table is shown for one confirmation before creating.
