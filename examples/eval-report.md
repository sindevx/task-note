# Eval run report (2026-11-12)

All 33 cases in `evals.md` were run by separate Claude runner sessions, each in its own scratch store, with no network and no Redmine calls. Runners followed the skill files literally and graded each case against its Expected column.

## Round 1 (first run of all 33)
23 pass, 9 fail, 1 partial (#33). Every failure came from a defect in a skill file or a stale Expected text, not from the runner. About 60 defects were reported and fixed: schema 1 "Done when" leftovers, contradictory rules (verification tasks, Superseded callouts), missing rules (backfill, 422 handling, parent estimate), wrong eval expectations (#15, #21, #22, #30), and a broken evals table.

## Rounds 2 to 4 (re-run after fixes)
| Evals | Last result | How it was run |
|---|---|---|
| 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 23, 25, 26, 28, 29, 31 | PASS | Live in scratch stores (store files, git commits, YAML parsed) |
| 13, 21, 22, 30 | PASS | Static: base file extracted from `tpl-project.md` and checked line by line. Not rendered in Obsidian |
| 24 | PASS | Live, with the Timeline view checked statically |
| 27 | PASS | Static: task text checked against `writing.md` |
| 32, 33 | PASS | Mocked: Redmine review stage only, no Redmine calls |

## Limits
- A few runs treated the owner's "ok" as assumed. The Draft text was shown for some cases only.
- Obsidian rendering (#13, #21, #24, #30) was not checked.
- After the last round, small wording fixes were applied that were not re-run (listed in the git history).
- Runner sessions are not a human reader. Run the evals by hand after any change to a reference file.
