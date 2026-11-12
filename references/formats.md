# Raw formats

How `note add` stores a raw input and how `note ingest` reads it.
Secret scan runs first for every type (see core.md, Secrets).

## Store rules
- Path: `<store>/raw/R-YYYYMMDD-NNN-<slug>.<ext>`. NNN = next number for that day. Slug = 3-5 words, lowercase, `[a-z0-9-]`.
- Hash: `shasum -a 256 <file>` of the redacted content. Same hash already in INDEX.md: return that id, write nothing.
- Never edit a raw file after capture. A correction is a new raw file.
- Text input pasted in chat is saved as `.md` (or `.json` if it parses as JSON).
- Large input: if over LARGE_FILE_MB (config.md), read head 200 lines, tail 50 lines and a sample. Never load the whole file into context. Say that it was sampled.
- Encoding: UTF-8. If decoding fails, store as-is and mark type `binary`.

## raw/INDEX.md
One table. One row per raw. Created with this header if missing:

```
| id | file | type | project | sha256 | status | note |
|---|---|---|---|---|---|---|
```
- `status`: new, proposed, ingested, failed, skipped.
- `note`: failure reason, skip reason, or `redacted: <type> x<count>`. Empty when there is none.
- `sha256`: first 12 characters.

## Types

| Type | Detect | Stored as | What ingest extracts |
|---|---|---|---|
| text | `.txt`, `.md`, plain paste | `.md` | Decisions, action items (verbs like "ต้อง", "todo", "ask", "retest"), names of systems, dates |
| json | parses as JSON | `.json`, unchanged except redaction | Top-level keys, record count, fields named status / error / code / message / id, min and max of date fields. Never paste the whole JSON into wiki. |
| log | most lines start with a timestamp | `.log` | Time range, count by level, first and last ERROR with stack top line, correlation or transaction ids (up to 10) |
| csv | header row, consistent delimiter | `.csv` | Header, row count, 3 sample rows with sensitive columns masked |
| redmine | `redmine#<id>` or ticket URL | `.json` | Subject, status, assignee, due date, last 3 journal notes, attachment names. Fetch with `redmine_mcp` read call. Never write back. |
| issue | GitHub issue URL or `gh#owner/repo#n` | `.json` | Title, state, labels, assignee, last 3 comments. Fetch read-only with `gh issue view <n> --repo <owner/repo> --json title,state,labels,assignees,comments,body`. Never comment or close. If `gh` is missing or not logged in: E-INGEST-FAILED, tell the user to paste the issue text instead. |
| image | `.png .jpg .jpeg .gif .webp` | as-is | Cannot be read reliably. Store, write a stub note, mark `proposed`, ask the user for a one-line description. |
| pdf | `.pdf` | as-is | Read text when possible. If the file is scanned or unreadable: treat like image. |
| binary | anything else | as-is | Store and index only. Status `skipped`, note `unsupported type`. |

When the type is unclear, use `--type` if given. Otherwise ask once. Do not guess between json and log.

## Redaction by type
- text, log: replace each secret match with `[REDACTED:<type>]`.
- json: replace the value, keep the key. Key names that always count as secret: password, passwd, secret, token, authorization, api_key, apikey, pin, cvv, card_number, account_no, accountNumber.
- csv: replace the whole column when the header matches the list above.
- Report to the user: type and count per kind, and the rotate warning from core.md (Secrets). Never print the value.

## Ingest output for any type
1. One summary block: what it is, when, which project, 3 to 8 bullets. Write it by the rules in writing.md (professional wording, facts unchanged).
2. Wiki target: append to an existing page when the topic exists, else create a new page. Every page keeps one `[[link]]` at least and a `Source: R-id` line.
3. Task candidates: one line each: title, due (if said), ref (if any). Show the list. Create after confirm when more than CONFIRM_TASK_THRESHOLD. Created tasks get tag INBOX_TAG and `source: <R-id>`.
4. Write `log.md` line with op id. Set INDEX status `ingested`.

## Failure handling
Any failure after capture: set status `failed`, put the reason in `note`, tell the user, write no wiki page and no task (E-INGEST-FAILED). A later `note ingest <R-id>` retries from the start.
