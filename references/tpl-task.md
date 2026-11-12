# Task and sub task templates

Index of templates: templates.md. Links rules: templates.md, Links.

## Task: `<store>/todo/tasks/T-0001.md`
Front matter is YAML. Put double quotes around every text value that has `: ` or starts with `[[` (title, outcome, next_action, waiting_on). Write `blocked_by` as a quoted list: `["[[T-0002]]", "[[T-0003]]"]`. An unquoted one breaks the YAML, and Obsidian then hides the whole task from every view.
```
---
schema: 2
id: T-0001
title: <short title>
project: "[[<project id>]]"
parent: ""             # "[[T-0001]]" for a sub task
phase:                 # roadmap phase number 1-11 (roadmap.md), or empty
step:                  # step number inside the phase (0 = the phase task itself), or empty
status: todo
priority: normal       # high | normal | low. Rubric: intake.md
type:                  # one of TASK_TYPES (config.md): what kind of work
kind:                  # code | investigation | ops | docs: what the delivery is
environment:           # dev | UAT | production: furthest place reached, as the owner says
environment_date:      # date it reached that place
tags: []               # systems, customers, modules, e.g. [acme, pricing]. Ingest adds INBOX_TAG
start:                 # planned start, or empty (not scheduled)
due:                   # planned end, or empty
estimate:              # e.g. 30m, 4h, 2d, 1w. Only when the owner gives or agrees to it
spent:                 # hours actually spent, the owner's own number. Needed for a Redmine push of a done task (cmd-task.md, Spent rule)
remind:                # date to be reminded, or empty
next_action:           # one line, starts with a verb: the first concrete step
waiting_on:            # who or what blocks it right now. Required when status is blocked
blocked_by:            # task id or text this task depends on, even when not blocked yet
requester:             # who asked for it (person, team or ticket owner)
assignee:              # who does it. Default: the store owner
started_at:            # auto: first move to doing. Never typed by hand
done_at:               # auto: move to done. Cleared by reopen
ref:                   # redmine#12345, commit#abc1234, or empty
outcome:               # one line: what was delivered and the proof. Required to move to done
notes: []              # wiki pages about this task: ["[[requirement-page]]", "[[dev-note-page]]"]
source: ""             # "[[raw file]]" when it is .md, else the R-id as text
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
## Purpose
<one line: why this exists>

## What happened
<short paragraphs in plain words: who asked, what was decided and why, what was done. Mark `(inferred)` values>

## What changed, by layer
<development only. One line per layer actually touched: Model, Service, Repository, DB, Controller or API, Config, Security and logs, Outside systems, Tests, Deploy. Also: Not done, and why>

## Timeline
- YYYY-MM-DD <plain sentence of what happened>

## Not checked yet
- <what nobody saw: tests, environments, gaps. Plain lines, not checkboxes>
```
`## Timeline` is what the other reference files call the Progress log. An older task keeps its old sections (`Goal`, `Context`, `Done when`, `Progress log`); it is rewritten only by `task rewrite`.
Every new task is filled by the intake rules in intake.md. Fields stay empty only when the input and the rules give no honest value.
Fields added after schema 2 (`phase`, `step`, `type`, `blocked_by`, `requester`, `assignee`, `outcome`, `notes`, `## Context`) are optional for old files, but required for every task moved to done (`outcome`) and for every task that has a wiki page (`notes`). A file without them stays valid.

## Sub task: `T-0001.1.md`
Same as task. `id: T-0001.1`, `parent: "[[T-0001]]"`.
