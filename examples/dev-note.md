# Example: `note done` for finished development (illustrative, hashes are placeholders)

User, from the project repository: "I finished T-0007, note it."

## What Claude does
1. Task T-0007 is `todo`, no `started_at`. Branch `feature/card-service` has 6 commits (`git log main..HEAD`). Claude shows the range and count, user agrees.
2. Dates proposed with their source: start `2026-09-26` (first commit `a1b2c3d`), end `2026-09-30` (last commit `e4f5a6b`). User confirms.
3. Evidence: `git log --format='%h %ad %s'` and `git diff --stat`. Claude reads only the two service classes it needs. It does not open `application-*.properties`. Test output from this session: `mvn test` ran 41 tests, 0 failures. Stored as raw `R-20261001-002`.
4. Page `wiki/card-service-integration.md` is written in the short layout of dev-note.md. The full story (change map by layer, period, Not checked yet) lives in the task:

```
# Card service integration
> Tellers can now check a balance through the card service, so the manual lookup is gone. Full story: [[T-0007]]

We added `CardServiceClient`, which calls the card service balance endpoint with a timeout and one retry. `BalanceService` uses it when the account type is a card account. We retry once only, because a second retry doubles the teller wait time.

`mvn test` ran 41 tests with 0 failures in this session. The call against the real UAT endpoint was not run. The new base URL property key must exist in every environment before deploy; rollback is a revert of the 6 commits.

## Tasks
- [[T-0007]] Integrate the card service with balance checks

## Source
Commits: a1b2c3d..e4f5a6b. Raw: R-20261001-002.
```
5. Task update by hand (core.md): T-0007 `todo -> doing` with `started_at: 2026-09-26`, Progress log line `log: dev note [[card-service-integration]]`, then `doing -> done` with `done_at: 2026-09-30`, summary "CardService balance check integrated, 41 unit tests pass", Not checked yet lines written (UAT call). Raw `R-20261001-002` set to `ingested`. BOARD rebuilt, one commit `tn: note done T-0007 op=...`.
6. Reply: page path, period `2026-09-26 to 2026-09-30 (4 days)`, T-0007 `done`, unknown: UAT call, proposed follow-up task "Run UAT call against CardService" (added only after approval).
