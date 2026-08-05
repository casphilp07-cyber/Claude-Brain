---
name: eu-ai-act-check
description: Prüft ein AI-Projekt/Produkt vor der Veröffentlichung gegen den EU AI Act (Verordnung (EU) 2024/1689) — Rollen-Klassifikation, verbotene Praktiken, High-Risk-Einstufung, Transparenz- und GPAI-Pflichten. Nutze diesen Skill, wenn der Nutzer ein Projekt auf EU AI Act Konformität checken will, fragt ob eine KI-Funktion in der EU erlaubt ist, oder vor einem Launch rechtliche Risiken rund um KI-Regulierung abklären will.
tags: [claude-code, skills, eu-ai-act, compliance, recht, ki-regulierung]
---

# EU AI Act Compliance-Check

Systematischer Check eines AI-Projekts gegen die EU-KI-Verordnung (2024/1689), bevor es veröffentlicht wird. Deckt den gesamten Act ab — unabhängig davon, welche Stufe des gestaffelten Zeitplans gerade formal in Kraft ist (siehe Hinweis unten). Detailwissen liegt in `references/*.md` und wird nur bei Bedarf nachgeladen, um den Kontext schlank zu halten.

**Kein Ersatz für Rechtsberatung.** Dieser Skill gibt eine strukturierte Ersteinschätzung, keine Rechtsauskunft. Bei Treffern in "verbotene Praktiken", High-Risk oder systemischem GPAI-Risiko: im Output explizit auf professionelle Rechtsberatung hinweisen.

## Grundprinzip: kein zeitliches Filtern

Der Skill prüft immer gegen den **vollständigen** Pflichtenkatalog des Acts, nicht nur gegen das, was zum aktuellen Datum bereits scharf gestellt ist. Wer nur die heute geltenden Pflichten erfüllt, muss kurz danach nachbessern, sobald die nächste Stufe des gestaffelten Zeitplans greift (z.B. Annex-I-High-Risk-Pflichten ab 2. Aug 2027). `references/penalties-timeline.md` enthält die Fristen-Tabelle nur als Hintergrundinfo für die Bußgeld-Einordnung — nicht als Filter.

## Ablauf

### 1. Projekt erfassen
Im Dialog klären:
- Was macht das System, welche Funktionen hat es konkret?
- Wer sind die Nutzer, insbesondere: gibt es EU-Nutzer bzw. wird die Ausgabe in der EU verwendet?
- Wird ein fremdes Modell per API eingebunden (Claude, OpenAI, etc.) oder ein eigenes Modell trainiert/fine-getuned?
- Gibt es sensible Use-Cases: Biometrie, Emotionserkennung, Scoring/Bewertung von Personen, Recruiting/Personalentscheidungen, Kreditwürdigkeit/Versicherung, Strafverfolgung, Bildung/Prüfungen, kritische Infrastruktur, Justiz/Wahlen?

Nicht alle Fragen müssen vorab gestellt werden — reicht auch, aus einer Projektbeschreibung zu extrahieren und gezielt nachzufragen, wo es unklar ist.

### 2. Rolle(n) klären
Bei Unsicherheit `references/definitions.md` laden. Provider, Deployer und GPAI-Provider schließen sich nicht aus — ein Projekt kann mehrere Rollen gleichzeitig einnehmen (z.B. Deployer der fremden API, aber Provider des eigenen Endprodukts). Im Zweifel eher zu viele Rollen als zu wenige annehmen.

### 3. Scope-Check
Ausnahmen prüfen (Art. 2): Militär/Verteidigung/nationale Sicherheit, reine wissenschaftliche F&E vor Markteinführung, rein private nicht-berufliche Nutzung, Open-Source-Systeme (mit Rück-Ausnahme bei systemischem Risiko oder falls Art. 5/50 greifen). Falls eine Ausnahme eindeutig greift: als "außerhalb des Anwendungsbereichs" markieren und kurz begründen — Check kann trotzdem mit den übrigen Schritten fortgesetzt werden, falls Teile des Projekts nicht unter die Ausnahme fallen.

### 4. Verbotene Praktiken screenen
`references/prohibited-practices.md` laden, gegen alle 8 Kategorien (Art. 5 a-h) prüfen. **Bei Treffer: harter Stopp.** Klar als Blocker kennzeichnen, Bußgeldrahmen aus `references/penalties-timeline.md` nennen, keine Abschwächung vorschlagen außer vollständigem Redesign der betroffenen Funktion.

### 5. High-Risk-Klassifikation
`references/high-risk-classification.md` laden. Gegen Annex-III-Kategorien (und ggf. Annex I bei Hardware-Bezug) prüfen, Art.-6(3)-Ausnahmen und den Profiling-Override anwenden.

### 6. Falls High-Risk: Pflichten-Checkliste
`references/high-risk-obligations.md` laden, passende Pflichten für jede identifizierte Rolle (Provider/Deployer/Importeur/Distributor) ausgeben, inkl. FRIA-Pflicht (Art. 27) falls einschlägig.

### 7. Transparenzpflichten prüfen
`references/transparency-obligations.md` laden — **unabhängig vom Risk-Tier**, gilt auch für minimal-risk Systeme. Chatbot-Kennzeichnung, Deepfake/KI-Content-Labeling, Emotionserkennungs-Hinweis.

### 8. GPAI-Check
Nur falls ein eigenes Modell trainiert/fine-getuned wird (nicht bei reiner API-Nutzung): `references/gpai-obligations.md` laden, Systemic-Risk-Schwelle (10^25 FLOPs) und Open-Source-Ausnahmen anwenden.

### 9. Bußgelder benennen
`references/penalties-timeline.md` laden, um bei jedem Treffer aus Schritt 4/6/8 das konkrete Bußgeldrisiko zu beziffern.

### 10. Output
Strukturierter Bericht mit:
- **Rollen-Einordnung** (Provider/Deployer/GPAI-Provider, mit Begründung)
- **Risiko-Einstufung** (verboten / High-Risk / limited-risk-transparenzpflichtig / minimal-risk / GPAI)
- **Harte Blocker** (falls vorhanden) — an erster Stelle, unübersehbar
- **Pflichten-Checkliste** nach Rolle und Kategorie sortiert, mit Artikel-Referenzen
- **Bußgeldrisiko** bei Nichteinhaltung
- **Nächste Schritte** (z.B. FRIA durchführen, Konformitätsbewertung, Dokumentation aufbauen)
- **Disclaimer**: keine Rechtsberatung; bei High-Risk-, Verbots- oder Systemic-Risk-Treffern echten Rechtsbeistand hinzuziehen, insbesondere vor tatsächlicher Veröffentlichung
