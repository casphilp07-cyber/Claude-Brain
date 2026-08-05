---
name: claude-code-templates
url: https://github.com/davila7/claude-code-templates
stars: ~30.000
category: Claude Code Plugin
tags: [claude-code, cli, templates, analytics, monitoring, mcp]
---

# Claude Code Templates (davila7/claude-code-templates)

**Was es ist:** Ein CLI-Tool (per `npx`, kein Git-Clone nötig) mit über 100 fertigen Agenten, Commands, Settings, Hooks, MCP-Integrationen und Projekt-Templates für Claude Code — plus einem eigenen Analytics-/Monitoring-Layer. ~30k Sterne, ~3,3k Forks, MIT-Lizenz, sehr aktiv (Push heute).

**Kernfunktionen:**
- **Agenten**: domänenspezifische Spezialisten (Security-Auditor, Performance-Optimierer, Architekten)
- **Commands**: fertige Slash Commands wie `/generate-tests`, `/optimize-bundle`
- **MCPs**: vorkonfigurierte Integrationen (GitHub, PostgreSQL, Stripe, AWS, OpenAI)
- **Analytics-Dashboard**: Echtzeit-Monitoring von Claude-Code-Sessions (Live-State, Performance-Metriken) — nützlich, um zu sehen, was Claude gerade tut/wie effizient es arbeitet
- **Conversation Monitor**: mobil-optimierte Ansicht, um Claude-Antworten unterwegs zu verfolgen
- **Health-Check**: Diagnose-Tool für die eigene Claude-Code-Konfiguration
- **Plugin-Dashboard**: einheitliche Oberfläche zur Marketplace-Verwaltung
- Wofür einsetzen: schnelles Bootstrapping eines Projekts mit fertigen Komponenten UND laufendes Monitoring/Debugging der eigenen Claude-Code-Nutzung — deckt also nicht nur Setup, sondern auch Betrieb ab

**Wie man es mit Claude Code nutzt:**
```bash
npx claude-code-templates@latest                     # interaktives Browsen
npx claude-code-templates@latest --agent development-tools/code-reviewer --yes
npx claude-code-templates@latest --analytics          # Analytics-Dashboard
npx claude-code-templates@latest --health-check       # Diagnose
```

**Einschätzung:** Als Plugin installieren — besonders das Analytics-/Health-Check-Feature ist unter den recherchierten Repos einzigartig und direkt nützlich, unabhängig davon, welche anderen Plugins man sonst nutzt.
