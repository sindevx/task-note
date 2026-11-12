# Example: parent task with sub tasks

```
task add Retest Acme fee --project teller-service --due 2026-10-10
task add Run Postman collection --parent T-0001
task add Notify QA --parent T-0001
task start T-0001.1
task start T-0001
```

| Step | Result |
|---|---|
| `task add` | `T-0001` todo |
| `task add --parent` x2 | `T-0001.1`, `T-0001.2` todo, parent `"[[T-0001]]"`. Parent stays todo |
| `task start T-0001.1` | sub doing, `started_at` set. Parent becomes doing (computed) |
| `task start T-0001` | refused: `E-PARENT-STATUS T-0001: status is computed from sub tasks. Use: task start <sub id>` |
| `task block T-0001.2 "waiting for UAT" --waiting "UAT team"` | sub blocked with `waiting_on`. Parent stays doing (a sub is doing) |
| `task done T-0001.1`, then `task cancel T-0001.2 "UAT dropped"` | parent: all active subs done, so review |
| `task done T-0001` | parent done, `done_at` set. A person confirms the whole job |
| `task done T-0001` before the subs are finished | refused: `E-SUB-OPEN T-0001: sub task T-0001.2 is not done or cancelled` |

Each change appends one Timeline line `- YYYY-MM-DD <old> -> <new>: <note>` (the op id lives in log.md and the commit), rebuilds BOARD and the project Tasks block, and makes one commit.
