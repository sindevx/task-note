#!/usr/bin/env bash
# Checks the skill files stay consistent. Run from anywhere: tools/check.sh
# Exit 1 on the first group of problems found. No dependencies beyond bash, grep, sed.
cd "$(dirname "$0")/.." || exit 1
fail=0
problem() { echo "PROBLEM: $1"; fail=1; }

# 1. front matter has name and description, and name matches the folder
[ "$(sed -n 's/^name: //p' SKILL.md | head -1)" = "$(basename "$PWD")" ] || [ "$(sed -n 's/^name: //p' SKILL.md | head -1)" = "task-note" ] || problem "SKILL.md name is not task-note"
grep -q '^description: ' SKILL.md || problem "SKILL.md has no description"

# 2. every .md file named in SKILL.md exists
for file in $(grep -o '`[a-z-]*\.md`' SKILL.md | tr -d '`' | sort -u); do
  [ -e "references/$file" ] || [ -e "examples/$file" ] || [ -e "$file" ] || [ "$file" = "log.md" ] || problem "SKILL.md names $file but it does not exist"
done

# 3. every error code used anywhere is defined in errors.md
for code in $(grep -rhoE 'E-[A-Z]+(-[A-Z]+)*' SKILL.md references examples | sort -u); do
  grep -q "| $code |" references/errors.md || problem "error code $code is used but not defined in errors.md"
done

# 4. every config name used anywhere is defined in config.md
for name in $(grep -rhoE '\b[A-Z]{2,}(_[A-Z]+)+\b' SKILL.md references examples | sort -u); do
  grep -q "| $name |" references/config.md || echo "NOTE: $name is not a config.md row (fine if it is a placeholder)"
done

# 5. nothing personal is shipped
git ls-files --error-unmatch local.md >/dev/null 2>&1 && problem "local.md is tracked by git"
grep -rnE '/Users/|[0-9]{1,3}(\.[0-9]{1,3}){3}|api[_-]?key *[:=] *[A-Za-z0-9]{8,}' SKILL.md references examples README.md local.example.md && problem "personal path, IP or key found"

# 6. evals table is one block (no text line between table rows)
awk '/^\| [0-9]+ \|/ {if (gap) bad=1; seen=1; next} seen && NF {gap=1} END {exit bad}' examples/evals.md || problem "evals.md table is broken by a text line"

[ "$fail" = 0 ] && echo "OK: skill checks passed"
exit "$fail"
