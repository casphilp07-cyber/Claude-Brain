---
name: ruflo
url: https://github.com/ruvnet/ruflo
stars: ~66.700
category: Claude Code Plugin
tags: [claude-code, plugin, multi-agent, swarm, orchestration, mcp]
---

# Ruflo (ruvnet/ruflo, vormals "claude-flow")

**Was es ist:** Der von Caspar bereits bekannte "Ruflo" — ein "Agent-Meta-Harness": Wo Claude Code das Modell mit Basis-Werkzeugen ausstattet, baut Ruflo eine ganze Koordinationsschicht darüber (Motto: "Agent = Model + Harness"). ~66,7k Sterne, ~8k Forks, MIT-Lizenz, sehr aktiv gepflegt (Push heute).

**Kernfunktionen:**
- **Swarms & Koordination**: hierarchische und Mesh-Topologien mit Konsens-Mechanismen (Raft, Byzantine, Gossip), "Queen"-geführte Aufgabenverteilung, adaptive Neuplanung bei sich ändernden Bedingungen — nützlich, um mehrere Agenten arbeitsteilig an einer größeren Aufgabe arbeiten zu lassen statt alles sequenziell mit einem Agent
- **~210 MCP-Tools** in 5 Servergruppen (Core, Intelligence, Agents, Memory, DevTools), parallele Tool-Ausführung (4-6+ gleichzeitig)
- **100+ spezialisierte Agenten-Rollen** (Coder, Tester, Reviewer, Architect, Security, Docs, sogar Domain-Spezialisten wie Trading/IoT) mit Selbstlern-Fähigkeit über "SONA"-Musterkennung
- **Memory-System**: AgentDB mit HNSW-Vektorindex für sub-millisekundenschnellen Abruf, persistente Speicherung über Sessions hinweg — praktisch für Projekte, bei denen Kontext über viele Sitzungen erhalten bleiben soll
- Einsatzzweck: komplexe, lang laufende oder stark parallelisierbare Projekte, bei denen ein einzelner Claude-Code-Agent an Kontext- oder Koordinationsgrenzen stößt

**Wie man es mit Claude Code nutzt:**
Nur Slash Commands (ohne vollen MCP-Server):
```
/plugin marketplace add ruvnet/ruflo
/plugin install ruflo-core@ruflo
/plugin install ruflo-swarm@ruflo
```
Für den vollen Ruflo-Loop mit MCP-Server:
```
claude mcp add ruflo -- npx ruflo@latest mcp start
```

**Einschätzung:** Als Vorlage für Nachbau sehr wertvoll (Swarm-Konsens-Mechanismen, Memory-Architektur), für den produktiven Alltag aber hoher Setup- und Komplexitätsaufwand (210 MCP-Tools, eigene Terminologie) — lohnt sich vor allem, wenn wirklich mehrere Agenten koordiniert an einer Aufgabe arbeiten sollen, nicht für einfache Einzel-Sessions.
