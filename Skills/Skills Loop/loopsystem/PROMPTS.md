---
tags: [claude-code, loopsystem, prompts, referenz]
---

# Loopsystem — Prompt-Sammlung

Original-Prompts aus dem Guide "Das Claude-Loopsystem" (@GPTMarlon, Stand Juli 2026) zum manuellen Copy-Paste, falls der Loop nicht über den `/loopsystem`-Skill, sondern von Hand gefahren werden soll.

## Prompt 01 — Executor-Subagent erstellen

Bereits erledigt: `~/.claude/agents/executor.md` existiert (Nutzer-Ebene, `model: haiku`). Nur zur Referenz, falls der Executor mal neu aufgesetzt werden muss:

> Erstelle mir einen Subagent namens "executor", der auf dem Modell Haiku läuft.
> Seine Aufgabe: Er bekommt einen fertigen, detaillierten Plan und setzt ihn exakt um, Schritt für Schritt. Er trifft keine eigenen Entscheidungen, die nicht im Plan stehen. Ist etwas im Plan unklar, notiert er die offene Frage, statt zu raten. Am Ende fasst er kurz zusammen, was er umgesetzt hat und wo er vom Plan abweichen musste.

## Prompt 02 — Der Loop-Prompt

Für eine einzelne Aufgabe, ohne den Skill zu triggern:

> Schreib zuerst einen detaillierten Plan für folgende Aufgabe: [DEINE AUFGABE].
> Baue in dieser Phase noch nichts. Wenn der Plan steht, übergib ihn Schritt für Schritt an den executor-Subagent. Prüfe nach jedem Schritt selbst das Ergebnis gegen den Plan. Wenn etwas fehlt oder nicht passt, schick den executor mit konkreten Korrekturanweisungen noch einmal los. Melde dich erst zurück, wenn alles dem Plan entspricht.

## Prompt 03 — Ziel setzen (`/goal`)

Beispiel:

> `/goal` Alle Schritte aus dem Plan sind umgesetzt und vom Hauptmodell geprüft. Es gibt keine offenen Korrekturanweisungen mehr, und es wurden nur die im Plan genannten Dateien verändert.

**So schreibst du eine gute Bedingung:**
- Ein **messbarer Endzustand** — „alle Tests laufen fehlerfrei durch", „alle 20 Hooks sind geprüft", „die Liste offener Punkte ist leer" — nicht „mach es richtig gut".
- Ein **Nachweis, den Claude selbst zeigen kann** — das Prüfmodell liest nur den Gesprächsverlauf, führt selbst nichts aus. Die Bedingung muss also aus Claudes eigener Ausgabe erkennbar sein (Testergebnis, Abnahme-Zusammenfassung).
- **Grenzen, die nicht gerissen werden dürfen** — z. B. „keine Datei außerhalb des Projektordners verändern".

**Steuerung:**
- `/goal` ohne Text → Status (bisherige Runden, Verbrauch).
- `/goal clear` → Schleife sofort stoppen.
- Ziel erreicht → löscht sich von selbst.

## Quick-Reference — Selbst prüfen, ob alles steht

1. Liegt `~/.claude/agents/executor.md` vor, mit der Zeile `model: haiku`?
2. Reagiert `/goal` in deiner Claude-Code-Version? (Falls nicht: `claude update`, ab Version 2.1.139 nötig.)
3. Testlauf mit einer kleinen Aufgabe: Delegiert das Top-Modell sichtbar an den Executor, statt selbst zu tippen?

Wenn ja bei allen dreien: das Loopsystem steht.

## Drei Regeln für sparsame Loops

- Bedingung messbar formulieren — verhindert Extrarunden, die nichts bringen.
- Zwischendurch `/goal` tippen und Runden plus Verbrauch checken. Läuft etwas aus dem Ruder: `/goal clear`.
- Das Top-Modell nie selbst tippen lassen. Sobald das Hauptmodell merkt, dass es Routinearbeit selbst erledigt: zurück zum Loop-Prompt.

## Wofür sich das System eignet

- **Code:** Refactorings oder Bugfixes, bis alle Tests fehlerfrei durchlaufen.
- **Content:** Skript- und Hook-Produktion in Serie — planen, ausformulieren lassen, streng aussieben.
- **Recherche:** viele Quellen sichten und zusammenfassen lassen, das Top-Modell zieht daraus das Fazit.
- **Aufräumarbeiten:** Dateien umbenennen, Strukturen vereinheitlichen, Listen abarbeiten, bis die Liste leer ist.
