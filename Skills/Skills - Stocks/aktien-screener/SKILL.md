---
name: aktien-screener
description: Erstellt eine konkrete Screening-Kriterienliste (Kennzahlen, Ratios, Schwellenwerte) zum Auffinden von Growth-, Dividenden- oder Value-Aktien in einem bestimmten Sektor oder Markt. Nutze diesen Skill, wenn der Nutzer nach einem Aktien-Screener, Filterkriterien, "wie finde ich gute [Growth/Dividenden/Value]-Aktien", oder einer Watchlist-Strategie für einen bestimmten Sektor/Markt fragt.
tags: [claude-code, skills, aktien, screener, watchlist]
---

# Aktien-Screener bauen

Erstellt eine präzise, direkt anwendbare Kriterienliste, mit der der Nutzer selbst (z. B. in einem Screener-Tool wie Finviz, TradingView oder Bloomberg) nach hochwertigen Aktien filtern kann.

## Ablauf

1. **Parameter klären**, falls nicht genannt:
   - Stil: Growth, Dividende oder Value
   - Sektor/Markt: z. B. Technologie, US-Markt, Europa, Small Caps
2. **Kriterienliste erstellen** — konkrete Kennzahlen mit exakten Schwellenwerten, nicht nur vage Beschreibungen. "KGV < 15" statt "günstig bewertet".
3. **Begründung liefern**, warum jede Kennzahl für den gewählten Stil relevant ist.

## Output-Struktur

```
# Screening-Kriterien: [Stil]-Aktien im Sektor [Sektor/Markt]

## Kernkriterien (harte Filter)
- Kennzahl: Schwellenwert — kurze Begründung
(z. B. für Growth: Umsatzwachstum >20% YoY, Rule of 40 erfüllt, ...)
(z. B. für Dividende: Dividendenrendite 2-6%, Payout Ratio <60%, ...
 Dividendenwachstum >5 Jahre in Folge)
(z. B. für Value: KGV < Branchendurchschnitt, KBV < 1.5, FCF-Yield > 5%)

## Qualitätsfilter (zusätzliche Absicherung)
- Verschuldung, Profitabilität, Liquidität, Insider-Ownership etc.

## Ausschlusskriterien (Red Flags)
- Was den Titel disqualifiziert, z. B. sinkende Margen, hohe Verwässerung,
  Going-Concern-Vermerke, Delisting-Risiko

## Nächste Schritte
Wie der Nutzer diese Kriterien praktisch in einem Screener anwendet
```

## Wichtig

Passe die konkreten Schwellenwerte an Sektor und Marktumfeld an — ein KGV-Grenzwert für Tech-Growth unterscheidet sich stark von einem für Versorger oder Value-Titel. Wenn der Sektor ungewöhnlich ist (z. B. Biotech, Rohstoffe), erkläre kurz, warum Standardkennzahlen dort ggf. angepasst werden müssen.
