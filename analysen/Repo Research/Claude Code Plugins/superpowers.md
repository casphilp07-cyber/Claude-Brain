---
name: superpowers
url: https://github.com/obra/superpowers
stars: ~264.600
category: Claude Code Plugin
tags: [claude-code, plugin, skills, methodology, tdd]
---

# Superpowers (obra/superpowers)

**Was es ist:** Das aktuell mit Abstand populärste Claude-Code-Plugin (Stand 08/2026, ~264k Sterne, ~23,6k Forks). Kein einzelnes Tool, sondern eine komplette Software-Entwicklungs-Methodik als Skill-Framework: Claude soll nicht sofort drauflos coden, sondern erst brainstormen, eine Spec validieren, planen und dann kontrolliert (mit Review-Checkpoints) umsetzen.

**Kernfunktionen:**
- Automatisch aktivierende Skills (kein manueller Aufruf nötig) für: Brainstorming/Design-Verfeinerung, Plan-Erstellung, Subagent-gesteuerte parallele Umsetzung mit Review, Test-Driven-Development (RED-GREEN-REFACTOR), systematisches Debugging (Root-Cause statt Symptom-Fixing), Arbeiten mit Git-Worktrees für isolierte Branches, strukturiertes Anfordern von Code-Reviews
- Nutzbar überall dort, wo man will, dass Claude wie ein erfahrener Senior Engineer vorgeht statt impulsiv Code zu schreiben — besonders wertvoll bei größeren/mehrschrittigen Features, wo unkontrolliertes Losprogrammieren sonst zu Chaos führt
- Enthält eigene Slash Commands: `/brainstorm`, `/write-plan`, `/execute-plan`

**Wie man es mit Claude Code nutzt:**
```
/plugin install superpowers@claude-plugins-official
```
Alternativ über die eigene Marketplace:
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```
Verwandte Repos: `obra/superpowers-skills` (community-editierbare Skills), `obra/superpowers-lab` (experimentelle Skills).

**Einschätzung:** Übernehmen — das mit Abstand am meisten erprobte und breitest genutzte Skill-Set im gesamten Ökosystem, im offiziellen Anthropic-Marketplace gelistet, methodisch sehr nah an dem, was der bereits genutzte `/code-review`-Workflow anstrebt (strukturierte Qualitätssicherung statt Ad-hoc-Coding).
