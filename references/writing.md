# Professional note writing

Applies to every wiki page, task title, task Goal, and digest the skill writes.
The raw file is never changed. The polished version goes in the wiki and the task. The user keeps both.

## Rules
1. Keep every fact. Ids, numbers, names, dates, error text, commit hashes and URLs are copied exactly. Never round or translate them.
2. Never invent. If the input does not say it, do not write it. Mark an inference as `(inferred)` and a missing fact as `(unknown)`.
3. Separate fact from opinion: what happened, what was decided, what is still open.
4. Plain, short sentences. Active voice. One idea per sentence. No filler, no slang, no first-person chatter.
5. Language: follow NOTE_LANGUAGE in config.md. Technical terms, code, API names and error strings stay in English.
6. Same name for the same thing on every page and task (system, endpoint, project). Use the name already in the wiki.
7. Each note says why it matters in its first line.
8. A new fact that replaces a statement on an older page: add under that page's first line `> [!warning] Superseded YYYY-MM-DD` with the old statement, the new one, and the page that proves it. Never delete the old text. Run this in the same write as the new page.
10. **Evidence.** A fact comes from the real code, git history, a result actually seen, or the owner's words in the conversation. A product, class, method or table name is allowed when it appears in one of those, and the real code is read before naming it. A name found nowhere is not written.
9. No machine-speed detail in notes (minutes of work, time of day, line counts of generated files). Dates and commit hashes stay.

## Human voice
A note reads like the owner telling a teammate what happened, not like a generated report.
- First person plural or plain past tense: "We added...", "I found...". No "this document describes".
- Plain verbs. Cut: enables, leverages, robust, seamless, ensures, comprehensive, crucial, streamline, ensure, utilize.
- No tables inside notes (tables belong to BOARD). No bold except one real decision. No emoji.
- No heading that has nothing true under it. Do not fill a template section to look complete.
- Concrete over general: a file, a method, a number, a date. "Overwrite on every login", not "improves reliability".
- Say what went wrong, what surprised you, and what nobody knows yet.
- Mix short and long sentences. No closing paragraph that repeats the page.
- Short beats complete: say what we integrated or changed, what it does now, and what is unchecked, in the fewest true sentences. A task Outcome is one sentence. A dev note page is a first line, two short paragraphs, task links and source.
- Language: NOTE_LANGUAGE (config.md), now English. Names, ids and error text stay exact.

## Wiki page layout
Start with the front matter from intake.md (type, project, tags, created, updated, source, status), then (a page about one roadmap step names it in the title and first line: `# Form F1 integration with Partner UAT` and `> Step 8.11 of [[<slug>-roadmap]]: ...`):
```
# <Topic: noun phrase>
> <one line: why this matters>

## Summary
<3 to 5 lines>

## Details
<facts, bullets, dated>

## Decisions
- YYYY-MM-DD <decision> because <reason>

## Open questions
- <question> (owner: <who>)

## Tasks
- [[T-0001]] <title>

## Source
R-id, date, type (link the raw only when it is .md)
```
The `Tasks` section links every task created from the note, so Obsidian shows the connection. Name project notes `<slug>-notes`, never the bare slug.
Omit empty sections. Append to an existing page instead of creating a near duplicate.

## Requirement page (`type: requirement`)
```
# <Feature or change: noun phrase>
> <one line: what is asked and why it matters>

## Request
- Asked by: <person, team or ticket> on YYYY-MM-DD
- Source: <ticket, document name and version, R-id>

## Scope
- In: <what is included>
- Out: <what is not included>

## Rules agreed
- <rule, with the reason and who agreed, YYYY-MM-DD>

## Acceptance criteria
- [ ] <check a person can verify>

## Open questions
- <question> (owner: <who>)

## Tasks
- [[T-0001]] <title>

## Source
R-id, date, type
```
## Issue page (`type: issue`)
```
# <Symptom: noun phrase>
> <one line: what broke and who it affects>

## Symptom
<what was seen, when, in which environment>

## Evidence
- <ids, codes, timestamps, log tag, route. Copied exactly. Secrets redacted>

## Impact
<users, money, data, severity>

## Cause
<known cause, or "(unknown)". Separate confirmed from suspected>

## Fix and status
- Status: open | resolved
- <fix or workaround, commit, date>

## Tasks
- [[T-0001]] <title>

## Source
R-id, date, type
```
A resolved issue links the dev note that fixed it. A dev note that fixes an issue links the issue page.

## Task wording
- Title: verb + object + system, up to TITLE_MAX_CHARS. Example: `Re-apply Acme fee after pricing mapping fix`. In a project with a roadmap, start with the step number: `4.2 Design the submission tables in Oracle`, `6.3.1 Check form F1 Balance against PDF 3.1 and V3`, `8.11 Integrate form F1 Balance with Partner UAT end to end`.
- Write as a development team works: one unit per task, plain action words (design, build, integrate, check, test, deploy). Leave out machine-speed details (time of day, line counts of generated files); keep dates and commit hashes.
- Purpose: one line, why it exists.
- Not checked yet: what nobody saw (tests, environments, gaps), as plain lines.
- `next_action`: one concrete step, starts with a verb.
- Timeline line: date and one plain sentence of what happened.

## Check before write
- Compare numbers, ids and names against the raw. Any mismatch: fix the note.
- Any secret: E-SECRET path from core.md.
- If the raw is too vague to write a professional note (no subject, no action), keep the raw only, write no wiki page, and ask one question.
