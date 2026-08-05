---
name: oh-my-claudecode (OMC)
url: https://github.com/Yeachan-Heo/oh-my-claudecode
stars: ~38.200
category: Subagent & Workflow Collection
tags: [claude-code, orchestration, multi-agent, teams, workflow]
---

# Oh-My-ClaudeCode (Yeachan-Heo/oh-my-claudecode)

**Was es ist:** Ein "Teams-first"-Multi-Agent-Orchestrierungssystem, das die manuelle Koordination von Claude Code über mehrere Aufgaben hinweg automatisiert — statt ein Agent versucht alles sequenziell zu erledigen, arbeiten spezialisierte Claude-Agenten gemeinsam an geteilten Task-Listen. ~38,2k Sterne, ~3,4k Forks, MIT-Lizenz, sehr aktiv (Push heute).

**Kernfunktionen:**
- **Team-Modus** (empfohlen): gestufte Pipeline `team-plan → team-prd → team-exec → team-verify → team-fix`, aufrufbar via `/team 3:executor "task"`
- **Autopilot**: autonome Einzelagenten-Ausführung für Feature-Arbeit
- **Ralph**: persistente Verify/Fix-Loops, die sicherstellen, dass eine Aufgabe wirklich vollständig erledigt wird (nicht nur "sieht fertig aus")
- **UltraQA**: wiederholtes Durchlaufen bis Tests/Lint/Build tatsächlich grün sind
- **Deep Interview**: sokratisches Nachfragen, um Anforderungen zu klären, bevor überhaupt Code geschrieben wird
- Provider-Advisor (`/ask codex`, `/ask antigravity`) für Cross-Validation mit anderen Modellen
- Reduziert laut Repo Token-Kosten um 30-50% durch automatische statt manuelle Agenten-Auswahl
- Wofür einsetzen: wenn wiederkehrend größere Features mit mehreren Teilaufgaben umgesetzt werden sollen und man nicht jedes Mal von Hand orchestrieren will, welcher Agent was macht

**Wie man es mit Claude Code nutzt:**
```
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
/setup
```
Danach z.B.: `/autopilot "build a REST API for managing tasks"` oder `/team 3:executor "fix all TypeScript errors"`.

**Einschätzung:** Als Plugin installieren/testen — konkreter und direkt nutzbarer Team-Workflow als Ruflo (weniger exotische Konzepte wie Byzantine-Konsens), dafür fokussiert auf den tatsächlichen Coding-Alltag.
