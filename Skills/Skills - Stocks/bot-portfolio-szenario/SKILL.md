---
name: bot-portfolio-szenario
description: Simuliert, was das AlgoEdge-Trading-Bot-Depot (Repo /Users/caspar/Desktop/Trading-bot, Trading-212-Stocks-Mode) bei einem bestimmten Startkapital und einer bestimmten Laufzeit realistisch erwarten kann — mit der aktuell live konfigurierten Strategie und dem echten Kontomodell (Growth-Config-Slots, Voll-Investition). Nutze diesen Skill, wann immer Caspar ein Kapital und einen Zeitraum nennt und wissen will was er sich erwarten kann/soll — z. B. "500€ ein Jahr", "was wenn ich mit 2000 Euro zwei Jahre laufen lasse", "1000 Euro, 6 Monate, mit 50 im Monat dazu" — auch als kurzer Slash-artiger Aufruf mit nur Zahlen. Läuft eine echte Simulation über die Marktdaten (kein Erfahrungswert aus dem Gedächtnis) — bei jeder Anfrage neu ausführen.
tags: [claude-code, skills, trading-bot, algoedge, simulation, portfolio]
---

# Portfolio-Szenario: Kapital + Laufzeit durchspielen

Beantwortet "was kann ich mir bei X€ Startkapital über Y Zeit erwarten" mit
einer echten Simulation des Bot-Kontomodells — nicht mit einer Pi-mal-Daumen-
Schätzung. Nutzt `backtest_portfolio.py`, das für JEDES Zeitfenster eine
rollierende Historie plus mehrere zufällige Ticker-Scan-Reihenfolgen
durchspielt (siehe unten, warum das wichtig ist) und ein Endkapital pro Lauf
zurückgibt.

## 1. Eingabe verstehen: Kapital, Laufzeit, optional Sparplan

Caspar gibt Kapital und Laufzeit meist in Alltagssprache an, nicht als
fertige CLI-Flags. Übersetze das selbst:

**Kapital** → `--kapital <Zahl>` (EUR, Dezimalpunkt): "500", "500€",
"2000 Euro", "1.000" sind alle eindeutig — Tausenderpunkte/€-Zeichen einfach
entfernen.

**Laufzeit** → `--tage <Zahl>` (Tage):
- "X Jahr(e)" → `X * 365`
- "X Monat(e)" → `X * 30`
- "X Woche(n)" → `X * 7`
- "X Tag(e)" → `X`
- Nennt Caspar nur eine nackte Zahl ohne Einheit für die Laufzeit (z. B. "500
  und 1"), frag kurz nach statt zu raten — bei Kapital ist eine nackte Zahl
  eindeutig, bei Laufzeit nicht (1 könnte 1 Tag, 1 Monat oder 1 Jahr meinen).

**Sparplan (optional)** → `--sparplan <Zahl>`: erkenne Formulierungen wie
"mit 50 im Monat dazu", "50 Euro monatlich Sparplan", "zusätzlich 100/Monat".
Ohne solche Erwähnung: kein `--sparplan`-Flag (Default 0, einmalige Einzahlung).

## 2. Aktuell live konfigurierte Strategie ermitteln

Das Szenario soll zeigen, was das ECHTE, gerade laufende Setup liefert —
nicht irgendeine beliebige Strategie. Ermittle sie dynamisch, nicht
hartkodiert (sie kann sich ändern, z. B. nach einem Lauf des Skills
`bot-strategie-backtest`):

```bash
cd /Users/caspar/Desktop/Trading-bot
python3 -c "from algoedge import config; print(config.STRATEGIE_AKTIEN)"
```

## 3. Simulation laufen lassen

```bash
python3 backtest_portfolio.py --strategies <strategie_aus_schritt_2> \
  --kapital <X> --tage <Y> [--sparplan <Z>] --seeds 5
```

- `--seeds 5` ist der Tool-Default und bewusst nicht kleiner zu wählen: bei
  nur 4 Slots gegen 304 Ticker-Kandidaten sind die Slots fast immer voll
  (60-90% der Tage) — welche Aktien die knappen Slots bekommen, hängt dann
  spürbar von der zufälligen Prüf-Reihenfolge ab (empirisch bis zu 2x
  Unterschied zwischen zwei Reihenfolgen bei sonst identischer Konfiguration).
  Ein einzelner Lauf ist deshalb kein verlässliches Ergebnis — die 5 Seeds
  plus die rollierenden Zeitfenster sind der Punkt der ganzen Übung.
- Nutzt automatisch die bereits gecachten Marktdaten und den pro-Strategie
  gecachten Signal-Precompute (`backtest_results/sigmap_<strategie>.json`) —
  nur beim allerersten Mal für eine neue Strategie dauert das Precompute
  einen Moment länger.
- Multiprocessing-Rauschen auf stderr (`Signal-Fehler`/`Exit-Check-Fehler`)
  ignorieren, siehe Hinweis im Schwester-Skill `bot-strategie-backtest`.
- Das Tool warnt selbst, wenn die Laufzeit so lang ist, dass nur noch wenige
  unabhängige Zeitfenster aus der ~10-jährigen Historie passen ("WARNUNG: nur
  N unabhängige Fenster") — diese Warnung an Caspar weitergeben, nicht
  unterschlagen. Das Ergebnis ist dann unsicherer, nicht falsch.

## 4. Die richtige Konfigurationszeile auswählen: `auto/voll`

`backtest_portfolio.py` testet mehrere Slot-/Sizing-Varianten gleichzeitig
(zum Vergleich). Für dieses Szenario zählt **ausschließlich die Zeile
`auto/voll`** — Slots aus der echten Growth-Config (`strategy.
hole_growth_config`, bei 500€ z. B. 4 Slots) und Voll-Investitions-Sizing
(`STOCKS_VOLL_INVEST=true`, seit dessen Einführung der tatsächliche
Live-Default). Die Zeile `live (aktuell)` im Tool ist trotz ihres Namens
**veraltete Terminologie** — sie bildet die ALTE Sizing-Kette vor
`STOCKS_VOLL_INVEST` ab (investierte durch einen versteckten 50%-Cap nur
~52% des Kapitals) und entspricht NICHT mehr dem, was der Bot heute wirklich
tut. Andere Zeilen (`2/3/6/8 Slots/voll`) sind Sensitivitäts-Vergleiche für
eine andere Frage ("was wäre mit anderer Slot-Zahl") — hier nicht relevant.

## 5. Verteilung berechnen, nicht nur einen Punktwert

Aus der geschriebenen Ergebnis-JSON (`backtest_results/portfolio_lab_beides
[_sparplanZ][_kapX][_tageY].json` — Suffixe je nachdem was von den Defaults
abweicht) das `"samples"`-Dict lesen, Key `"<strategie>|auto/voll"`. Das ist
eine Liste von Einzelläufen (ein Eintrag pro Zeitfenster × Seed), jeweils mit
`final_kapital`, `eingezahlt`, `max_dd`, `return`.

Berechne daraus (z. B. mit einem kurzen Python-Snippet, `sorted()` +
Index für Perzentile):
- **Endkapital**: Median, P10 (schlechtes Zehntel), P90 (gutes Zehntel),
  absolutes Minimum und Maximum über alle Läufe
- **Gewinn/Verlust in EUR**: Median und P10/P90 von `final_kapital -
  eingezahlt` (aussagekräftiger als nur Prozent, besonders mit Sparplan)
- **Gewinn-Wahrscheinlichkeit**: Anteil der Läufe mit `return > 0`
- **Drawdown**: Median und P90 von `max_dd` über alle Läufe (typischer
  zwischenzeitlicher Rückgang vs. schlechtes Jahr)

## Output — NUR eine Tabelle im Chat, keine Datei

Keine Datei anlegen (außer den vom Tool selbst erzeugten Cache-/Ergebnis-
JSONs, die schon vorher existieren würden). Format:

```
| Kennzahl | Wert |
|---|---:|
| Eingezahlt | X € |
| Endkapital (Median) | X € |
| Endkapital (bestes Zehntel) | X € |
| Endkapital (schlechtestes Zehntel) | X € |
| Bester / schlechtester simulierter Lauf | X € / X € |
| Gewinn typisch (Median) | +X € |
| Wahrscheinlichkeit im Plus | X % |
| Zwischenzeitlicher Rückgang (typisch / schlechtes Jahr) | X % / X % |
```

Danach 2-4 Sätze Einordnung, im Stil "so liest du das" statt trockener
Zahlenwiederholung — was ein typisches vs. ein schlechtes Szenario bedeutet,
und falls ein Sparplan simuliert wurde, kurz erklären warum der Depotwert
bei jungen Raten noch nicht "arbeiten" konnte. Danach IMMER kurz (nicht
alle auf einmal, die relevanteste wählen):
- Buy & Hold schlägt in bullischen Testperioden oft den reinen Return — der
  Wert der Strategie liegt im Drawdown-Schutz, nicht im Rohertrag
- Survivorship-Bias im Universum (heutige Index-Mitglieder) schönt absolute
  Zahlen leicht, verzerrt aber den Vergleich zwischen Konfigurationen kaum
- Falls die Warnung aus Schritt 3 kam (wenige unabhängige Fenster): das hier
  wiederholen, nicht verschweigen
- Der Server/laufende Bot übernimmt neue Werte erst nach `git pull` +
  Neustart, falls das relevant sein könnte (z. B. nach einer frisch
  gemergten Änderung)
