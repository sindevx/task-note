# project, wiki, board, report, system commands
Core rules: core.md.

## project
| Command | Effect |
|---|---|
| `project add <slug> [--repo path]` | Create project file, the hub page `wiki/<slug>-notes.md`, `project-tasks.base` and `.obsidian/types.json` (body in tpl-project.md) if missing. Duplicate slug: refuse. |
| `project show <slug>` / `project status <slug>` | Counts by status, overdue, blocked. Read only. |
| `project roadmap <slug> [--from-git]` | Build or refresh the roadmap: phase tasks, steps, reparent existing tasks, backfill from git, roadmap page (roadmap.md). Shows the mapping table once before writing. |
| `project archive <slug>` | Set status done. Refuse if open tasks exist. |

## wiki, board, report, system
| Command | Effect |
|---|---|
| `wiki lint` | Report only, fix nothing: duplicate pages, broken links, pages missing from index, tasks open over OPEN_TOO_LONG_DAYS, tasks without ref, blocked tasks without `waiting_on`, wiki pages missing from their project hub, wiki pages with no `project:`, done tasks without `outcome`, done tasks with an unticked Done-when item, tasks whose `notes` link is broken, follow-up lines in a wiki page that have no task. |
| `wiki index` | Rebuild `wiki/index.md`. |
| `wiki search <q>` | Search wiki and tasks. Show `file:line`. |
| `board rebuild` | Rebuild `todo/BOARD.md`, every project Summary block, and the `tn:roadmap` block of every roadmap page from task files. Task files are the truth. |
| `report week\|month [--project] [--for manager]` | Summarize from Progress logs: done, open, blocked, slipped (`done_at` after `due`). No secrets. |
| `report kpi [--project] [--since 30d]` | KPI per roadmap.md: progress per phase, throughput, on-time rate, estimate accuracy, blocked time, stale, late defects, open effort. Prints `not measurable: <reason>` instead of a number when the data is not valid. Read only. |
| `report digest [--project] [--save] [--notify]` | `task remaining` plus tasks done since the last saved digest. |
| `tn doctor` | Check: store exists, schema version, duplicate ids, missing parents, BOARD and project Summary blocks match task files, every done task has `outcome`, every project has a hub, status changes in each Progress log follow the transition table, every commit and every log.md line carries the op id (older Progress log lines keep theirs), every `[[link]]` in front matter and BOARD points to an existing file, `.gitignore` lists `.tn.lock`, every project file has `schema`, lock state, count of open tasks with no `estimate` or no `next_action` per project (propose `task groom`), projects with more than 10 tasks and no roadmap (information only: a roadmap is opt-in, see roadmap.md), every Delivered row backed by a done task, Summary counts equal to the task files, every wiki page of a project listed in its hub and, when recent, in Recent notes, a task with no Purpose, a hub page without `type: hub`, uncommitted manual edits (status changed with no Progress log line, offer `tn save`), manual edits to notes or tasks since the last Log line date in local.md (implicit "not OK" signal, see feedback.md: report, then run its procedure). Print pass/fail per check. |
| `tn undo` | Revert last `tn:` commit with `git revert`. Show the commit, confirm first. Uncommitted changes in the store: E-DIRTY. |
| `tn save [message]` | Commit manual edits (for example edits made in Obsidian) that no command wrote. Show the file list first. Never stages `.tn.lock`. |
| `tn version` | Print `version` from the SKILL.md front matter and SCHEMA_VERSION from config.md. |
