---
name: adamsreview
url: https://github.com/adamjgmiller/adamsreview
stars: ~241
category: Subagent & Workflow Collection
tags: [claude-code, code-review, multi-agent, pipeline]
---

# Adamsreview (adamjgmiller/adamsreview)

**Was es ist:** Eine alternative Multi-Lens-Code-Review-Pipeline für Claude Code — konzeptionell ähnlich zum bereits bekannten `/code-review`/Ultrareview, aber als eigenständiges, anpassbares Plugin statt eingebautem Anthropic-Feature. ~241 Sterne, ~7 Forks, MIT-Lizenz.

**Kernfunktionen:**
- Bis zu 7 parallele Subagenten-"Linsen" (Correctness, Security, UX u.a.), die anschließend über eine Dedup-Runde konsolidiert werden
- Zweistufiges Validierungs-Gate: günstiger erster Check, dann optional ein "holistischer" Opus-Cross-Cutting-Pass für tiefere Analyse — spart Kosten, indem nur bei Bedarf das teure Modell läuft
- Persistenter JSON-State + automatischer Fix-Loop: findet Probleme, behebt sie, reviewed erneut, macht Regressionen rückgängig bevor committed wird
- Interaktiver Walkthrough-Modus und Möglichkeit, externe Findings (z.B. von einem Linter) einzuspeisen
- Wofür einsetzen: als selbst hostbare/anpassbare Alternative zu Ultrareview, wenn man die Review-Pipeline stärker kontrollieren oder erweitern will als es das eingebaute Anthropic-Feature erlaubt

**Wie man es mit Claude Code nutzt:** Über die im Repo dokumentierte Plugin-Installation (Marketplace-Eintrag im Repo selbst, README für Details).

**Einschätzung:** Als Vorlage für Nachbau interessant (gestuftes billig-dann-teuer Validierungs-Gate, automatischer Fix-Loop mit Regressions-Rückgängigmachung) — für den produktiven Einsatz aber noch klein/wenig erprobt im Vergleich zum eingebauten Ultrareview.
