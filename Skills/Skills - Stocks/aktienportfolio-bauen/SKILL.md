---
name: aktienportfolio-bauen
description: Baut ein diversifiziertes Einzelaktien-Portfolio zu einem bestimmten Anlagebetrag, einer Strategie (konservativ/wachstumsorientiert/aggressiv) und einem Zeithorizont — mit Ticker-Liste, Allokations-Prozentsätzen und der Investment-These je Position. Nutze diesen Skill, wenn der Nutzer ein Portfolio, eine Aktienauswahl oder eine Allokation über mehrere Titel hinweg zusammenstellen möchte, z. B. "wie sollte ich 10.000€ auf Aktien verteilen".
tags: [claude-code, skills, aktien, portfolio, allokation]
---

# Diversifiziertes Aktienportfolio bauen

Erstellt einen konkreten, diversifizierten Vorschlag für ein Einzelaktien-Portfolio als Diskussionsgrundlage — kein automatisierter Anlagevorschlag zur direkten Umsetzung.

## Ablauf

1. **Parameter klären**, falls nicht genannt:
   - Anlagebetrag
   - Strategie: konservativ, wachstumsorientiert oder aggressiv
   - Zeithorizont
   - Gewünschte Anzahl an Positionen (falls nicht genannt, sinnvolle Anzahl anhand des Betrags vorschlagen — z. B. bei kleineren Beträgen weniger Positionen wegen Transaktionskosten/Diversifikationsgrenzen)
2. **Diversifikation sicherstellen** über Sektoren, ggf. Regionen und Marktkapitalisierungsgrößen hinweg, passend zur gewählten Strategie.
3. **Aktuelle Daten nutzen**, wenn Web-Zugriff verfügbar ist. Sonst transparent auf den Wissensstand hinweisen.

## Output-Struktur

```
# Portfolio-Vorschlag: [Betrag] · [Strategie] · [Zeithorizont]

## Strategie-Zusammenfassung
Kurz, wie dieses Portfolio die gewählte Strategie und den Zeithorizont
widerspiegelt (Risikoprofil, Sektorgewichtung, Diversifikationslogik)

## Positionen

| Ticker | Unternehmen | Sektor | Allokation % | Betrag | These (1 Satz) |
|---|---|---|---|---|---|
| ... | ... | ... | ... | ... | ... |

## Diversifikations-Check
Kurzer Überblick über Sektor-/Regionen-/Größenverteilung, damit erkennbar
ist, dass keine Übergewichtung in einem einzelnen Bereich entsteht

## Risikohinweise zum Gesamtportfolio
Was die größten gemeinsamen Risikofaktoren über alle Positionen hinweg sind
(z. B. Zinssensitivität, Sektor-Klumpenrisiko)
```

## Wichtig

Dies ist ein Diskussionsvorschlag zu Bildungszwecken, keine individuelle, regulierte Anlageberatung und keine Aufforderung zum Kauf. Weise den Nutzer explizit darauf hin, dass er selbst entscheidet bzw. eine lizenzierte Beratung hinzuziehen sollte, und dass du selbst keine Order ausführst.
