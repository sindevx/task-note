# Development note (`note done`)

Use when the user says development is finished and asks for a note ("note my work", "I finished T-0007, note it", จดงานที่ทำเสร็จ). Run from the project repository.
The note explains the work in full: why, what, how, proof, risk, dates. It is not a copy of what the user typed. Writing rules: writing.md.

## 1. Pin down the work
1. Task: use the given id, else `list --status doing` and match by branch name or commit subjects. Ambiguous: ask. Never guess. No match (no id, no doing task): create the task by Draft (intake.md) with status todo, then start it (step 4).
2. Range of commits, first match wins:
   - the user names a range, branch or commits;
   - the task has `started_at`: `git log --since=<started_at> --no-merges` on the current branch;
   - else ask: "which commits belong to this work?".
   Show the range and the commit count. Continue only after the user agrees. Cap the list at DEV_NOTE_MAX_COMMITS.
3. Dates:
   - start = author date of the first commit in the range, or the task `started_at` when it exists;
   - end = author date of the last commit, or today when the user says the work ends today.
   Show both, with their source, and let the user correct them.

## 2. Collect evidence (read only, never paste raw diffs)
- `git log --format='%h %ad %s' --date=short <range>` and `git diff --stat <range>`.
- Read the real code of every layer the change touches (the current files, not only the diff) and say so. Read the dev session itself when it exists (the transcript in `~/.claude/projects/...`, used only when its branch or date matches the task; otherwise use the owner's words) for the purpose and the decisions, and put them in the Draft for the owner to confirm: a transcript is never copied in as fact. No transcript: use the owner's words in this conversation and say so in the Draft. A code comment is not evidence: confirm the behaviour in the code body and name a gap as Not done.
- Read only the files needed to explain the design. Do not read `.env`, `*.properties`, `*.yml`, `*.yaml` or key files (the user's permission rules deny them). Name such files in the note without their content.
- Tests: use results shown in this session. Never claim a test passed without output. Otherwise write `(unknown)` and list the command the user should run.
- Redmine or issue numbers from commits or the branch name go in `ref`.
- Store the evidence as a raw file so the note has a source: write the log and stat summary to `raw/R-YYYYMMDD-NNN-dev-<task>.md` by the store rules in formats.md (redact secrets first, add the INDEX row).

## 3. Write the page `wiki/<topic>.md`
Name: topic in 3 to 5 words, never the project slug or a task id. Roadmap step: name the unit and the action, for example `form-f1-partner-uat-integration` with title `# Form F1 integration with Partner UAT`. After writing, update the step's tracker row and counts in the roadmap page. Layout:

```
# <Topic>
> <one line: what changed and why it matters. Full story: [[T-0007]]>

<two short paragraphs: what we did, the decision and what it costs, what we found in the real code>

## Tasks
- [[T-0007]] <title>

## Source
Commits: <hash list>. Raw: <R-id>.
```
The story, the change map by layer and the Not checked yet list live in the task (tpl-task.md). The page is the short version for someone browsing the wiki.
Omit a section only when it has nothing true to say. Never fill a section with guesses. Mark gaps `(unknown)`.

## 4. Update the task (by hand, mutation procedure in core.md)
1. Task still `todo`: set `status: doing` and `started_at` to the real start date, with Progress log line `todo -> doing: dev started (dated <date>) (op=...)`.
2. Add a Progress log line `log: dev note [[<topic>]]` so the task links to the page.
3. When the user confirms the work is finished (the words `note done` are the owner's finish statement; ask once only when the request gives no finish claim): set `outcome` (one line: what was delivered and the proof), set `notes` to include the dev note page and any requirement or issue page, set `ref` to `commit#<hash>`. Then set `status: done`, `done_at` to the real end date (never before `started_at`, never in the future), write "Not checked yet" in the task from what was really seen (tests run, environments tried, gaps in the code), and add the line `doing -> done: <outcome>`. The task may close with those lines listed.
4. Follow-ups are lines under "Not checked yet". Ask once whether the owner wants any of them as a task (core.md, Draft first). Create none on your own.
4b. Update the project hub `wiki/<slug>-notes.md`: add the dev note under Development notes with its tasks. Add the hub link and `## Tasks` section to the page.
5. Set the raw row in `raw/INDEX.md` to `ingested`. Rebuild BOARD and the project Summary block, append log.md, make one commit. Run the quality bar in lifecycle.md before the reply.

## 5. Reply
Page path, period (start to end, days), task status, what is `(unknown)`, and the follow-up tasks proposed. No diff text.
