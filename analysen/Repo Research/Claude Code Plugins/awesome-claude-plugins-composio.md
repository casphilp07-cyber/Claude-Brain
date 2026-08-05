---
name: awesome-claude-plugins (Composio)
url: https://github.com/composio-community/awesome-claude-plugins
stars: ~1.850
category: Claude Code Plugin
tags: [claude-code, plugin, integrations, composio, saas]
---

# Awesome Claude Plugins — Composio (composio-community/awesome-claude-plugins)

**Was es ist:** Eine kuratierte Liste produktionsreifer Claude-Code-Plugins mit Schwerpunkt auf externen Integrationen, betrieben vom Composio-Team (bekannt für App-Integrations-Infrastruktur). ~1,85k Sterne, ~528 Forks.

**Kernfunktionen:**
- Neun funktionale Kategorien: Integrationen (u.a. "connect-apps" für 1000+ Dienste über Composio), Frontend/Design, Git & Versionskontrolle, Code-Qualität & Testing, Backend-Architektur, DevOps & Performance, Doku & Security, Developer-Produktivität, Companion-Features
- Wofür einsetzen: sobald Claude Code an externe SaaS-Dienste angebunden werden soll (Slack, GitHub, Stripe, CRMs etc.) ohne jede Integration selbst zu bauen — deckt damit eine Lücke ab, die reine Agent-/Skill-Sammlungen nicht abdecken

**Wie man es mit Claude Code nutzt:**
```bash
git clone https://github.com/composiohq/awesome-claude-plugins.git
claude --plugin-dir ./commit
```
Mehrere Plugins lassen sich gleichzeitig laden, indem man weitere `--plugin-dir`-Flags angibt. Folgt dem Standard-Claude-Code-Plugin-Format (eigener Ordner mit Metadaten, Skills, Commands, Agents, Hooks pro Plugin).

**Einschätzung:** Als Plugin installieren, sobald externe App-Integrationen gebraucht werden — für reine Coding-Workflows ohne SaaS-Anbindung weniger relevant als die anderen Einträge dieser Kategorie.
