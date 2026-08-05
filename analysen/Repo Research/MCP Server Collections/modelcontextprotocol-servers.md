---
name: modelcontextprotocol/servers (offiziell)
url: https://github.com/modelcontextprotocol/servers
stars: ~89.100
category: MCP Server Collection
tags: [mcp, official, reference-implementation]
---

# Model Context Protocol Servers (offizielles Repo)

**Was es ist:** Das offizielle Referenz-Repository für MCP-Server, gepflegt von der Anthropic-geführten MCP-Steering-Gruppe. Eher als Lehrbeispiele gedacht denn als produktionsreife Lösungen. ~89,1k Sterne, ~11,3k Forks.

**Kernfunktionen:**
- 7 aktive Referenz-Server: **Everything** (Test-Server, demonstriert alle MCP-Features), **Fetch** (Web-Inhalte abrufen/umwandeln), **Filesystem** (Dateioperationen mit Zugriffskontrollen), **Git** (Repos lesen/durchsuchen/bearbeiten), **Memory** (Knowledge-Graph-basiertes persistentes Gedächtnis), **Sequential Thinking** (strukturiertes Problemlösen in Denkschritten), **Time** (Zeitzonen-Umrechnung)
- Wofür einsetzen: als Ausgangspunkt, um zu verstehen, wie ein MCP-Server grundsätzlich aufgebaut ist, plus direkt nutzbare einfache Server (z.B. Memory für persistentes Gedächtnis über Sessions hinweg)
- Weitere (ältere) Server wurden archiviert und in ein separates Repo verschoben

**Wie man es mit Claude Code nutzt:** Server in der MCP-Config einbinden, TypeScript-Server via `npx`, Python-Server via `uvx`/`pip`, z.B.:
```json
{
  "mcpServers": {
    "memory": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-memory"] }
  }
}
```

**Einschätzung:** Übernehmen als Referenz und für die einfachen, robusten Server (v.a. Memory, Filesystem, Fetch) — für alles Domänenspezifische (GitHub, Browser etc.) eher die spezialisierten Server unten nutzen.
