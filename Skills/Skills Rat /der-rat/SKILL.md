---
name: der-rat
description: Beruft einen Rat aus 5 unabhängigen KI-Beratern (Gegenredner, Erste-Prinzipien-Denker, Expansionist, Außenseiter, Umsetzer) ein, lässt deren Antworten von 5 Peer-Review-Agenten gegenprüfen und fasst alles zu einem finalen Urteil zusammen. Nutze diesen Skill, wenn der Nutzer "Frage den Rat", "den Rat einberufen" sagt, oder eine wichtige Entscheidung/Frage aus möglichst vielen unabhängigen Blickwinkeln geprüft haben möchte, bevor er eine Antwort für bare Münze nimmt.
tags: [claude-code, skills, multi-agent, entscheidungshilfe, peer-review]
---

# Der Rat

Claude liegt bei einem nennenswerten Anteil offener Fragen falsch oder zu selbstsicher — eine einzelne, unreflektierte Antwort verdeckt das. Dieser Skill erzwingt stattdessen ein strukturiertes, adversariales Mehrperspektiven-Verfahren mit echten, unabhängigen Subagenten: 5 Berater mit gegensätzlichen Aufträgen, 5 Peer-Reviewer, die sich gegenseitig nicht kennen, und ein Vorsitzender, der alles zu einem Urteil verdichtet.

Dies ist ein bewusst aufwändiges Verfahren (bis zu 10 Subagenten-Aufrufe). Es ist für Fragen gedacht, die eine echte Prüfung verdienen — Entscheidungen, Strategien, Bewertungen, "habe ich das richtig durchdacht?" — nicht für triviale Nachfragen. Wenn der Nutzer den Skill triggert, direkt loslegen, ohne vorher um Erlaubnis zu fragen.

## Ablauf

### Schritt 0 — Den Fall erfassen

Fasse die eigentliche Frage/Entscheidung des Nutzers in 1-3 prägnanten, neutralen Sätzen zusammen — das ist der **Fall**, der dem Rat vorgelegt wird. Nur nachfragen, wenn die Frage tatsächlich mehrdeutig ist; die meisten Fälle sind selbsterklärend.

Formuliere zusätzlich eine **kontextfreie Kurzfassung** des Falls: ein neutraler Satz ohne Hintergrund, ohne Vorgeschichte, ohne Meinung, ohne Hinweis darauf, was der Nutzer sich erhofft. Diese Kurzfassung bekommt ausschließlich der Außenseiter (Schritt 1).

### Schritt 1 — 5 Berater parallel einberufen

Starte **5 `Agent`-Aufrufe in einer einzigen Nachricht** (echte Parallelität), jeweils `subagent_type: "general-purpose"`, `run_in_background: false` (die Ergebnisse werden für Schritt 2 gebraucht). Jeder Berater bekommt eine eigene, in sich geschlossene Prompt — er kennt die anderen Berater nicht.

Verwende diese Persona-Aufträge wörtlich (Platzhalter `[FALL]` = Schritt-0-Zusammenfassung, `[FALL-KONTEXTFREI]` = kontextfreie Kurzfassung):

1. **Gegenredner**
   > Du bist der Gegenredner in einem Beratergremium. Deine einzige Aufgabe: finde die Schwachstellen. Fall: [FALL]. Suche gezielt nach falschen Annahmen, übersehenen Risiken, Gegenargumenten und allem, was bei genauerem Hinsehen nicht standhält. Du darfst nicht zustimmen oder beschwichtigen — wenn du wirklich nichts findest, sag das explizit und begründe warum. Antworte in unter 250 Wörtern mit einer klaren Kernaussage.

2. **Erste-Prinzipien-Denker**
   > Du bist der Erste-Prinzipien-Denker in einem Beratergremium. Ignoriere bewusst die Oberflächenfrage. Fall (wie gestellt): [FALL]. Deine Aufgabe: leite aus den Grundtatsachen ab, welches *eigentliche* Problem dahintersteckt, das der Nutzer eigentlich lösen will — und beantworte dieses, auch wenn es von der gestellten Frage abweicht. Antworte in unter 250 Wörtern mit einer klaren Kernaussage.

3. **Expansionist**
   > Du bist der Expansionist in einem Beratergremium. Fall: [FALL]. Deine Aufgabe: zeige Chancen, Potenziale und Handlungsspielräume auf, die im Fall nicht erwähnt sind oder übersehen werden könnten — größere Optionen, nicht nur Detailoptimierung. Antworte in unter 250 Wörtern mit einer klaren Kernaussage.

4. **Außenseiter**
   > Du bekommst absichtlich keinen Hintergrund und keine Vorgeschichte — antworte rein auf Basis dessen, was hier steht: [FALL-KONTEXTFREI]. Gib deine spontane, naive Ersteinschätzung. Was fällt dir als Außenstehendem sofort auf, das jemand mittendrin vielleicht übersieht? Antworte in unter 200 Wörtern.

5. **Umsetzer**
   > Du bist der Umsetzer in einem Beratergremium. Fall: [FALL]. Ignoriere tiefere Analyse — dein einziger Fokus: was soll der Nutzer als Nächstes konkret tun? Liste die nächsten Schritte, in Reihenfolge, so konkret wie möglich. Antworte in unter 200 Wörtern.

**Wichtig für den Außenseiter:** Baue [FALL-KONTEXTFREI] so, dass die Prompt selbst keine Zusatzinformationen, Meinungen oder Rahmung enthält, die im Fall nicht ohnehin stünden. Der Subagent hat ohnehin kein Gedächtnis der Konversation — die Disziplin liegt darin, ihm nicht versehentlich über die Formulierung der Prompt Kontext oder Vorurteile mitzugeben.

Sammle alle 5 Antworten.

### Schritt 2 — 5 Peer-Review-Agenten parallel

Starte **5 weitere `Agent`-Aufrufe in einer einzigen Nachricht**, gleiche Einstellungen wie oben. Jeder Reviewer bekommt: den Fall + alle 5 Beraterantworten, aber **anonymisiert als "Berater A–E"** (nicht mit Rollennamen wie "Gegenredner"), damit nicht nach Rolle statt nach Inhalt geurteilt wird.

Prompt-Vorlage für jeden der 5 Reviewer (identisch, unabhängig voneinander gestartet):

> Du bist unabhängiger Peer-Reviewer für ein Beratergremium. Fall: [FALL]. Hier sind die Antworten von 5 Beratern (A-E): [ANTWORTEN A-E]. Prüfe kritisch: Faktenfehler, Logikbrüche, unbelegte Behauptungen, Widersprüche zwischen den Beratern, übersehene Gegenargumente. Nenne konkret, welchem Berater du in welchem Punkt widersprichst oder zustimmst. Sei skeptisch, nicht höflich. Antworte in unter 200 Wörtern als kurze Findings-Liste.

Fünf unabhängige Reviewer statt einem, weil ein Fehler, den mehrere Reviewer unabhängig voneinander aufgreifen, ein deutlich stärkeres Signal ist als die Einschätzung eines Einzelnen.

Sammle alle 5 Review-Ergebnisse.

### Schritt 3 — Vorsitzender (du selbst, kein Subagent)

Jetzt kein weiterer Agent-Aufruf mehr — du selbst bist der Vorsitzende. Lies alle 5 Beraterantworten und alle 5 Reviews und verdichte sie zu **einem** kohärenten Urteil:

- Löse Widersprüche auf, zähle sie nicht nur auf.
- Gewichte Punkte stärker, die von mehreren Reviewern unabhängig bestätigt wurden.
- Gib eine klare Empfehlung — kein "kommt darauf an" ohne Substanz.
- Benenne die größte verbleibende Unsicherheit und wodurch sich das Urteil ändern würde.

## Output-Struktur

```
# 🐀 Rat-Urteil: [Fall in einem Satz]

## Die 5 Berater (Kurzfassung)
- **Gegenredner:** …
- **Erste-Prinzipien-Denker:** …
- **Expansionist:** …
- **Außenseiter:** …
- **Umsetzer:** …

## Was die Peer-Review ergeben hat
Die wichtigsten Übereinstimmungen/Widersprüche, die mehrere Prüfer unabhängig gefunden haben.

## Urteil des Vorsitzenden
Klare, kompakte Empfehlung mit den 2-4 tragenden Gründen, der größten Unsicherheit/dem
größten Risiko, und (falls zutreffend) wodurch sich das Urteil ändern würde.
```

Schließe mit einem kurzen Hinweis ab, dass die vollständigen Einzelantworten der Berater und Reviewer auf Wunsch nachgereicht werden — standardmäßig nur die Kurzfassungen zeigen, damit die Antwort lesbar bleibt.
