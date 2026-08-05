---
name: Context7
url: https://github.com/upstash/context7
stars: ~60.100
category: MCP Server Collection
tags: [mcp, documentation, upstash, code-context]
---

# Context7 (upstash/context7)

**Was es ist:** Ein einzelner, aber extrem populärer MCP-Server (von Upstash), der ein sehr konkretes Problem löst: LLMs generieren veralteten Code mit halluzinierten APIs, weil ihre Trainingsdaten veraltet sind. Context7 liefert stattdessen aktuelle, versionsspezifische Dokumentation und Code-Beispiele direkt aus der Quelle. ~60,1k Sterne, ~2,9k Forks, MIT-Lizenz.

**Kernfunktionen:**
- Erkennt automatisch, wenn im Prompt eine Bibliothek/Framework erwähnt wird, und injiziert die aktuelle, korrekte Dokumentation direkt in den Kontext — kein manuelles Tab-Wechseln oder Nachschlagen mehr nötig
- Zwei Kern-Tools: `resolve-library-id` (Bibliothek finden) und `query-docs` (Doku abrufen)
- Wofür einsetzen: praktisch für jedes Projekt, das mit sich schnell ändernden Bibliotheken/Frameworks arbeitet, bei denen Claudes Trainingsdaten veraltet sein könnten — reduziert halluzinierte/veraltete API-Aufrufe spürbar

**Wie man es mit Claude Code nutzt:**
```bash
npx ctx7 setup
```
(Claude Code als Ziel auswählen) — oder manuell die MCP-Server-URL `https://mcp.context7.com/mcp` mit API-Key als Authorization-Header in der Claude-Code-Config eintragen.

**Einschätzung:** Übernehmen — einer der am breitesten sinnvollen MCP-Server überhaupt, unabhängig vom Projekt-Typ, da er ein sehr konkretes und häufiges Problem (veraltetes API-Wissen) direkt löst.
