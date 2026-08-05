---
name: everything-claude-code (ECC)
url: https://github.com/affaan-m/ECC
stars: ~236.700
category: Claude Code Plugin
tags: [claude-code, plugin, agents, skills, hooks, memory, security]
---

# Everything Claude Code / ECC (affaan-m/ECC)

**Was es ist:** Das von Caspar bereits bekannte "everything-claude-code" — mittlerweile umbenannt in **ECC** ("Agent Harness Operating System"). Entstanden aus einem Anthropic×Forum-Ventures-Hackathon-Gewinn (Sept. 2025), im Januar 2026 komplett open-source (MIT) veröffentlicht. Sehr groß gewachsen: ~236,7k Sterne, ~36k Forks, 117 offene Issues — die Fork-Zahl ist ungewöhnlich hoch im Verhältnis zu den Stars, was für echtes (statt gekauftes) Engagement spricht.

**Kernfunktionen:**
- **67 spezialisierte Subagenten** (Planner, Code-Reviewer, Security-Reviewer u.a.) mit begrenzten Rechten, um Kontext fokussiert zu halten
- **281 Skills** (TDD-Workflow, Security-Review, E2E-Testing, Doku-Updates etc.), die on-demand statt bei jedem Prompt geladen werden
- **Hooks** für SessionStart/PostToolUse/Stop, die deterministische Checks (Linting, Coverage-Schwellen, Session-Zusammenfassung) ausführen, ohne Modellkontext zu verbrauchen
- **Memory-System**: persistente Session-Zusammenfassungen, "gelernte Instinkte" mit Konfidenz-Score, harness-übergreifende Memory-Vaults als lokale Markdown-Dateien
- **AgentShield**: Security-Scanner für CLAUDE.md, settings.json, Hooks und MCP-Configs (Prompt-Injection-Risiken, Rechte-Lecks, Fehlkonfigurationen) — nutzbar auch für andere Repos/Projekte als Sicherheits-Check
- Einsatzzweck: geeignet, wenn man Claude Code von reaktiver Code-Generierung zu einem strukturierten, verifizierbaren Engineering-Prozess über viele Sessions hinweg ausbauen will (Pläne verschwinden sonst im Chatverlauf, TDD wird vergessen, Qualitätschecks hängen an manueller Erinnerung)

**Wie man es mit Claude Code nutzt:**
```
/plugin marketplace add https://github.com/affaan-m/ECC
/plugin install ecc@ecc
```
Danach sprachspezifische Regeln ergänzen:
```
mkdir -p ~/.claude/rules/ecc
cp -R rules/common ~/.claude/rules/ecc/
cp -R rules/typescript ~/.claude/rules/ecc/   # je nach Stack
```

**Einschätzung:** Als Vorlage für Nachbau besonders interessant (AgentShield-Konzept, Instincts-System mit Konfidenz-Score) — für eine komplette Installation ist es aber sehr umfangreich/komplex (281 Skills, 67 Agents), daher lieber gezielt einzelne Bausteine übernehmen statt alles auf einmal zu aktivieren.
