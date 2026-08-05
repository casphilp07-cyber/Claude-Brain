---
name: bot-strategie-backtest
description: Backtestet alle 5 Live-Strategien des AlgoEdge-Trading-Bots (Repo /Users/caspar/Desktop/Trading-bot) über ALLE Kerzenframes gleichberechtigt — 1h, 4h, 1d, 1wk, 1mo — und liefert eine Rangliste der besten 5-10 Kombinationen direkt im Chat als Tabelle, ohne Datei zu erstellen. Nutze diesen Skill immer, wenn Caspar fragt, welche Strategie/Kerzenframe-Kombination gerade am besten performt, ihn bittet "die Strategien zu backtesten", "einen Strategie-Vergleich zu machen", "zu schauen was aktuell am besten läuft" oder allgemein eine aktuelle Standortbestimmung für den Bot will — auch wenn er nicht explizit "Backtest" sagt. Läuft auf echten Yahoo-Marktdaten (keine Simulation/Meinung), Ergebnis ändert sich mit der Zeit — bei jeder Anfrage neu ausführen, nicht aus dem Gedächtnis beantworten.
tags: [claude-code, skills, trading-bot, algoedge, backtest, strategie]
---

# Strategie-Backtest über alle Kerzenframes

Führt die echten Backtest-Tools des Trading-Bots aus (keine Schätzung, kein
Nachbau der Logik) und rankt, welche der 5 Live-Strategien auf welchem
Kerzenframe gerade am besten abschneidet.

**Wichtig zur Neutralität:** `golden_cross_50_200` ist aktuell die im Bot
konfigurierte Live-Strategie (`STRATEGIE_AKTIEN` in `algoedge/config.py`).
Das darf das Ergebnis nicht beeinflussen — berichte was die Zahlen zeigen,
auch wenn eine andere Strategie/Kerzenframe-Kombination besser abschneidet.
Der ganze Sinn dieses Backtests ist es, das ehrlich herauszufinden statt die
bestehende Wahl zu bestätigen.

## Die 5 Kerzenframes sind gleichberechtigt

Es gibt **fünf** testbare Kerzenframes, nicht drei: **1h, 4h, 1d, 1wk, 1mo**.
1h/4h sind kein optionaler Zusatz und keine Fußnote — sie sind ein
vollwertiger Teil von "alles mögliche testen". Führe immer alle fünf aus,
außer Caspar schränkt selbst explizit ein (z. B. "nur auf Daily").

## Ablauf

### 1. Ins Repo wechseln und Cache prüfen

```bash
cd /Users/caspar/Desktop/Trading-bot
ls backtest_results/ohlcv_beides_10y.json 2>/dev/null && echo "Daily-Cache vorhanden"
```

Falls die Datei fehlt: `python3 backtest_stocks.py` einmal ohne Argumente
laufen lassen (lädt und cached 10 Jahre Daily-Daten für alle 304 Ticker via
Yahoo — dauert beim allerersten Mal ca. 1-2 Minuten, danach ist alles
gecached und jeder weitere Aufruf ist schnell). Für 1h/4h gibt es eigene,
separate Caches — die holt sich jeder der folgenden Befehle bei Bedarf
automatisch selbst (auch das kann beim ersten Mal ein paar Minuten dauern,
weil 304 Ticker einzeln von Yahoo geholt werden müssen).

### 2. Alle drei Tool-Aufrufe ausführen

```bash
python3 backtest_stocks_multiframe.py --universe beides
python3 backtest_stocks.py --interval 4h --universe beides
python3 backtest_stocks.py --interval 1h --universe beides
```

- Der erste Befehl deckt **1d, 1wk, 1mo** ab (intern aus den 10-Jahres-Daily-
  Kerzen resampelt) × bis zu drei Zeitfenster (volle 10y, 5y, 3y) und schreibt
  `backtest_results/multiframe_sweep_beides.json`.
- Die beiden `--interval`-Aufrufe decken **4h und 1h** ab (echte Intraday-
  Kerzen, Yahoo-Limit ~730 Tage) und schreiben je ein
  `backtest_results/t212_lab_beides_{interval}_730d.json`.
- Alle drei Befehle geben zusätzlich eine Tabelle auf stdout aus — die JSON-
  Dateien sind aber die verlässlichere Quelle zum Parsen (exakte Zahlen,
  keine Rundungs-/Spalten-Fehler).
- Alle drei laufen mit multiprocessing und geben dabei viel `Signal-Fehler`/
  `Exit-Check-Fehler`-Rauschen auf stderr aus (bekannte, harmlose Randfälle
  bei sehr kurzen Kerzen-Fenstern). Das ist kein Problem und keine
  Fehlschlagsmeldung — beim Lesen der Konsolen-Ausgabe einfach ignorieren,
  z. B. mit `2>&1 | grep -v "Signal-Fehler\|Exit-Check-Fehler"`.
- Erwarte insgesamt ein paar Minuten Laufzeit, mehr beim allerersten Mal
  (Datenabruf) als bei Wiederholungen (dann greifen die Caches). Sag Caspar
  kurz Bescheid, dass das läuft, statt stumm zu warten.

### 3. Alle Kombinationen zu EINER Liste zusammenführen

Aus `multiframe_sweep_beides.json` das `"report"`-Dict lesen: Keys sind
`"strategie|tf|window"` (z. B. `"golden_cross_50_200|1d|full_10y"`), Values
enthalten `ticker`, `trades`, `mean_return`, `median_return`,
`pct_profitabel`, `win_rate`, `profit_factor`, `mean_max_dd`,
`pct_schlaegt_bh`. Jeder Key wird eine Zeile: Frame = `tf`, Zeitraum =
`window`.

Aus jedem `t212_lab_beides_{interval}_730d.json` das `"report"`-Dict lesen:
Keys sind hier nur der Strategie-Name (ein Interval pro Datei), Values
enthalten dieselben Felder (`ticker`, `trades`, `mean_return`, ...). Jeder
Key wird eine Zeile: Frame = `1h` bzw. `4h`, Zeitraum = `730d`.

Am Ende hast du eine flache Liste von bis zu ~45 Zeilen (5 Strategien ×
[3 Fenster auf 1d + 3 auf 1wk + 1 auf 1mo + 1 auf 4h + 1 auf 1h]).

### 4. Filtern — kleine Stichproben nicht verschweigen, aber auch nicht ranken

Eine Kombination ist **nicht rankingfähig**, wenn `trades < 30` ODER
`ticker < 15`. Das kommt strukturell vor (z. B. liefert die SMA200-Familie
auf Monatskerzen 0 Trades, weil sie 200+ Bars Vorlauf braucht und die
10-Jahres-Daily-Grenze von Yahoo das auf Monatsbasis nicht hergibt — das ist
eine Datengrenze, kein Bug). Warum das wichtig ist: eine Kombination mit z. B.
3 Trades kann durch einen einzigen Glückstreffer eine absurd hohe MeanRet%
zeigen, die nichts mit einer echten Strategie-Qualität zu tun hat — sie
würde das Ranking verfälschen, wenn sie mitzählt.

Zeige diese ausgeschlossenen Kombinationen trotzdem transparent (kurz, z. B.
eine Zeile "X Kombinationen wegen zu kleiner Stichprobe ausgeschlossen,
darunter alle SMA200-Familie/Monat") — nicht einfach stillschweigend
weglassen.

### 5. Ranken und Top 5-10 ausgeben

Sortiere die verbleibenden (rankingfähigen) Kombinationen nach `mean_return`
absteigend. Nimm die Top 5-10 (10 wenn die Datenlage das hergibt, sonst
weniger — lieber eine ehrliche kürzere Liste als aufgefüllte Zeilen mit
kaum aussagekräftigem Unterschied).

## Output — NUR eine Tabelle im Chat, keine Datei

Das ist eine explizite Anforderung: kein Artefakt, kein `.md`/`.json`-File
anlegen, keine Datei schreiben, die über die eh schon vom Backtest-Tool
erzeugten Cache-Dateien hinausgeht. Die Antwort ist die Chat-Nachricht
selbst. Format:

```
| # | Strategie | Frame | Zeitraum | Ticker | Trades | Ø Return | Win-Rate | PF | Max-DD |
|---|-----------|-------|----------|-------:|-------:|---------:|---------:|---:|-------:|
| 1 | ...       | 1d    | 5y       |    ... |    ... |    +.., % |    ..,% | .. |   ..,% |
```

Danach 2-4 Sätze Einordnung, keine lange Analyse:
- Was auffällt (z. B. wenn ein Frame/Fenster systematisch vorne liegt, oder
  wenn sich das Bild seit dem letzten Lauf verschoben hat)
- Kurzer Hinweis auf ausgeschlossene Kombinationen (Anzahl + Grund)
- Eine der ehrlichen Einschränkungen, die immer gelten (wähle die
  relevanteste, nicht alle auf einmal):
  - Survivorship-Bias im Universum (heutige Index-/Listungs-Mitglieder,
    delistete Titel fehlen — überschätzt absolute Returns aller Varianten)
  - Buy & Hold schlägt im Testzeitraum oft den reinen Return — der Wert
    einer Timing-Strategie liegt meist im Drawdown-Schutz, nicht im
    Rohertrag (das lässt sich an `pct_schlaegt_bh` ablesen)
  - 1h/4h haben strukturell schwächere Datenlage als 1d/1wk/1mo (nur ~730
    Tage Historie statt 10 Jahre, nicht split-adjustiert, oft dominiert ein
    einziges Marktregime das ganze Testfenster) — Ergebnisse dort sind
    weniger belastbar, nicht wertlos, aber entsprechend vorsichtiger zu lesen
