---
name: myclaude
url: https://github.com/stellarlinkco/myclaude
stars: ~2.745
category: Subagent & Workflow Collection
tags: [claude-code, orchestration, multi-agent, multi-harness, workflow]
---

# myclaude (stellarlinkco/myclaude)

**Was es ist:** Ein Multi-Agent-Orchestrierungs-Workflow-System, das nicht nur Claude Code, sondern auch Codex, Gemini und OpenCode als austauschbare Backends unterstützt. ~2,7k Sterne, ~308 Forks, AGPL-3.0-Lizenz (Copyleft — bei Nachbau/Verwendung von Code beachten).

**Kernfunktionen:**
- **`/do`-Workflow**: 5-Phasen-Feature-Entwicklung mit "Codeagent"-Orchestrierung (Planung → Umsetzung → Test → etc.)
- Unterstützt 4 KI-Coding-Backends gleichzeitig (Codex, Claude, Gemini, OpenCode) mit jeweils backend-spezifischer CLI-Ansteuerung — nützlich, wenn man verschiedene Modelle für verschiedene Teilaufgaben nutzen will (Cross-Validation)
- Modulares System: einzelne Workflows (`/bmad-pilot`, `/requirements-pilot`, `/code`, `/debug`) über `config.json` ein-/ausschaltbar
- Wofür einsetzen: Projekte, bei denen man bewusst zwischen mehreren KI-Anbietern wechseln oder deren Ergebnisse gegeneinander prüfen will, statt sich auf ein einzelnes Modell zu verlassen

**Wie man es mit Claude Code nutzt:**
```bash
npx github:stellarlinkco/myclaude
```
Installiert nach `~/.claude/`, Module über `--list`, `--update`, `--install-dir` verwaltbar.

**Einschätzung:** Für Nachbau interessant wegen des Multi-Backend-Ansatzes (Cross-Validation zwischen Modellen), für die direkte Installation aber nur relevant, wenn wirklich mehrere KI-Anbieter parallel genutzt werden sollen — sonst overkill gegenüber reinen Claude-Code-Lösungen wie oh-my-claudecode.
