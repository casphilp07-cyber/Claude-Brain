---
name: Glossar
description: Zentrales Nachschlagewerk für alle Fachbegriffe rund um Claude Code Plugins, Skills, Subagenten und MCP
tags: [glossar, claude-code, referenz]
---

# Glossar — Claude Code Ökosystem

Kurze Definitionen aller Begriffe, die in den Repo-Notizen und den [[_Architektur-Überblick|Architektur-Überblick]]/Funktionsweise-Dateien dieses Ordners auftauchen. Technisch geprüft gegen die offizielle Doku (code.claude.com/docs, Stand 01.08.2026).

## Grundbausteine

**Plugin**
Ein eigenständiger Ordner (meist ein Git-Repo) mit optionalem `.claude-plugin/plugin.json`-Manifest, der Commands/Skills, Agents, Hooks, MCP- oder LSP-Server bündelt. Wird über einen Marketplace installiert oder lokal per `--plugin-dir` geladen. Details: [[Claude Code Plugins/_Funktionsweise|Claude Code Plugins → Funktionsweise]].

**Marketplace**
Ein Katalog (`marketplace.json`), der auflistet, welche Plugins verfügbar sind und woher sie kommen (Git-Repo, lokaler Pfad). Man fügt einen Marketplace mit `/plugin marketplace add <owner>/<repo>` hinzu, danach installiert man einzelne Plugins daraus mit `/plugin install <plugin>@<marketplace>`.

**`plugin.json`**
Das Manifest eines einzelnen Plugins (`name`, `description`, `version`, `author` u.a.), liegt unter `.claude-plugin/plugin.json` im Plugin-Root.

**`marketplace.json`**
Die Katalog-Datei eines Marketplace-Repos (`name`, `owner`, Liste von `plugins` mit je `name` + `source`), liegt unter `.claude-plugin/marketplace.json`.

**Skill**
Eine Fähigkeit als Ordner mit `SKILL.md` (YAML-Frontmatter + Anweisungstext), die Claude entweder automatisch aktiviert (wenn die `description` zur Aufgabe passt) oder die man manuell per `/skill-name` aufruft. Ersetzt/erweitert die älteren "Custom Commands". Details: [[Skill Libraries/_Funktionsweise|Skill Libraries → Funktionsweise]].

**`SKILL.md`**
Die Kern-Datei einer Skill: YAML-Frontmatter (`name`, `description`, `allowed-tools` u.a.) gefolgt von Markdown-Anweisungen. Folgt dem offenen "Agent Skills"-Standard (agentskills.io), funktioniert also potenziell auch außerhalb von Claude Code.

**Progressive Disclosure**
Das Ladeprinzip von Skills: zunächst lädt nur Name+Beschreibung in den Kontext (günstig), der volle `SKILL.md`-Inhalt erst, wenn die Skill tatsächlich aufgerufen wird.

**Subagent**
Eine spezialisierte Markdown-Datei mit Frontmatter (`name`, `description`, `tools`, `model`), die in einem eigenen, isolierten Kontextfenster läuft. Der Hauptagent delegiert passende Aufgaben automatisch (oder auf Zuruf) an den Subagenten über das interne **Task-Tool** und bekommt nur das Ergebnis zurück — nicht die komplette Recherche-/Log-Historie. Details: [[Subagent & Workflow Collections/_Funktionsweise|Subagent & Workflow Collections → Funktionsweise]].

**Slash Command**
Ein per `/name` aufrufbarer Befehl — technisch heute dasselbe wie eine Skill (Custom Commands wurden in Skills zusammengeführt).

**Hook**
Ein Skript, das automatisch bei bestimmten Lifecycle-Events feuert (z.B. `PostToolUse`, `SessionStart`, `Stop`) — definiert in `hooks/hooks.json` (Plugin) oder in `settings.json` (Standalone). Läuft deterministisch, ohne Modell-Kontext zu verbrauchen (z.B. für Linting, Coverage-Checks).

**Orchestrator / Agent-Harness**
Ein System, das mehrere Subagenten koordiniert aufruft — sequenziell, parallel oder in einer festen Pipeline (z.B. Plan → Umsetzung → Review). "Harness" ist der übergeordnete Begriff für "alles, was einem Modell Werkzeuge, Speicher und Kontrolle gibt" (vgl. Ruflo: "Agent = Model + Harness").

**Swarm / Multi-Agent**
Mehrere Agenten arbeiten gleichzeitig/koordiniert an Teilaufgaben, oft mit einer Konsens- oder Hierarchie-Logik (z.B. "Queen"-geführt bei Ruflo, Debatte-plus-Richter bei agent-review-panel).

## MCP (Model Context Protocol)

**MCP**
Ein von Anthropic entwickelter offener Standard, mit dem KI-Assistenten (Clients) sich mit externen Werkzeugen/Datenquellen (Servern) verbinden — z.B. GitHub, Datenbanken, Browser. Claude Code ist ein **MCP-Client**.

**MCP-Server**
Ein Prozess/Dienst, der über MCP Tools, Resources und/oder Prompts bereitstellt, die dann als normale Tool-Aufrufe in Claude Code erscheinen.

**stdio-Transport**
MCP-Server läuft als lokaler Prozess (z.B. via `npx`, `uvx`, `docker`), Kommunikation über Standard-Ein-/Ausgabe. Typisch für lokale Tools (Dateisystem, Git).

**HTTP/SSE/WebSocket-Transport**
MCP-Server läuft remote, Claude Code verbindet sich über eine URL (`claude mcp add --transport http <name> <url>`). SSE ist mittlerweile deprecated zugunsten von HTTP. WebSocket für Server, die selbst unaufgefordert Events pushen wollen.

**`.mcp.json`**
Projekt-weite MCP-Server-Konfiguration (geteilt im Team), alternativ `~/.claude.json` für user-weite Server oder direkt per `claude mcp add`/`claude mcp add-json` gesetzt.

Details: [[MCP Server Collections/_Funktionsweise|MCP Server Collections → Funktionsweise]].

## Sonstiges

**`CLAUDE.md`**
Projekt-/Nutzer-weite "immer geladene" Anweisungsdatei — im Unterschied zur Skill lädt ihr Inhalt bei jeder Session, nicht nur bei Bedarf. Faustregel: Fakten/Kontext → CLAUDE.md, mehrschrittige Prozeduren → Skill.

**`settings.json`**
Konfigurationsdatei (user-, projekt- oder organisationsweit), u.a. mit den Feldern `enabledPlugins` (welche Plugins aktiv sind) und `extraKnownMarketplaces` (zusätzliche Marketplace-Quellen).

**Context Window / Kontextfenster**
Der "Arbeitsspeicher" eines Modell-Aufrufs. Subagenten und geforkte Skills (`context: fork`) bekommen ein eigenes, leeres Kontextfenster — deshalb eignen sie sich, um große Recherchen aus der Hauptunterhaltung herauszuhalten.

**Agent Skills (offener Standard)**
Das von Anthropic initiierte, mittlerweile herstellerübergreifende Format für Skills (agentskills.io) — funktioniert nicht nur in Claude Code, sondern z.B. auch in anderen Tools, die den Standard übernehmen.
