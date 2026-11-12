# Feedback loop: learn from "not OK"

Goal: every time the user is unhappy with a note or task result, fix the result, find the cause in the skill, patch the skill, and check that the same defect is not already in the store. The skill gets better after each correction.
Standing permission: installing this skill grants the loop. The skill may edit its own `references/` files under the limits below. It never edits silently. The lesson Log lives in `local.md` (git-ignored, personal); a rule that helps every user is proposed as a pull request.

## Signals (act on any one)
Explicit: "not OK", "wrong", "redo", "too long", "you missed X", ไม่โอเค, ไม่ถูก, แก้ใหม่, ไม่ใช่แบบนี้, ยาวไป, ตกหล่น.
Issue found while working (no complaint needed): a Redmine call is rejected or ignored, a read-back differs from what was sent, a test or build fails, a number is sized wrong and corrected, the owner supplies a missing fact. Treat it like "not OK": same procedure.
Implicit: the user rewrites or pastes a corrected version; repeats the same request in other words; runs `tn undo`; the store has a commit or file edit not made by a `tn:` command on a note or task the skill wrote (`tn doctor` and `wiki lint` look for these, read only).

## Procedure (fixed order)
1. **Fix the user's work first.** Redo the result with the normal mutation procedure (core.md). Apply only the correction. If the correction is unclear, ask one question. Do not touch the skill before the user's work is right.
2. **Classify the cause.** Pick one class and its owner file:

| Class | Example | Owner file |
|---|---|---|
| Field value | wrong priority, date, estimate, type | intake.md |
| Wording | too long, vague, invented, wrong tone | writing.md |
| Layout | wrong section or template | writing.md, capture.md, tpl-*.md |
| Page type or duplicate | wrong `type:`, near duplicate page, topics mixed | capture.md |
| Project or link | wrong project, hub not updated, broken link | core.md, templates.md, tpl-project.md |
| Command or status | wrong transition, wrong command chosen | cmd-task.md, status-rules.md |
| Raw handling | bad parse, secret not redacted | formats.md, core.md |
| Dev note or chain | missing link between requirement, task, dev note | dev-note.md, lifecycle.md |
| Redmine push or release report | rejected status, wrong estimate or spent, padded hours, wrong tracker, missing field | cmd-task.md (Push to Redmine) |
| Cost | read too many files, long reply | SKILL.md token rules |
| Execution miss | the rule exists, it was not followed | lessons.md Active checks |
| Preference | user taste, not a general rule | local.md Preferences |

3. **Sweep (read only).** Search the store for the same defect in notes and tasks touched within BOARD_DONE_DAYS. List the ids. Ask once: "fix these N too?". Fix only after yes.
4. **Patch the skill.** Smallest edit in the owner file:
   - Change the existing rule if one covers it. Add a new line only if none does. Remove a line that contradicts the new one.
   - One rule, one line, with the reason. Numbers go to config.md, error codes to errors.md (single source of truth).
   - Never weaken Secrets, `raw/` immutability, no external writes, or the mutation procedure. Stricter is allowed.
   - A preference is not a rule. Keep it in local.md Preferences, not in the reference files.
5. **Log one line** in local.md Log: `L-NN | date | class | symptom | file | old -> new`. The old text is kept so the lesson can be reverted. Unless the class is Preference, also add one regression case to `examples/evals.md` (input, expected result) so the defect is checked next time.
6. **Escalate repeats.** Same class twice in the Log means the rule is too weak or hard to find. Move it to Active checks, or to SKILL.md Hard rules, and tell the user.
7. **Report in 3 lines:** what was fixed, the cause class, the skill change (file and the new line). Add: "say `revert L-NN` to undo the skill change". Revert means restore the old text from the Log, then log the revert.

## Before every reply that wrote something
Run writing.md Check before write, lifecycle.md Quality bar, and the Active checks in lessons.md. Fix the result before replying. This is how an Execution miss is prevented the second time.

## Housekeeping
- Active checks (lessons.md): at most 10 lines. Preferences (local.md): at most 10 lines.
- Log over 40 lines: merge repeated classes into one line, keep the newest date.
- Do not log a lesson for a one-off typo in the user's input.
