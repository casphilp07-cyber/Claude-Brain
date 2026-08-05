---
name: Architektur-Überblick
description: Gesamtbild, wie Claude-Code-Kern, Plugins, Skills, Subagenten, Hooks und MCP-Server zusammenhängen
tags: [architektur, claude-code, übersicht]
---

# Architektur-Überblick

Dieses Diagramm zeigt, wie die vier recherchierten Kategorien technisch zusammenhängen. Details zu jedem einzelnen Kasten stehen im [[Glossar]] und in der jeweiligen `Funktionsweise.md` pro Kategorie.

```mermaid
flowchart TB
    User["Du (Prompt)"] --> Core["Claude Code Kern<br/>(Haupt-Agent, ein Kontextfenster)"]

    subgraph MP["Marketplace-Ebene"]
        MPJSON["marketplace.json<br/>(Katalog: welche Plugins, woher)"]
    end

    Core -- "/plugin marketplace add<br/>/plugin install" --> MP
    MP -- installiert --> Plugin["Plugin<br/>(.claude-plugin/plugin.json)"]

    Plugin --> Skills["skills/<br/>SKILL.md"]
    Plugin --> Agents["agents/<br/>Subagent-Definitionen"]
    Plugin --> Hooks["hooks/hooks.json<br/>Event-Handler"]
    Plugin --> MCPCfg[".mcp.json<br/>MCP-Server-Config"]

    Core -- "lädt automatisch<br/>bei passender description" --> Skills
    Core -- "delegiert via Task-Tool" --> Sub["Subagent<br/>(eigenes, isoliertes Kontextfenster)"]
    Agents -.registriert.-> Sub
    Sub -- "kann selbst wieder<br/>Skills/Tools nutzen" --> Skills

    Core -- "feuert Events<br/>(PostToolUse, Stop, ...)" --> HookRun["Hook-Skript läuft<br/>(kein Modell-Kontext nötig)"]
    Hooks -.definiert.-> HookRun

    MCPCfg --> MCPClient["Claude Code als MCP-Client"]
    MCPClient <-- "stdio (lokaler Prozess)<br/>oder HTTP/SSE/WS (remote)" --> MCPServer["MCP-Server"]
    MCPServer --> External["Externes System<br/>(GitHub, DB, Browser, Doku-API, ...)"]

    Orchestrator["Orchestrator-Skill / Team-Command<br/>(z.B. oh-my-claudecode, Ruflo)"] -- "startet mehrere" --> Sub
    Core -.kann sein.-> Orchestrator

    style Core fill:#4c6ef5,color:#fff
    style Sub fill:#7048e8,color:#fff
    style MCPServer fill:#0ca678,color:#fff
    style Plugin fill:#f08c00,color:#fff
```

## Kurz erklärt

- **Ganz oben:** Du schreibst einen Prompt an den Claude-Code-Kern — das ist die eine "Haupt-Unterhaltung" mit ihrem eigenen Kontextfenster.
- **Plugins/Marketplace** sind der Distributionsweg: ein Marketplace-Repo listet in `marketplace.json`, welche Plugins es gibt; ein installiertes Plugin bringt eine beliebige Kombination aus Skills, Agents, Hooks und/oder einer MCP-Server-Config mit.
- **Skills** laufen meist *inline* im Hauptkontext (Anweisungstext wird eingefügt), können aber auch `context: fork` gesetzt bekommen und dann in einem eigenen Subagenten laufen.
- **Subagenten** sind der zentrale Mechanismus für Isolation: eigenes Kontextfenster, eigene Tool-Rechte, Ergebnis geht als Zusammenfassung zurück an den Hauptkontext. Orchestrator-Systeme (Ruflo, oh-my-claudecode, wshobson/agents) bauen genau darauf auf, indem sie mehrere Subagenten koordiniert nacheinander oder parallel starten.
- **Hooks** laufen komplett außerhalb des Modell-Kontexts — reine Skripte, die auf Ereignisse reagieren (z.B. nach jedem Datei-Edit automatisch linten).
- **MCP** ist der einzige Weg, mit *externen* Systemen zu sprechen: Claude Code ist immer der Client, der MCP-Server liefert die eigentliche Anbindung (lokal per stdio oder remote per HTTP/SSE/WebSocket).

Siehe auch die kategoriespezifischen Diagramme in:
- [[Claude Code Plugins/_Funktionsweise]]
- [[Skill Libraries/_Funktionsweise]]
- [[Subagent & Workflow Collections/_Funktionsweise]]
- [[MCP Server Collections/_Funktionsweise]]
