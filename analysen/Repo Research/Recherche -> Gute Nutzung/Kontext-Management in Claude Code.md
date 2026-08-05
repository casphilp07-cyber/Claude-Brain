---
name: Kontext-Management in Claude Code
description: Wie man das Kontextfenster in Claude-Code-Sessions gut managt — /compact vs. /clear, Handoff-Muster, proaktive Maßnahmen
tags: [claude-code, workflow, kontext, best-practices]
---

# Kontext-Management in Claude Code

Recherchiert am 01.08.2026 aus der offiziellen Doku (code.claude.com/docs/en/how-claude-code-works, .../costs), Anthropics Engineering-Blog ("Effective context engineering for AI agents") und aktuellen Community-Best-Practices.

## Was das Kontextfenster überhaupt füllt

Conversation-Verlauf, Dateiinhalte, Tool-Outputs (Befehls-/Suchergebnisse), `CLAUDE.md`, Auto Memory, geladene Skills und der System-Prompt. Alles zusammen ist eine **begrenzte Ressource** — Anthropics eigener Rat dazu: mehr Kontext ist nicht automatisch besser ("**Context Rot**"), Ziel ist, möglichst viel *relevantes* Signal und möglichst wenig Rauschen im Fenster zu haben, nicht möglichst viel Inhalt.

## Was Claude Code automatisch tut

Claude Code compact't selbstständig, sobald das Fenster voll wird: Es räumt zuerst **alte Tool-Outputs** weg, fasst danach bei Bedarf den **Gesprächsverlauf** zusammen. Deine Anfragen und wichtige Code-Snippets bleiben erhalten, aber **Anweisungen von früh im Gespräch können verloren gehen**. Konsequenz: dauerhafte Regeln gehören ins `CLAUDE.md`, nicht in eine Nachricht mitten im Chat — die überlebt eine Auto-Compaction zuverlässig, eine Chat-Anweisung nicht unbedingt.

## `/compact` vs. `/clear` — der Kernunterschied

| | `/compact` | `/clear` |
|---|---|---|
| **Was passiert** | Claude fasst den bisherigen Verlauf zusammen, ersetzt ihn durch die Zusammenfassung | Kompletter Reset, keine Historie mehr |
| **Kontinuität** | Ja — verlustbehaftet, aber Kontext bleibt grundsätzlich erhalten | Nein — komplett frischer Start |
| **Kosten** | Kostet selbst etwas (liest den ganzen Verlauf, um ihn zusammenzufassen) | Kostenlos |
| **Wann sinnvoll** | Gleiches Thema, Kontext wird eng, du willst weiterarbeiten | Wechsel zu einem unabhängigen Thema/Task |
| **Steuerbar?** | Ja, mit Fokus-Anweisung: `/compact focus on the API changes` | — |

**Faustregel aus der Praxis:** lieber bei ~60% Kontext-Auslastung compacten als bei 90% (je voller, desto verlustbehafteter/teurer die Zusammenfassung). Mit `/context` siehst du jederzeit, was wie viel Platz belegt; die Statusline lässt sich so konfigurieren, dass die Kontext-Auslastung dauerhaft sichtbar ist.

## Das Handoff-Muster (neuer Chat statt `/compact`)

Für längere/mehrtägige Projekte oder wenn eine Session in eine falsche Richtung gelaufen ist, ist ein **manueller Handoff oft besser als `/compact`**: Bevor du schließt oder das Thema wechselst, lässt du Claude einen kurzen **Handoff-Brief** schreiben — was gebaut wurde, was noch offen ist, welche Constraints gelten, welche Dateien relevant sind. Dieser Brief landet z.B.:

- direkt im `CLAUDE.md` des Projekts,
- als Scratch-Datei im Repo (`HANDOFF.md`, `.claude/notes/...`),
- oder einfach in die Zwischenablage kopiert.

In der nächsten Session fügst du den Brief ein und nennst die nächste Aufgabe — Claude hat den vollen relevanten Kontext, ohne das "Rauschen" der alten Session (fehlgeschlagene Versuche, Nebendiskussionen, veraltete Zwischenstände) mitzuschleppen.

**`/compact` vs. Handoff+neue Session — wann was:**
- `/compact`: schnell, automatisch, gut wenn die Session insgesamt noch "sauber" ist und einfach nur voll wird
- Handoff + `/clear`/neue Session: mehr Aufwand (Brief schreiben/prüfen), aber du kontrollierst explizit, was übernommen wird — besser, wenn die Session unübersichtlich geworden ist, viele Sackgassen enthält, oder das Projekt sich über mehrere Tage zieht

## Proaktive Maßnahmen, damit es gar nicht erst eng wird

- **Subagenten nutzen** für lautstarke Recherche/Log-Analyse/Testläufe — sie laufen in einem eigenen, isolierten Kontextfenster und liefern nur die Zusammenfassung zurück in die Haupt-Session
- **Skills statt langem `CLAUDE.md`** für Detail-Workflows — Skills laden nur bei Bedarf, `CLAUDE.md` wird dagegen bei jeder Session komplett geladen (Anthropics Richtwert: unter 200 Zeilen halten)
- **Hooks zum Vorfiltern** lauter Tool-Outputs (z.B. ein `PreToolUse`-Hook, der bei Testläufen nur die Fehlerzeilen statt des kompletten Logs durchreicht)
- **Ungenutzte MCP-Server deaktivieren** (`/mcp`) und wo möglich CLI-Tools (`gh`, `aws`, …) bevorzugen — die belegen keinen Tool-Listing-Platz im Kontext
- **Früh korrigieren statt spät reparieren:** `Esc` (stoppt sofort) oder doppeltes `Esc`/`/rewind` (Checkpoint zurückspulen), sobald Claude in die falsche Richtung läuft — verhindert, dass sich Fehlkontext erst aufbaut und später teuer wegcompactet werden muss
- Plan-Modus für komplexe Aufgaben nutzen (`Shift+Tab` zweimal) — erst recherchieren/planen lassen, dann erst umsetzen, spart Kontext durch weniger Fehlversuche

## Konkrete Entscheidungshilfe

| Situation | Empfehlung |
|---|---|
| Gleiches Thema, Kontext wird langsam eng | `/compact` (mit Fokus-Anweisung, was wichtig ist) |
| Neues, unabhängiges Thema/Task beginnt | `/clear` |
| Session ist unübersichtlich/viele Sackgassen | Handoff-Brief schreiben lassen → `/clear` → mit Brief neu starten |
| Komplexes Projekt über mehrere Tage/Sessions | Laufende Handoff-/Progress-Notiz im Repo pflegen, jede Session damit beginnen und beenden, statt endlos in einer Session zu compacten |
| Wiederkehrende große Recherche-/Log-Aufgabe innerhalb einer Session | An einen Subagenten delegieren statt im Hauptkontext zu verarbeiten |
