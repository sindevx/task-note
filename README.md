# task-note

A [Claude Code](https://claude.com/claude-code) skill that keeps notes, tasks and project progress in one central markdown store. It works from any project directory and stays readable in Obsidian or any editor.

## What it does
- `note <anything>`: stores the raw input (secrets redacted), writes a clean wiki note, links it to a project.
- `task add / start / block / done`, `task remaining / next / today`: tasks and sub tasks with status rules and a BOARD view.
- `dev log`, `project roadmap`, `report kpi`: ties daily development work to 11 standard phases and shows progress.
- `task push / pull`: optional Redmine sync with a review, confirm, push, read-back gate.
- A feedback loop: say "not OK" and the skill fixes the result, finds the cause, and patches its own rules.

## Safety rules built in
- Draft first: nothing is written until you say ok. No task is created on its own.
- Facts only from code, git, results seen, or your own words. Nothing is invented.
- Secrets are redacted before any write. Raw files are never edited.
- Every write is locked, atomic, logged with an op id, and committed locally. The store is never pushed for you.

## Install
```bash
git clone https://github.com/sindevx/task-note.git ~/.claude/skills/task-note
cp ~/.claude/skills/task-note/local.example.md ~/.claude/skills/task-note/local.md
mkdir -p ~/task-note-store && git -C ~/task-note-store init
```
Edit `local.md`: set `STORE_PATH`, timezone and, if you use Redmine, the Redmine map. `local.md` is git-ignored, so your lesson log and settings stay private.

## Layout
| Path | Purpose |
|---|---|
| `SKILL.md` | Entry point: which reference file to read for which request |
| `references/` | Rules, templates, commands, error codes, config values |
| `examples/` | Worked examples and `evals.md` (33 regression cases to run by hand after a change) |
| `tools/check.sh` | Consistency check: links, error codes, config names, no personal data |
| `local.example.md` | Shape of your private `local.md` |

## Develop
Run `tools/check.sh` before every commit. After changing a reference file, run the cases in `examples/evals.md` by hand.

## License
MIT
