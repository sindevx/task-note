# task commands
Core rules: core.md. Status rules: status-rules.md. Errors: errors.md.

## task
| Command | Effect | Refuse when |
|---|---|---|
| `task add <title> [--project] [--type T] [--priority P] [--start D] [--due D] [--estimate 4h\|2d] [--remind D] [--next "<text>"] [--tags a,b] [--requester X] [--assignee X] [--blocked-by X] [--ref redmine#id] [--notes "[[page]]"] [--parent T-id] [--goal ..] [--done-when ..]` | Create task, status todo. Always run intake.md first: the typed words are never the whole record. `D` = DATE_FORMAT. `--parent` makes a sub task. | E-NO-PROJECT, E-DEPTH, E-DUP, E-DATE-FORMAT, E-DATE-ORDER |
| `task add <title> --phase N` | Create step `N.M` under phase N (roadmap.md). Without `--phase`, the keyword map in roadmap.md picks the phase and the reply shows it. | E-NO-PROJECT, E-DUP |
| `dev log [T-id] <text>` | Developer log: find or create the step, move todo to doing, add new commit hashes to `ref`, write the log line, and a wiki page when the text holds a decision or finding (roadmap.md, `dev log`). | E-AMBIGUOUS (ask), task done or cancelled |
| `task rewrite <id>` | Draft the task again in the current template (Purpose, What happened, change map, Timeline, Not checked yet) from the old file, the real code and git. Show the Draft, write only after "ok". Old Timeline lines are kept word for word. | E-NOT-FOUND |
| `task groom [--project]` | Find open tasks with missing planning fields, propose values, apply after approval (intake.md, Grooming). | |
| `task show <id>` | All fields + last 5 log lines. | E-NOT-FOUND |
| `task start <id>` | todo or blocked -> doing. First start sets `started_at` to today. Later starts keep it. Blocked -> doing clears `waiting_on`. | E-BAD-TRANSITION, E-PARENT-STATUS |
| `task log <id> <text>` | Append log line, status unchanged. | task is done or cancelled |
| `task block <id> <reason> --waiting <who-or-what> [--remind D]` | -> blocked. Sets `waiting_on`. `--remind` sets a follow-up date. | E-REASON-REQUIRED, E-WAITING-REQUIRED, E-BAD-TRANSITION, E-PARENT-STATUS |
| `task unblock <id> [note]` | blocked -> doing. | E-BAD-TRANSITION, E-PARENT-STATUS |
| `task review <id>` | doing -> review. | E-BAD-TRANSITION, E-PARENT-STATUS |
| `task done <id> [--outcome "..."]` | review or doing -> done. Sets `done_at` to today. Needs `outcome`: take it from `--outcome`, else from the dev note, else ask. Write the same sentence on the `doing -> done:` Progress log line. What nobody checked goes under "Not checked yet" in the same task, and the task may close with them listed (lifecycle.md rule 4). Do not create tasks for them unless the owner says so. An old task with unticked boxes still follows the old rule. | E-OUTCOME-REQUIRED, E-SUB-OPEN, E-BAD-TRANSITION, E-CONFIRM-REQUIRED |
| `task reopen <id> <reason>` | done or cancelled -> doing. Clears `done_at`, keeps `started_at`. | E-REASON-REQUIRED |
| `task cancel <id> <reason>` | -> cancelled. | E-REASON-REQUIRED |
| `task edit <id> [--title] [--type] [--start] [--due] [--estimate] [--remind] [--next] [--waiting] [--blocked-by] [--requester] [--assignee] [--tags] [--ref] [--priority] [--outcome] [--notes]` | Edit metadata, log old -> new value of each changed field. | edit of id, status, project, `started_at`, `done_at` (auto fields); E-DATE-FORMAT, E-DATE-ORDER |
| `task confirm <id\|--all>` | Remove INBOX_TAG: the user accepts a task that ingest created. | E-NOT-FOUND |
| `task inbox` | List tasks with INBOX_TAG: id, title, source raw. Read only. | |
| `task move <id> --project <id>` | Move task and its sub tasks. Confirm first. | E-NOT-FOUND |
| `task list [--project] [--status] [--due-before] [--all]` | Default: not done, not cancelled, sorted by due (empty due last). | |
| `task tree <id>` | Task and sub tasks as a tree with status. | |
| `task today` | doing + blocked + due within TODAY_WINDOW_DAYS + overdue + `remind` reached. | |
| `task remaining [--project] [--save] [--notify]` | What is left, grouped: overdue, due soon (DUE_SOON_DAYS), doing, blocked (with `waiting_on`), stale (STALE_DAYS without log), no date, inbox. Starts with a counts line. `--save` writes a snapshot (tpl-board.md, Digest). `--notify` see config.md. | |
| `task next [--project]` | Suggest up to 3 tasks to work on now. Skip blocked and inbox. Order: overdue, priority, due, started. Show `next_action` for each. | |
| `task push <id> [--new]` | Create or update the Redmine issue with every field, estimate and spent time included (Push to Redmine below). Show the payload, confirm every time, read it back. | E-PUSH-INCOMPLETE, no ref without `--new` |
| `task pull <id>` | Compare the Redmine issue with the task and copy the differences after ok (Pull below). | no ref |

Idempotent: a command that would change nothing (for example `start` on a doing task) prints "no change" and writes nothing.

## Push to Redmine
Command: `task push <id> [--new]` creates the issue, `task push <id>` on a task with `ref: redmine#N` updates it, `task pull <id>` copies Redmine back (see Pull). Server, ids and names of your instance come from the Redmine map in `local.md` (shape: `local.example.md`). A value not in the map is looked up with GET before use. Never guess an id.

### Review, then confirm, then push
Create and push are never one step. Every Redmine write goes through three stages, in this order:
1. **Review (read-only).** Read Redmine only (lookups, `allowed_statuses`). Show the full payload as a table: every field in the field map below, its value, its source, `*` on inferred values, and the empty fields. Include every write the push will make: the issue, status, dates, estimate, done ratio, and each time entry. Write nothing to Redmine and run no POST or PUT.
2. **Confirm.** Stop and wait. Only a plain "confirm" (or "ok push") sent after the review counts. An earlier "create it", "status done" or "ok" does not count. The owner may edit any value; after an edit show the review again.
3. **Push, then read back.** Run only the calls shown in the review. Read the issue back, compare every field, and report any field that did not stick.
Any new write (status change, extra time entry, field edit) is a new review. A local `task add` or `task done` never pushes by itself.

### Field map: every field is filled before upload
| Redmine field | From the task | Rule |
|---|---|---|
| project_id | project | Look up with GET `/projects.json`. A support case goes to the support project named in the Redmine map. |
| tracker_id | `type` / tag | tag `support-case` -> Support; bug -> Bug; feature -> Feature; ops -> Infrastructure; investigation -> Spike; chore, test, release, docs -> Task. Show the pick, the owner may change it. |
| subject | `title` | Support case: `Support: <title>`, no double prefix. Roadmap prefix `N.M` is dropped. |
| description | Purpose, What happened, evidence | Textile. Support case: `h3. Problem`, `h3. Evidence`, `h3. Request`, `h3. Cause` ("Not confirmed" when unknown), `h3. Related`. No secrets. |
| priority_id | `priority` | low, normal, high by name. Urgent and Immediate only when the owner says so. |
| assigned_to_id | `assignee` | Name -> user id by GET `/users.json` or an earlier issue. Empty assignee is not allowed. |
| status_id | `status` | todo -> New; doing -> In Progress; blocked -> Feedback; review -> Resolved; done -> Done; cancelled -> Rejected. Names differ per server: use the map, then check `allowed_statuses` (Status limits). |
| start_date, due_date | `start`, `due` | Both required. Missing: ask the owner once. A backdated work day must be a working day (WORKDAYS) and the owner must have said it. |
| estimated_hours | `estimate` | Required. Hours, not days: 1d = 8h. See Estimate rule. |
| done_ratio | status | todo 0, doing 10-90 (owner says, else 50), blocked and review keep the last value, done 100. With sub tasks: done sub tasks / all sub tasks. |
| parent_issue_id | `parent` | Only when the parent also has a `ref`. Else ask. |
| custom_fields | tags | Required custom fields of the project (for example an `Applications` list): use `tags` that match an allowed value, else the default. If definitions cannot be listed (403), read them from an existing issue. Ask once when unsure, never guess. |
| is_private | - | false, unless the owner says private. |
| attachments | - | never, unless the owner asks (screenshots can hold customer data). |
| spent time | `spent` | POST `/time_entries.json` `{issue_id, hours, activity_id, spent_on, comments}`. Required before a done push. See Spent rule. |

### Estimate rule
- Unit is hours, steps of 0.25 (15 minutes). No minimum: a small task is 0.25h or 0.5h. One task = one deliverable up to 16h. Over 16h: split it into sub tasks and estimate each.
- Estimate the whole job the way one person would do it, with the checking and the hand-over included, not only the typing. Add the extra percentage in `local.md` for work that waits on access or approval (none by default).
- Size from evidence: look at lines changed, files touched and time gaps between commits. A task that copies an existing pattern is small. Subject and description of a done task are written as a developer note (action verb first: "Implement ...", "Fix ...", "Test ...").
- Starting sizes (inferred, shown with `*`, the owner agrees or changes). Only a fallback: calibrate from evidence first.

| Kind of work | Hours |
|---|---|
| One-line code fix or a constant | 0.25 - 0.5 |
| Read-only check or one query | 0.25 - 1 |
| Config or one-line data fix | 0.25 - 2 |
| Support case with investigation | 2 - 4 |
| Load or repair data for one customer | 1 - 2 per customer |
| Small code change with a test | 0.5 - 4 (by lines and rules) |
| New endpoint or integration unit | 2 - 16 (by lines and rules) |

- The estimate is written once at planning and not changed to match the spent time. When spent is more than 1.5 times the estimate, add one line under "Not checked yet" with the reason.
- Never invent it. No evidence and no owner words: the push is refused (E-PUSH-INCOMPLETE) and the owner is asked once, with a proposed value from the table.

### Spent rule
- `spent` is the owner's own number, as hours. Never guessed, and never written until the owner confirms it. Commit times and diff size may be shown as a suggestion marked `inferred from commits`; the owner confirms or changes it first.
- Sanity check: spent / estimate should be 0.5 to 1.5 on a done task. Outside that, ask once.
- Activity (id) by kind: research, support, bug fix, development, testing, documentation, deployment, database, meeting. Take the ids from the Redmine map.
- `spent_on` is the day the work was done, a working day, never in the future. Split the hours over days when the owner gave several days.
- A task with no `spent`: ask once. "Not tracked" is allowed only when the owner says so, then the push writes `Spent time not recorded` in a note on the issue.

### Push safety and order
- Never call `/users/current.json`: it prints the `api_key`. Take the user id from an issue (`author`, `assigned_to`) or `/users.json`. Never print a key.
- Order: create children (status is ignored on create), PUT each status, update the parent last, read back all issues.
- A parent with children gets its dates, done % and totals from Redmine. The review says so. Parent own estimate = 0 unless the owner says otherwise. Parent spent = story-level work only, never a copy of the task hours.
- Do not set Closed on a task the owner has not said is done (UAT, production). Do not close a parent with an open child without asking once.
- Title: action verb first, what it touches, one key rule, max about 100 characters. Description order: What I built, Rules and errors, Testing, Source. No secrets and no real account numbers.

### Gate before upload
All of these must be filled, or the push stops with `E-PUSH-INCOMPLETE <id>: <field list>. Use: task edit <id> --<field> ...`: project, tracker, subject, description, priority, assignee, status, start, due, estimate, done_ratio, required custom fields, and spent (for done). Print the payload as a table with the source of each value and mark inferred values with `*`.

### Status limits
Before a status change, GET `/issues/<id>.json?include=allowed_statuses`. Set only a status in that list. Roles differ: some cannot reach Closed or Rejected, and from Done the list may be empty. Say this before pushing Done. A cancelled task is pushed as a note, not as Rejected, when Rejected is not allowed. A create call ignores `status_id`, so set the status in a second PUT.

### Pull (`task pull <id>`)
GET the issue and compare status, assignee, start, due, estimate, spent (`spent_hours`) and done_ratio with the task. Show a diff table. After the owner's ok, copy Redmine values into the task fields (never `started_at` or `done_at`), add one Timeline line, and run the mutation procedure. Redmine description edits are shown, not copied.

### After the call
Read the issue back and compare every field with the payload. A field that did not stick is reported by name. Then write `ref: redmine#<id>`, set `estimate` and `spent` on the task, add one Timeline line, and update the four places (sync.md). Two cases with the same need stay two tickets and link each other under Related. Never write to Redmine without the confirmed payload.
