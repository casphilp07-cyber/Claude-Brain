---
name: agent-review-panel (roundtable)
url: https://github.com/wan-huiyan/agent-review-panel
stars: ~29
category: Subagent & Workflow Collection
tags: [claude-code, multi-agent, review, debate, adversarial]
---

# Agent Review Panel / Roundtable (wan-huiyan/agent-review-panel)

**Was es ist:** Ein Claude-Code-Skill für hochkritische Reviews (Code, Pläne, Dokumentation), bei dem 4-6 KI-Reviewer mit unterschiedlichen Personas (z.B. "Security Auditor", "Devil's Advocate") unabhängig voneinander bewerten, sich anschließend gegenseitig in einer echten Debatte herausfordern, und ein "Supreme Judge" am Ende entscheidet. Nur ~29 Sterne — sehr klein/neu, aber konzeptionell bemerkenswert.

**Kernfunktionen:**
- 16-Phasen-Ablauf: (1) unabhängiges Parallel-Review ohne gegenseitige Einsicht, (2) private Selbst-Einschätzung der Konfidenz vor jedem Austausch, (3) 1-3 Runden echte Streitgespräche zwischen den Reviewern (z.B. debattieren "Feasibility Analyst" und "Risk Assessor", ob ein hardcodierter Wert wirklich harmlos ist oder eine versteckte Verzerrung einführt), (4) Verifikation aller Zitate gegen den echten Code + Schieds-Urteil durch den "Supreme Judge" + Post-Judge-Check gegen Halluzinationen, (5) Output als Markdown-Report, Prozess-Historie und interaktives HTML-Dashboard
- Findings mit Schweregrad (P0-P3) und Konfidenz-Label (`[VERIFIED]`, `[CONSENSUS]`, `[DISPUTED]`) markiert
- Kosten: $3-20 pro Durchlauf (6-15 Min.), Budget-Modus für ~20-25% der Kosten verfügbar
- Wofür einsetzen: **konzeptionell sehr nah an Caspars eigenem "der-rat"-Skill** — statt eines einzelnen Beraters/Reviewers ein Gremium mit echter Gegenrede, hier speziell auf Code/technische Pläne zugeschnitten statt allgemeine Entscheidungen

**Wie man es mit Claude Code nutzt:**
```
claude plugin marketplace add wan-huiyan/agent-review-panel
claude plugin install roundtable@agent-review-panel
```
Aufruf: `/roundtable:agent-review-panel` gefolgt vom zu prüfenden Code/Plan, oder natürlichsprachlich: "Review this implementation plan from multiple perspectives: docs/my_plan.md"

**Einschätzung:** Als Vorlage für Nachbau sehr interessant — das Debatte-plus-Richter-Muster ließe sich direkt in eine eigene, an "der-rat" angelehnte Code-Review-Variante übertragen; für den produktiven Einsatz aber noch sehr unerprobt (kaum Sterne/Adoption, hohe Tokenkosten pro Lauf).
