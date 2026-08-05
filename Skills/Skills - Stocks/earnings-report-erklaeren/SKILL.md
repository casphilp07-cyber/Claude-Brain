---
name: earnings-report-erklaeren
description: Übersetzt einen eingefügten Earnings-/Quartalsbericht in verständliche Sprache — was wurde geschlagen oder verfehlt, was signalisiert das Management für die Zukunft, und ob sich die Investment-These dadurch ändert. Nutze diesen Skill, wenn der Nutzer einen Earnings-Call, Quartalsbericht, eine Pressemitteilung zu Quartalszahlen oder ein Transkript einfügt/verlinkt und wissen will, was das bedeutet — auch bei Formulierungen wie "was heißt das für die Aktie" oder "hat [Firma] die Erwartungen geschlagen".
tags: [claude-code, skills, aktien, earnings, quartalsbericht]
---

# Earnings Report verständlich machen

Nimmt einen rohen Earnings-Report oder ein Transkript und übersetzt ihn in eine klare, handlungsorientierte Einschätzung.

## Ablauf

1. **Report/Transkript einfordern**, falls noch nicht eingefügt — ohne den tatsächlichen Text kann keine sinnvolle Analyse erfolgen.
2. **Konsens-Erwartungen einordnen.** Falls im Text keine Analysten-Konsensschätzungen enthalten sind und Web-Zugriff verfügbar ist, recherchiere sie kurz. Ohne Web-Zugriff transparent machen, dass der Vergleich auf den im Report selbst genannten Zahlen (Vorjahresvergleich, eigene Guidance) basiert.
3. **In der Struktur unten aufbereiten.**

## Output-Struktur

```
# [Unternehmen] — Earnings-Zusammenfassung Q[X] [Jahr]

## Kernzahlen auf einen Blick
Umsatz, EPS, Marge — jeweils tatsächlich vs. erwartet vs. Vorjahr

## Was hat überrascht (positiv)
Konkrete Punkte, die die Erwartungen übertroffen haben

## Was hat enttäuscht (negativ)
Konkrete Punkte, die verfehlt wurden oder Sorge bereiten

## Management-Ausblick
Was das Management für kommende Quartale signalisiert hat (Guidance,
Wortwahl im Call, strategische Ankündigungen) — inklusive Ton-Einschätzung
(optimistisch/vorsichtig/defensiv)

## Ändert das die Investment-These?
Ja/Nein/Teilweise — mit Begründung, was sich am Gesamtbild durch diesen
Bericht wirklich verändert hat gegenüber dem, was vorher schon bekannt war
```

## Wichtig

Unterscheide klar zwischen Fakten aus dem Report und deiner Interpretation. Vermeide es, kurze wörtliche Zitate aus dem Transkript ausgedehnt wiederzugeben — fasse in eigenen Worten zusammen.
