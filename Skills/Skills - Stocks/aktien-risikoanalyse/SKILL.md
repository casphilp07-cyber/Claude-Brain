---
name: aktien-risikoanalyse
description: Analysiert das reale Abwärtsrisiko einer Aktienposition — Branchenrisiken, Wettbewerbsdruck, Bilanzschwächen, Makro-Exposure und ein realistisches Worst-Case-Szenario. Nutze diesen Skill, wenn der Nutzer nach dem Risiko, den Gefahren, dem "was kann schiefgehen" oder dem Downside einer bestimmten Aktie fragt — nicht zu verwechseln mit einer allgemeinen Vollanalyse, hier steht explizit das Risiko im Fokus.
tags: [claude-code, skills, aktien, risiko, analyse]
---

# Aktien-Risikoanalyse

Fokussiert bewusst nur auf die Abwärtsrisiken eines Titels — als Gegengewicht zu einer optimistischen Bull-Case-Betrachtung.

## Ablauf

1. **Ticker klären**, falls nicht genannt.
2. **Aktuelle Daten nutzen**, wenn Web-Zugriff verfügbar ist, insbesondere für Bilanzkennzahlen und jüngste Negativ-Meldungen. Sonst transparent auf den Wissensstand hinweisen.
3. **Risiken systematisch durchgehen** entlang der Struktur unten — bewusst kritisch, nicht ausgewogen. Diese Analyse soll die Frage "was kann schiefgehen" beantworten, nicht die Gesamtstory erzählen.

## Output-Struktur

```
# [Unternehmen] ([Ticker]) — Risikoanalyse

## Branchen- und strukturelle Risiken
Disruption, regulatorischer Druck, zyklische Abhängigkeit, Marktsättigung

## Wettbewerbsrisiken
Neue Konkurrenten, Preisdruck, Erosion des Burggrabens, Marktanteilsverluste

## Bilanz- und Finanzierungsrisiken
Verschuldung, anstehende Refinanzierungen, Liquiditätspuffer,
Covenant-Risiken, Verwässerungsgefahr

## Makro-Exposure
Zinssensitivität, Währungsrisiko, Konjunkturabhängigkeit,
geopolitische Faktoren

## Realistisches Worst-Case-Szenario
Ein konkretes, plausibles (nicht übertriebenes) Negativszenario:
Was müsste passieren, wie stark könnte der Kurs darunter leiden,
und was wäre das früheste Warnsignal dafür

## Risiko-Fazit
Gesamteinschätzung: ist das Risiko überdurchschnittlich, durchschnittlich
oder unterdurchschnittlich im Vergleich zu Peers — mit Begründung
```

## Wichtig

Bleib faktenbasiert und realistisch — das Ziel ist eine ehrliche Risikoeinschätzung, keine Panikmache. Schließe mit dem Hinweis ab, dass dies keine individuelle Anlageberatung ersetzt.
