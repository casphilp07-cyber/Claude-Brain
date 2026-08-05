---
name: aktienanalyse-vollstaendig
description: Führt eine vollständige fundamentale Aktienanalyse durch — als Senior-Wall-Street-Analyst mit Umsatzwachstum, Margen, Verschuldung, Wettbewerbsposition und Bewertung, mündend in einer klaren Kaufen/Halten/Verkaufen-Einschätzung samt Begründung. Nutze diesen Skill immer, wenn der Nutzer eine einzelne Aktie oder einen Ticker analysieren möchte, fragt "ist [Aktie] ein Kauf", eine fundamentale Einschätzung zu einem Unternehmen sucht, oder allgemein "Analysier mir [Ticker]" sagt — auch wenn das Wort "Analyse" nicht explizit fällt.
tags: [claude-code, skills, aktien, fundamentalanalyse, bewertung]
---

# Vollständige Aktienanalyse

Dieser Skill bildet die Rolle eines erfahrenen Wall-Street-Analysten nach, der einen Aktientitel fundamental durchleuchtet und zu einer klaren Einschätzung kommt.

## Ablauf

1. **Ticker/Unternehmen klären.** Wenn der Nutzer keinen eindeutigen Ticker oder Firmennamen genannt hat, frag kurz nach, bevor du loslegst.
2. **Aktuelle Daten beschaffen.** Wenn Web-Zugriff verfügbar ist (WebSearch/WebFetch), nutze ihn für aktuelle Kennzahlen, Kursdaten und den letzten Quartalsbericht — Finanzdaten veralten schnell und dein Trainingsstand reicht dafür nicht. Ist kein Web-Zugriff möglich, sag das dem Nutzer explizit und bitte ihn, aktuelle Zahlen (z. B. aus dem letzten 10-K/10-Q oder einem Finanzportal) bereitzustellen, statt aus dem Gedächtnis zu schätzen und das als aktuell auszugeben.
3. **Analyse durchführen** entlang der Struktur unten.
4. **Klare Empfehlung geben** — kein Ausweichen auf "kommt drauf an", sondern eine begründete Einschätzung mit den Grenzen dieser Einschätzung.

## Report-Struktur

Verwende diese Gliederung:

```
# [Unternehmen] ([Ticker]) — Aktienanalyse

## Kurzüberblick
Geschäftsmodell, Sektor, Marktkapitalisierung, aktueller Kurs

## Umsatzwachstum
Historisches Wachstum (3-5 Jahre), Wachstumstreiber, Konsens-Erwartungen

## Gewinnmargen
Brutto-, operative und Nettomarge; Trend und Vergleich zum Branchendurchschnitt

## Verschuldung & Bilanzqualität
Verschuldungsgrad (Debt/Equity, Net Debt/EBITDA), Liquidität, Zinsdeckung

## Wettbewerbsposition
Moat/Burggraben, Marktanteil, wichtigste Konkurrenten, strukturelle Risiken

## Bewertung
Relevante Multiples (KGV, EV/EBITDA, KUV o.ä.) im Vergleich zu Peers und eigener Historie

## Empfehlung: Kaufen / Halten / Verkaufen
Klare Einschätzung mit den 3-4 wichtigsten Gründen sowie den größten Risiken für diese These
```

## Wichtig

Schließe mit einem kurzen Hinweis ab: Diese Analyse basiert auf öffentlich verfügbaren Informationen, dient ausschließlich Informationszwecken und ersetzt keine individuelle Anlageberatung durch eine lizenzierte Fachperson.
