---
name: GitHub MCP Server (offiziell)
url: https://github.com/github/github-mcp-server
stars: ~31.900
category: MCP Server Collection
tags: [mcp, github, official, ci-cd]
---

# GitHub MCP Server (github/github-mcp-server)

**Was es ist:** GitHubs eigener, offizieller MCP-Server — verbindet KI-Agenten direkt mit der GitHub-Plattform, statt nur über `gh`-CLI-Kommandos zu gehen. ~31,9k Sterne, ~4,7k Forks, MIT-Lizenz.

**Kernfunktionen:**
- 70+ Tools in Toolsets wie `repos`, `issues`, `pull_requests`, `actions`, `code_security`
- Repository-Management: Code browsen, Dateien durchsuchen, Commits analysieren, Projektstruktur verstehen
- Issues & PRs: erstellen, aktualisieren, verwalten, automatisieren
- CI/CD: GitHub-Actions-Workflows überwachen, Build-Fehler analysieren, Releases verwalten
- Code-Analyse: Security-Findings prüfen, Dependabot-Alerts einsehen
- Team-Kollaboration: Discussions, Benachrichtigungen, Team-Aktivität
- Wofür einsetzen: tiefere/strukturiertere GitHub-Integration als reine CLI-Aufrufe, besonders wenn Claude Code viele GitHub-Objekte (Issues, PRs, Actions-Läufe) gleichzeitig im Blick behalten oder automatisiert bearbeiten soll

**Wie man es mit Claude Code nutzt:** Lokal via Docker oder aus Quellcode bauen, Authentifizierung per OAuth (Browser-Login) oder Personal Access Token, dann in der MCP-Config referenzieren (offizielle Schritt-für-Schritt-Anleitung im `docs/`-Ordner des Repos).

**Einschätzung:** Übernehmen, sobald Claude Code regelmäßig tief mit GitHub-Objekten arbeitet (viele Issues/PRs/Actions) — für gelegentliche Nutzung reicht oft die bereits vorhandene `gh`-CLI über Bash.
