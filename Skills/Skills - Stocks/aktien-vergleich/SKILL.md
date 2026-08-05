---
name: aktien-vergleich
description: Vergleicht zwei Aktien direkt gegenüber (Bewertung, Wachstumspfad, finanzielle Gesundheit, Wettbewerbsmoat) für ein bestimmtes Anlegerprofil und einen Zeithorizont, und sagt klar, welche der beiden der stärkere Kauf ist. Nutze diesen Skill, wenn der Nutzer zwei Ticker/Unternehmen gegenüberstellt, "X oder Y" fragt, oder wissen will, welche von zwei Aktien er kaufen soll.
tags: [claude-code, skills, aktien, vergleich, bewertung]
---

# Zwei Aktien im direkten Vergleich

Stellt zwei Aktien systematisch nebeneinander und kommt zu einer klaren Entscheidung, welche die stärkere Wahl ist — abhängig vom Anlegerprofil des Nutzers.

## Ablauf

1. **Parameter klären**, falls nicht genannt:
   - Beide Ticker/Unternehmen
   - Anlegerprofil: Growth, Income (Ertrag) oder Value
   - Zeithorizont: kurz-, mittel- oder langfristig
2. **Aktuelle Daten nutzen**, wenn Web-Zugriff verfügbar ist. Sonst transparent machen, dass die Zahlen auf dem eigenen Wissensstand basieren.
3. **Vergleich strukturieren** wie unten — jede Dimension für beide Aktien nebeneinander, nicht nacheinander getrennt.

## Output-Struktur

```
# [Aktie A] vs. [Aktie B] — Vergleich für [Profil]-Anleger ([Zeithorizont])

## Bewertung
[Aktie A]: ... | [Aktie B]: ... — wer ist relativ günstiger/teurer und warum

## Wachstumspfad
[Aktie A]: ... | [Aktie B]: ... — Wachstumstempo, Nachhaltigkeit, Treiber

## Finanzielle Gesundheit
[Aktie A]: ... | [Aktie B]: ... — Bilanz, Cashflow, Profitabilität

## Wettbewerbsmoat
[Aktie A]: ... | [Aktie B]: ... — Marktposition, Burggraben, Risiken

## Verdikt: Wer ist der stärkere Kauf?
Klare Entscheidung für [Aktie A] oder [Aktie B] speziell für das genannte
Profil und den Zeithorizont — mit den 2-3 entscheidenden Gründen und
unter welchen Umständen die andere Aktie die bessere Wahl wäre
```

## Wichtig

Die Entscheidung muss zum genannten Anlegerprofil und Zeithorizont passen — ein Income-Anleger mit kurzem Horizont braucht eine andere Antwort als ein Growth-Anleger mit zehn Jahren Zeit, selbst bei denselben zwei Aktien. Schließe mit dem Hinweis ab, dass dies keine individuelle Anlageberatung ersetzt.
