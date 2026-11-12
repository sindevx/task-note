# Example: `note <json>` from the teller-service directory

Input (pasted by the user):
```
note {"orderId":"A123","status":"FAILED","error":"pricing mapping timeout","token":"abc123secret"}
```

## What happens
1. Type = json (parses). Project = `teller-service` (directory name matches `todo/projects/teller-service.md`).
2. Secret scan hits key `token`. Value replaced. The original is never written.
3. Raw saved as `raw/R-20261001-001-pricing-mapping-timeout.json`:
   ```
   {"orderId":"A123","status":"FAILED","error":"pricing mapping timeout","token":"[REDACTED:token]"}
   ```
4. `raw/INDEX.md` row: `| R-20261001-001 | R-20261001-001-pricing-mapping-timeout.json | json | teller-service | 3f9a1c0b7d42 | ingested | redacted: token x1 |`
5. Wiki page `wiki/pricing-mapping-timeout.md` (layout in writing.md): summary says order `A123` failed with `pricing mapping timeout`. Facts copied exactly. Section `Tasks` links `[[T-0007]]`. Source line names `R-20261001-001` as text (json is not linkable).
6. One task created, below CONFIRM_TASK_THRESHOLD so no confirmation:
   ```
   id: T-0007
   title: Investigate pricing mapping timeout for order A123
   project: "[[teller-service]]"
   status: todo
   tags: [inbox]
   source: R-20261001-001
   ```
7. `log.md` line, one commit `tn: note R-20261001-001 T-0007 op=OP-20261001-0900-a1`.

## Reply (brief)
```
R-20261001-001 (json) -> wiki/pricing-mapping-timeout.md
Created T-0007 [todo, inbox]
Redacted: token x1 (value is already in this session history; rotate it if real)
op=OP-20261001-0900-a1
```
