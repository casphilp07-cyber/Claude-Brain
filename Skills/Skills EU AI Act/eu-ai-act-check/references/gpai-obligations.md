# GPAI-Modell-Pflichten (Art. 51-56)

Nur relevant, wenn ein eigenes Foundation-/General-Purpose-Modell trainiert oder so substanziell fine-getuned wird, dass ein neues Modell im Sinne des Acts entsteht (siehe `definitions.md`). Reine API-Nutzung fremder Modelle (Claude, GPT, etc.) löst diese Pflichten **nicht** aus — dort gilt man als Deployer/Provider des eigenen Systems, nicht als GPAI-Provider.

## Klassifikation (Art. 51-52)
- GPAI-Modell gilt als **"systemisches Risiko"**, wenn (a) High-Impact-Fähigkeiten anhand technischer Benchmarks vorliegen, oder (b) Kommissionsentscheidung (von Amts wegen oder Warnung des wissenschaftlichen Gremiums) nach Annex-XIII-Kriterien.
- **Vermutungsschwelle:** kumulativer Trainingscompute > **10^25 FLOPs** → automatische Vermutung von High-Impact-Fähigkeiten.
- Weitere Annex-XIII-Kriterien: Parameteranzahl, Datensatzgröße/-qualität, Input-/Output-Modalitäten, Capability-Benchmarks, Marktreichweite (Vermutung ab ≥10.000 registrierten EU-Geschäftsnutzern), Anzahl Endnutzer.
- Bei Erreichen der Schwelle: Provider muss die Kommission **binnen 2 Wochen** benachrichtigen; kann mit substanziierten Belegen eine Ausnahme geltend machen.

## Pflichten für ALLE GPAI-Provider (Art. 53)
- (a) Technische Dokumentation (Training/Test/Evaluation) gemäß **Annex XI**, verfügbar für AI Office/nationale Behörden
- (b) Informationen/Dokumentation für nachgelagerte Integratoren gemäß **Annex XII**
- (c) Urheberrechts-Compliance-Policy (inkl. Beachtung von Opt-outs nach Art. 4(3) Richtlinie 2019/790, mittels Stand-der-Technik)
- (d) Veröffentlichung einer **hinreichend detaillierten Zusammenfassung der Trainingsinhalte** (nach AI-Office-Vorlage)

**Ausnahme:** (a) und (b) entfallen für Modelle unter freier/Open-Source-Lizenz (Gewichte, Architektur, Nutzungsinfo öffentlich) — **außer** bei systemischem Risiko (Art. 53(2)).

**Art. 54:** Nicht-EU-Provider müssen vor Markteinführung einen EU-Bevollmächtigten benennen (gleiche Open-Source-Ausnahme, außer bei systemischem Risiko).

## Zusätzliche Pflichten bei systemischem Risiko (Art. 55)
Zusätzlich zu Art. 53/54:
- (a) Standardisierte Modellevaluation inkl. Adversarial Testing ("Red Teaming") zur Identifikation/Minderung systemischer Risiken
- (b) Bewertung/Minderung möglicher EU-weiter systemischer Risiken und ihrer Quellen
- (c) Tracking, Dokumentation und unverzügliche Meldung ernster Vorfälle & Korrekturmaßnahmen an AI Office/nationale Behörden
- (d) Angemessene Cybersicherheit für Modell und physische Infrastruktur

## Codes of Practice (Art. 56)
AI Office/Board fördern EU-weite Codes zu Art.-53/55-Pflichten. Freiwillige Teilnahme gibt Konformitätsvermutung bis harmonisierte Normen vorliegen.

## Checkliste für den Skill-Ablauf
1. Wird ein eigenes Modell trainiert oder substanziell fine-getuned (nicht nur Prompting/RAG über eine fremde API)? Falls nein → dieser Abschnitt entfällt, im Output kurz vermerken warum.
2. Falls ja: Trainingscompute abschätzen — über 10^25 FLOPs? → systemisches Risiko vermutet, volle Art.-55-Pflichten.
3. Open-Source-Lizenz mit offenen Gewichten? → Art.-53(a)/(b)-Ausnahme prüfen (entfällt bei systemischem Risiko).
4. Immer: Trainingsdaten-Zusammenfassung, Urheberrechts-Policy, technische Dokumentation als Grundpflicht nennen.
