---
name: claude-code (inkl. eingebautes code-review Plugin)
url: https://github.com/anthropics/claude-code
stars: ~139.900
category: Claude Code Plugin
tags: [claude-code, official, cli, code-review, ultrareview]
---

# Claude Code (anthropics/claude-code)

**Was es ist:** Das Basis-Tool selbst — Anthropics offizielles agentisches Terminal-Coding-Tool. Wird hier aufgeführt, weil darin bereits das von Caspar bekannte **"code-review"**-Feature als offizielles Plugin enthalten ist (`anthropics/claude-code/plugins/code-review`). ~139,9k Sterne, ~22,5k Forks.

**Kernfunktionen:**
- Das eigentliche CLI (Terminal-Agent, versteht Codebasen, führt Routineaufgaben aus, erklärt Code, übernimmt Git-Workflows)
- Eingebauter **`/code-review`**-Befehl: scannt Diffs auf Bugs/Verbesserungspotenzial in 5 Effort-Stufen, von schnellem lokalem Check bis zur Multi-Agenten-Cloud-Analyse
- **Ultrareview** (`/code-review ultra`): lädt das Repo in eine Anthropic-Cloud-Sandbox hoch, wo eine Flotte spezialisierter Agenten parallel prüft — fünf unabhängige Reviewer decken CLAUDE.md-Konformität, Bug-Erkennung, Git-Historie-Kontext, alte PR-Kommentare und Code-Kommentar-Verifikation ab; Ergebnis wird direkt als Feedback auf GitHub-PRs gepostet
- Wofür einsetzen: Pre-Merge-Qualitätssicherung ohne eigenes Review-Tool bauen zu müssen — genau der Workflow, den Caspar in dieser Session bereits kennt und nutzt

**Wie man es mit Claude Code nutzt:** Ist im CLI direkt eingebaut, kein separater Marketplace-Install nötig — einfach `/code-review` bzw. `/code-review ultra` aufrufen. Der Plugin-Ordner `plugins/` im Repo zeigt außerdem die Referenzstruktur (`.claude-plugin/`, `commands/`, `agents/`, `skills/`, `hooks/`, `.mcp.json`), an der sich alle Drittanbieter-Plugins orientieren.

**Einschätzung:** Übernehmen (ist ohnehin die Basis) — als Referenz-Repo besonders wertvoll, um zu verstehen, wie ein "richtiges" Plugin strukturiert sein sollte, bevor man eigene baut oder Drittanbieter-Plugins bewertet.
