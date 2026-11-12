# Development lifecycle: what gets recorded, where, and how it links

Goal: for every project, a manager or a new developer can answer "what was asked, what went wrong, what was built, who verified it, where is the proof" from the store alone, in a few clicks, without asking the developer.

## The chain
Every stage has one record type and one command. Each record links to the one before it.

| Stage | Record | Command | Must contain | Links to |
|---|---|---|---|---|
| 1. Requirement | wiki page `type: requirement` | `note requirement` (or `note <input>` that is a request) | who asked, why, scope, rules agreed, out of scope, acceptance criteria, source (ticket, document, version) | hub, tasks it creates |
| 2. Issue | wiki page `type: issue` | `note issue` (or `note <input>` that is a defect or log) | symptom, evidence (ids, codes, time), impact, cause, status open or resolved | hub, tasks, the requirement it breaks |
| 3. Plan | task (and sub tasks), placed as a roadmap step `N.M` when the project has a roadmap | `task add` (`--phase N`) | purpose, type, priority, estimate, next action, phase and step (Done when for roadmap steps) | requirement or issue page in `notes` |
| 4. Build | task Progress log | `dev log`, `task start`, `task log` | dated lines: decision, change, blocker | commit hashes in `ref` |
| 5. Development note | wiki page `type: dev-note` | `note done` | the short layout of dev-note.md: why it matters, two short paragraphs, task links, source. The task holds period, change map, Not checked yet | task, hub, raw evidence |
| 6. Verify | task `review` or a verification task | `task review`, `task add` | the check a person ran and its result | dev note |
| 7. Done | task `done` with `outcome` | `task done` | one-line outcome with proof, `done_at` | `ref`, `notes` |
| 8. Report | project Summary block, digest | `report week --for manager` | delivered, needs attention, progress | hub, tasks |

## Rules that keep the chain whole
1. **No orphan page.** Every wiki page has `project:` in front matter, appears once in its project hub, and lists its tasks in a `## Tasks` section.
2. **No task without a trail.** A task that came from a requirement or an issue has that page in `notes`. A task that produced a dev note has the dev note in `notes`.
3. **No done without an outcome.** `task done` needs `outcome`: one line saying what was delivered and the proof (tests, commit, environment). No outcome: E-OUTCOME-REQUIRED.
4. **Nothing unchecked is hidden.** What nobody checked is written under "Not checked yet" in the task, in plain words. It is not ticked, and it does not become a task unless the owner says so.
5. **Follow-ups are lines first.** An open question or follow-up is a line in the task. It becomes a task only after the owner confirms the Draft. The page links the task when one exists.
6. **Facts only.** Test results, versions, dates and ids come from this session or the input. Missing facts are `(unknown)`. Unverified work says `Not verified:`.
7. **Redact.** Secrets never reach a file (core.md, Secrets).
8. **Same words everywhere.** One name per system, endpoint, project and feature across hub, page, task and commit.
9. **Every delivery has a task.** A project never lists a delivery that no task backs (sync.md).

## Quality bar (check before telling the user "noted")
A note or task scores 10 of 10 when all of these are true. Fix the gaps first, or list them under "still open".
1. Why it matters is in the first line.
2. Every number, id, code and date matches the source, and older pages that the new fact contradicts carry a Superseded callout.
3. Fact, decision and open question are separated.
4. Owner and date exist for every follow-up.
5. The page links the project hub, the tasks, and the source.
6. The hub lists the page. The task lists the page in `notes`. (Items 5 and 6 are about a wiki page: a task-only write has no page and counts them as held.)
7. Verification states what ran and what did not.
8. A stranger can act on it without asking the author.
9. No secret, no raw dump, no invented value.
10. The four places agree and the sync receipt was printed (sync.md); the op id is in log.md and the commit.

## Reading order for a manager
Project page (Summary, then Open table) -> hub `<slug>-notes` -> the dev note or requirement -> the task file.

## Daily habit (live recording, not after the fact)
A past review found work noted only after it ended: tasks created and done in one minute, `doing` tasks with no log, no requirement page, delay never recorded. Prompt the user at these moments:
1. New request: `note requirement` and `task add` the same day, before coding. Missing facts stay `(unknown)`.
2. Start: `task start`. Each working day: one `task log` line saying what is done, what is left, next step.
3. Delay: `task block` with reason and `--waiting`, or `task edit --due` with the reason. A `doing` task with no Progress log line for STALE_DAYS is stale: ask for a log line, never invent one.
4. Finish: `note done` on the day work ends, with `outcome` and proof.
5. Extra work: a task the same day, linked to the finished task.
Backfill: when work was done before it was noted, create the task from git history, take dates from commits, write `(unknown)` for tests not seen, and say in What happened that it is a backfill.
