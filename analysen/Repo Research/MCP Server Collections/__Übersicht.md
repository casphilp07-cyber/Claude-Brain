---
name: MCP Server Collections Übersicht
description: Index aller recherchierten MCP-Server-Repos/-Listen
category: MCP Server Collection
---

# MCP Server Collections — Übersicht

Recherchiert am 01.08.2026, Sterne-Zahlen live via GitHub API verifiziert.

| Repo | Sterne | Zweck | Empfehlung |
|---|---|---|---|
| [[punkpeye-awesome-mcp-servers]] | ~91.700 | Größtes MCP-Server-Verzeichnis überhaupt | **Erste Anlaufstelle** |
| [[modelcontextprotocol-servers]] | ~89.100 | Offizielle Referenz-Server (Memory, Filesystem, Fetch, Git...) | Übernehmen (Basis-Server) |
| [[context7]] | ~60.100 | Aktuelle Bibliotheks-Doku direkt in den Kontext injizieren | **Übernehmen (breit nützlich)** |
| [[playwright-mcp]] | ~35.700 | Browser-Automatisierung (headless/CI-tauglich) | Übernehmen für E2E-Tests |
| [[github-mcp-server]] | ~31.900 | Tiefe GitHub-Integration (70+ Tools: Issues, PRs, Actions, Security) | Bei intensiver GitHub-Nutzung |
| [[wong2-awesome-mcp-servers]] | ~4.238 | Kleinere, kuratiertere Alternativliste | Als Zweitquelle |

## Top-Empfehlungen
1. **Context7** zuerst installieren — löst ein sehr konkretes, häufiges Problem (veraltetes API-Wissen) unabhängig vom Projekt
2. **punkpeye/awesome-mcp-servers** als Standard-Suchort, bevor ein neuer MCP-Server selbst gebaut wird
3. **Playwright MCP** ergänzend zu `claude-in-chrome` für automatisierte/CI-taugliche Browser-Tests
4. **GitHub MCP Server** nur bei wirklich intensiver, strukturierter GitHub-Arbeit — sonst reicht die vorhandene `gh`-CLI
