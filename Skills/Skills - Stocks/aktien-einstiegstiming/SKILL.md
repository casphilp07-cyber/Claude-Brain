---
name: aktien-einstiegstiming
description: Bewertet, ob jetzt ein guter Einstiegszeitpunkt für eine Aktie ist, basierend auf aktueller Bewertung, jüngster Kursbewegung und wichtigen Unterstützungsniveaus — mit klarer Empfehlung (jetzt kaufen / auf Rücksetzer warten / konkreten Zielkurs setzen). Nutze diesen Skill, wenn der Nutzer fragt, ob er eine bestimmte Aktie jetzt kaufen soll, wann der beste Einstiegszeitpunkt ist, oder ob er auf einen Pullback warten soll.
tags: [claude-code, skills, aktien, timing, einstieg]
---

# Einstiegszeitpunkt einer Aktie timen

Beantwortet die konkrete Frage: "Soll ich jetzt einsteigen, warten, oder auf einen bestimmten Kurs limitieren?"

## Ablauf

1. **Ticker klären**, falls nicht genannt.
2. **Aktuelle Kurs- und Chartdaten nutzen**, wenn Web-Zugriff verfügbar ist — diese Frage lässt sich ohne aktuellen Kurs und jüngste Kursbewegung nicht seriös beantworten. Ist kein Web-Zugriff möglich, mach das explizit klar und bitte den Nutzer um den aktuellen Kurs sowie relevante Chartpunkte, statt eine Timing-Einschätzung ohne aktuelle Daten zu raten.
3. **Einschätzung strukturieren** wie unten.

## Output-Struktur

```
# [Unternehmen] ([Ticker]) — Einstiegstiming

## Aktuelle Bewertung
Ist die Aktie aktuell eher günstig, fair oder teuer bewertet
(relativ zu Historie und Peers)

## Jüngste Kursbewegung
Trend der letzten Wochen/Monate, Momentum, auffällige Volumenmuster
oder Katalysatoren

## Wichtige Unterstützungs-/Widerstandsniveaus
Konkrete Kursmarken, die charttechnisch relevant sind

## Empfehlung
Eine der drei klaren Optionen, mit Begründung:
- Jetzt einsteigen
- Auf Rücksetzer warten (mit ungefährer Preiszone)
- Konkreten Ziel-Einstiegskurs setzen (mit exaktem Preis und Begründung)
```

## Wichtig

Charttechnische Einschätzungen sind unsicher — mach transparent, dass es sich um eine Einschätzung basierend auf aktuell verfügbaren Daten handelt und nicht um eine Garantie für die künftige Kursentwicklung. Schließe mit dem Hinweis ab, dass dies keine individuelle Anlageberatung ersetzt.
