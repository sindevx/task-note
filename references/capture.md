# Capture everything: triage, find-before-create, page types

Goal: nothing the user wants to keep is lost, and every note ends up where a stranger can find it.
Order is always: capture first, polish second. Raw is cheap to store and impossible to recreate.

## Capture-first rules
1. Raw is stored before any question is asked. Secrets are redacted first (core.md).
2. Project unresolved: still store the raw, with project `unassigned` in raw/INDEX.md. Write no wiki page and no task. Ask once which project, then run `note ingest <R-id>`. (Exception to E-NO-PROJECT for `note` commands only.)
3. Input too vague to write a professional page: keep the raw, say what is missing in one line, ask one question.
4. One input can hold several topics (a meeting with two decisions and a bug). Write one page per topic, all with the same `Source: R-id`. Do not mix topics in one page.
5. Same hash as an existing raw: return that id, write nothing (formats.md).

## Triage: input shape -> page type
Pick by the first matching row. A keyword prefix typed by the user (`decision:`, `meeting:`, `idea:`, `howto:`, `ref:`, `incident:`) wins over guessing.
| Input looks like | `type:` | Task? |
|---|---|---|
| a request, ticket, "please add / change ..." | requirement | yes, plan tasks |
| an error, log, wrong behaviour, "X does not work" | issue | yes, fix task |
| production outage, customer impact, "post-mortem" | incident | yes, fix and prevent tasks |
| "we decided ... because ..." | decision | only for follow-up actions |
| attendees, agenda, minutes, "meeting with ..." | meeting | one task per action item |
| finished work, commits, "I built ..." | dev-note | via `note done` (dev-note.md) |
| a proposal or "what if ..." with no commitment | idea | no |
| steps, commands, "how to restart / deploy / test ..." | howto | no |
| a link, spec, contact, API doc, number to remember | reference | no |
| anything else | note | only if an action is clear |
A single structured event (one JSON record or log line) with no described symptom is a `note`. It becomes an `issue` only when the owner says what went wrong.
Page types are in the front matter of intake.md. Layouts below.

## Find before create
1. Search `wiki/` for the topic: file names, `# title`, `tags:`, system and endpoint names (`grep -il`). Search BOARD.md for related tasks.
2. Match found: append a dated section to that page (`## Update YYYY-MM-DD`), set `updated:`, keep one `Source` line per raw. Do not create a near duplicate. If the new fact contradicts the match, create the new page and add the Superseded callout to the match instead (writing.md rule 8), then run step 3 for the new page (hub, task links). Do not append.
3. No match: create the page, add it to the project hub once (tpl-project.md), link tasks both ways.
4. Name the page by topic as a noun phrase, lowercase with hyphens, never equal to a project slug or task id (templates.md, Links).

## Layouts for types that have no layout in writing.md
Front matter as in intake.md. Omit an empty section. First line under the title says why it matters.

**decision**
```
# <Decision: noun phrase>
> <why this decision matters>
## Decision
<one sentence: what was decided>
## Context
<problem, constraints, who decided, date>
## Options considered
- <option>: <pro and con>
## Consequences
<what changes, risks, follow-ups>
## Tasks
## Source
```

**meeting**
```
# <Meeting: topic, YYYY-MM-DD>
> <purpose and outcome in one line>
## Attendees
## Discussed
## Decisions
- YYYY-MM-DD <decision> because <reason>
## Action items
- <verb + object> (owner: <who>, due: <date or unknown>) -> [[T-id]]
## Open questions
## Source
```

**incident**
```
# <Incident: symptom, YYYY-MM-DD>
> <impact in one line: who, what, how long>
## Timeline
- HH:MM <event> (timezone TIMEZONE)
## Impact
## Root cause
<(unknown) until proven. Never guess.>
## Fix and prevention
## Tasks
## Source
```

**idea**
```
# <Idea: noun phrase>
> <the problem it would solve>
## Idea
## Why it might work
## Risks and unknowns
## Next step to test it
## Source
```

**howto**
```
# <How to: verb + object>
> <when to use this>
## Before you start
<access, tools, environment>
## Steps
1. <command or action> (expected result)
## Check it worked
## If it fails
## Source
```
Steps are copied from the input exactly. A step the input did not give is `(unknown)`, never invented.

**reference**
```
# <Reference: name>
> <what it is and when to look at it>
## Key facts
<verbatim values: urls, ids, versions, contacts, limits>
## Notes
## Source
```
Contacts: names and roles only unless the user gives more. No secrets (core.md).

## After writing
Reply with the compact table (intake.md) and one line `Quality: N/10`, for a note and for a task alike. A raw-only write (no page, no task) gives `Quality: n/a`. N counts the lifecycle.md Quality bar items that hold. Items that fail are listed under "still open", or fixed first.
