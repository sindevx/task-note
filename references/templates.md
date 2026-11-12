# File templates

Status values and transitions: status-rules.md. Do not copy them here.
`schema: 2` on every project and task file. Schema 1 files stay valid (new fields are optional). `tn doctor` reports them.
Dates use DATE_FORMAT. Defaults and numbers: config.md.

## Links (so Obsidian shows backlinks and graph)
- Front matter links are quoted wiki links: `project: "[[teller-service]]"`, `parent: "[[T-0001]]"`, `source: "[[R-20261001-001-notes]]"`. Empty value: `""`.
- Reading: strip the quotes and `[[ ]]` to get the plain id or slug. Writing: always wrap.
- Link target = file name without `.md`. Task and project file names are unique ids, so plain `[[T-0001]]` and `[[teller-service]]` resolve.
- A wiki page must never be named exactly like a project slug or task id. Name project notes `<slug>-notes`.
- Link a raw file only when it is `.md`. For other raw types write the file name as plain text.

## Where each template lives
Load only the file the command needs.
| Template | File |
|---|---|
| Project file, Summary block, project hub | tpl-project.md |
| Task, sub task | tpl-task.md |
| BOARD.md, digest, log.md line | tpl-board.md |
| Wiki page layouts (note, requirement, issue, decision, meeting, incident, idea, howto, reference) | writing.md, capture.md |
