---
name: loopsystem
description: Führt den kompletten Claude-Loop durch — plant eine Aufgabe detailliert, delegiert die Umsetzung Schritt für Schritt an den günstigen executor-Subagent (Haiku), prüft jedes Ergebnis gegen den Plan und schickt bei Abweichungen konkrete Korrekturen zurück, statt selbst zu tippen. Schont so das Nutzungslimit des Top-Modells. Nutze diesen Skill, wenn der Nutzer "starte den Loop", "loop das durch", "/loopsystem", "delegier das an den Executor" sagt, oder eine größere, mehrschrittige Aufgabe (Code-Refactoring, Content-Serie, Recherche über viele Quellen, Aufräumarbeiten) durchgehen soll, ohne dass das Top-Modell die Routinearbeit selbst erledigt. Nicht für triviale Ein-Satz-Aufgaben — dort lohnt der Delegations-Overhead nicht.
tags: [claude-code, skills, orchestration, workflow, subagents, delegation]
---

# Loopsystem

Arbeitsprinzip: Das Top-Modell (du) plant und prüft, der `executor`-Subagent (Haiku) setzt um. Routinearbeit gehört nie ins teuerste Modell — nur Planung und Abnahme.

Voraussetzung: `~/.claude/agents/executor.md` muss existieren (Nutzer-Ebene, `model: haiku`). Ist die Datei nicht vorhanden, sag das dem Nutzer und biete an, sie zuerst anzulegen, statt den Loop ohne Executor zu versuchen.

## Ablauf

### 1. Planer-Phase — nichts umsetzen

Zerlege die Aufgabe des Nutzers in einen **detaillierten, nummerierten Schritt-Plan**. In dieser Phase selbst noch nichts bauen, schreiben oder ändern — nur planen. Ein guter Plan ist konkret genug, dass der Executor ihn ohne eigene Interpretation umsetzen kann: klare Dateipfade, klare Kriterien, klare Reihenfolge.

### 2. Delegations-Phase

Übergib den Plan **Schritt für Schritt** an den `executor`-Subagent:
- `Agent`-Tool, `subagent_type: "executor"`, `run_in_background: false` (das Ergebnis wird sofort gebraucht, um zu prüfen, bevor der nächste Schritt losgeht).
- Jeder Aufruf bekommt den relevanten Planschritt (oder eine zusammenhängende Gruppe von Schritten) plus genug Kontext, um ihn ohne Rückfragen an dich umzusetzen — der Executor kennt dieses Gespräch nicht.

### 3. Prüf-Phase

Nach jedem Schritt: Ergebnis gegen den Plan checken.
- Passt es: weiter zum nächsten Schritt.
- Passt es nicht, oder der Executor meldet eine offene Frage/Abweichung: schick ihn mit einer **konkreten Korrekturanweisung** zurück (kein neuer Plan — eine gezielte Anweisung, was genau zu ändern ist). Wiederhole, bis der Schritt passt.

### 4. Abschluss

Melde dich erst zurück, wenn alle Schritte dem Plan entsprechen. Fasse kurz zusammen, was umgesetzt wurde.

Schlage danach **eine messbare `/goal`-Bedingung** vor, passend zur gerade erledigten Art von Aufgabe (für den Fall, dass der Nutzer eine ähnliche Aufgabenserie mit `/goal` automatisieren will). Eine gute Bedingung ist:
- **messbar**: ein klarer Endzustand, kein "gut genug" — z. B. "alle Tests laufen fehlerfrei durch", "die Liste offener Punkte ist leer", "alle N Varianten sind geprüft".
- **aus deiner eigenen Ausgabe erkennbar**: das Prüfmodell hinter `/goal` liest nur den Gesprächsverlauf, führt nichts aus — die Bedingung muss also an etwas hängen, das du selbst zeigen kannst (Testergebnis, Abnahme-Zusammenfassung).
- mit **harten Grenzen**, wo sinnvoll — z. B. "keine Datei außerhalb von [Ordner] verändern".

Biete an, die Bedingung mit `/goal <Bedingung>` zu setzen, statt sie automatisch selbst zu setzen — schwammige oder falsch geratene Ziele können sonst zu Endlosschleifen führen.

## Grenzen

- Kein Plan-Bau *während* der Delegation — Plan zuerst fertig, dann erst delegieren.
- Keine großen, vagen Chunks an den Executor geben ("mach das ganze Projekt") — je kleinteiliger und eindeutiger der einzelne Schritt, desto zuverlässiger die Umsetzung auf Haiku.
- Skaliert der Executor an einem Schritt wiederholt ab (Ergebnis passt trotz präziser Korrektur mehrfach nicht), das dem Nutzer sagen und einen Wechsel auf `model: sonnet` in `~/.claude/agents/executor.md` vorschlagen, statt endlos nachzukorrigieren.

Siehe [PROMPTS.md](PROMPTS.md) für die Original-Prompts aus dem Guide zum manuellen Copy-Paste, falls der Loop nicht über diesen Skill, sondern von Hand gefahren werden soll.
