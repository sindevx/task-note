# Example: `note done` for finished development (illustrative, hashes are placeholders)

User, from the project repository: "I finished T-0007, note it."

## What Claude does
1. Task T-0007 is `todo`, no `started_at`. Branch `feature/card-service` has 6 commits (`git log main..HEAD`). Claude shows the range and count, user agrees.
2. Dates proposed with their source: start `2026-09-26` (first commit `a1b2c3d`), end `2026-09-30` (last commit `e4f5a6b`). User confirms.
3. Evidence: `git log --format='%h %ad %s'` and `git diff --stat`. Claude reads only the two service classes it needs. It does not open `application-*.properties`. Test output from this session: `mvn test` ran 41 tests, 0 failures. Stored as raw `R-20261001-002`.
4. Page `wiki/card-service-integration.md` is written from the layout in dev-note.md:

```
# card service integration
> Teller can now call the card service for balance checks, removing the manual lookup.

## Period
- Planned: none
- Actual: 2026-09-26 to 2026-09-30, 4 days
- Task: [[T-0007]] | Ref: none

## Background
Tellers checked CardService balances by hand. Requested to remove the manual step.

## What changed
- Client: `CardServiceClient` (new) calls the CardService balance endpoint with a timeout and one retry.
- Service: `BalanceService` uses the client when the account type is CardService.
- Config: new property keys for the CardService base URL (values not recorded here).

## How it works
1. `BalanceService` detects an CardService account.
2. `CardServiceClient` calls the endpoint, maps the response, returns the balance.
3. On timeout the call is retried once, then the error is returned to the caller.
Decision: retry once only, because a second retry doubles teller wait time.

## Verification
- `mvn test` -> 41 tests, 0 failures (run in this session).
- Not verified: call against the real CardService UAT endpoint.

## Impact and risk
Needs the new CardService property keys in every environment before deploy. Rollback: revert the 6 commits.

## Follow-ups
- Run UAT call against the card service (owner: alex)

## Source
Commits: a1b2c3d..e4f5a6b. Raw: R-20261001-002.
```
5. Task update by hand (core.md): T-0007 `todo -> doing` with `started_at: 2026-09-26`, Progress log line `log: dev note [[card-service-integration]]`, then `doing -> done` with `done_at: 2026-09-30`, summary "CardService balance check integrated, 41 unit tests pass", "Done when" items ticked. Raw `R-20261001-002` set to `ingested`. BOARD rebuilt, one commit `tn: note done T-0007 op=...`.
6. Reply: page path, period `2026-09-26 to 2026-09-30 (4 days)`, T-0007 `done`, unknown: UAT call, proposed follow-up task "Run UAT call against CardService" (added only after approval).
