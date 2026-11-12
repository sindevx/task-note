# Active checks (read before every write command)

Rules that earlier mistakes taught. Max 10 lines. The lesson log and personal preferences live in `local.md` (feedback.md says how it is written).

- Every inferred value (priority, dates, estimate, type) is marked as inferred in the reply table. `environment` is never inferred: only the owner's words set it, and a commit on a feature branch is not an environment.
- Every number, id, name and date in a note matches the raw. Mismatch: fix the note, not the raw.
- Reply table shows the final values and the op id. No raw content.
- New fact contradicts an older page: Superseded callout on the older page in the same write.
- A project has phases and steps only when the owner ran `project roadmap` (roadmap.md). Never push one on a project by task count.
- Work from git: read `git show <hash>` and the real code first. A class, method, table or product named in a task or note must appear in the code, the git history, a result seen, or the owner's words.
- A hand edit of store files is not a write. Run the full mutation procedure: lock, op id, raw evidence, hub, BOARD, Summary, log.md, one `tn:` commit.
- Show the Draft first, create no task on your own, and print the sync receipt of the four places.
- Front matter must parse as YAML: quote text with `: `, quote `blocked_by` items. After every write, parse the touched files.
- Do not tick a Done-when item that was not seen in this session. Split it into a verification task (lifecycle.md rule 4). A Redmine push is review, then confirm, then push, then read back (cmd-task.md).
