# Pflichten für High-Risk-AI-Systeme (Art. 8-27)

Nur relevant, wenn `high-risk-classification.md` einen Treffer ergeben hat. Alle Pflichten gelten unabhängig vom aktuellen Datum (siehe Hinweis in SKILL.md — kein zeitliches Filtern).

## Anforderungen an das System selbst (Art. 8-15) — primär Provider-Pflicht

- **Art. 9 — Risikomanagementsystem**: kontinuierlicher, iterativer Lebenszyklus-Prozess: bekannte/vorhersehbare Risiken identifizieren, Risiken unter bestimmungsgemäßer Nutzung UND vernünftigerweise vorhersehbarem Missbrauch bewerten, Post-Market-Monitoring-Daten einbeziehen, gezielte Minderungsmaßnahmen, Testen gegen vordefinierte Metriken/Schwellen vor Markteinführung, besondere Berücksichtigung von Minderjährigen/vulnerablen Gruppen.
- **Art. 10 — Daten-Governance**: Trainings-/Validierungs-/Testdaten brauchen dokumentierte Governance (Designentscheidungen, Herkunft, Aufbereitung, Bias-Prüfung/-Minderung, Lückenidentifikation); Daten müssen relevant, repräsentativ, so fehlerfrei/vollständig wie möglich sein.
- **Art. 11 — Technische Dokumentation**: vor Markteinführung erstellt, laufend aktualisiert, muss Annex-IV-Anforderungen erfüllen; vereinfachte Form für KMU/Start-ups verfügbar.
- **Art. 12 — Protokollierung**: automatische Ereignisprotokollierung über die Systemlebensdauer.
- **Art. 13 — Transparenz gegenüber Deployern**: Nutzungsanweisungen mit Provider-Identität, Systemeigenschaften/-fähigkeiten/-grenzen, Genauigkeits-/Robustheits-/Cybersicherheitsniveau, bekannte Risiken, Erklärbarkeitsfeatures, Performance nach Nutzergruppen, Eingabedaten-Spezifikation, Human-Oversight-Maßnahmen, Hardware-/Wartungsbedarf.
- **Art. 14 — Menschliche Aufsicht**: wirksame Aufsicht durch Mensch-Maschine-Schnittstellen; Aufsichtspersonen müssen Fähigkeiten/Grenzen verstehen, Automation Bias kennen, Ausgaben korrekt interpretieren, Ausgaben übersteuern/verwerfen/rückgängig machen können, Stopp-Mechanismus. Bei biometrischen Identifizierungssystemen: unabhängige Bestätigung durch ≥2 kompetente Personen vor Handlung (Ausnahme: Strafverfolgung/Migration wo unverhältnismäßig).
- **Art. 15 — Genauigkeit, Robustheit, Cybersicherheit**: angemessene, deklarierte Niveaus; Resilienz gegen Fehler, technische Redundanz; Feedback-Loop-Bias-Kontrolle bei weiterlernenden Systemen; Resilienz gegen Data-Poisoning, Model-Poisoning, Adversarial Examples, Confidentiality Attacks, Model Flaws.

## Pflichten nach Akteursrolle

### Provider (Art. 16-21)
- Konformität mit obigen Anforderungen sicherstellen
- Name/Marke/Kontaktadresse auf System/Verpackung/Dokumentation angeben
- **Art. 17** Qualitätsmanagementsystem führen (Compliance-Strategie, Design-/Verifikationskontrolle, QA, Teststrategien, Datenmanagement, Risikomanagement, Post-Market-Monitoring, Incident-Reporting)
- **Art. 18** Technische Dokumentation 10 Jahre aufbewahren
- **Art. 19** Automatisch generierte Logs ≥6 Monate aufbewahren
- **Art. 20** Bei Nichtkonformität: korrigieren/zurückziehen/deaktivieren/zurückrufen, Distributoren/Deployer/Importeure informieren, Marktüberwachungsbehörde bei Risiko informieren
- **Art. 21** Auf begründete Anfrage Konformität gegenüber Behörden nachweisen, Log-Zugriff gewähren
- Konformitätsbewertungsverfahren durchlaufen (Art. 43), EU-Konformitätserklärung (Art. 47) + CE-Kennzeichnung (Art. 48)
- EU-Datenbank-Registrierung (Art. 49(1))
- Barrierefreiheit sicherstellen (Richtlinien (EU) 2016/2102, (EU) 2019/882)

### Authorised Representative (Art. 22) — nur bei Nicht-EU-Providern
Verifiziert Konformitätserklärung/technische Doku, hält Unterlagen 10 Jahre vor, informiert Behörden, kooperiert bei Risikominderung, übernimmt ggf. Registrierung, kann Mandat bei Non-Compliance kündigen.

### Importeur (Art. 23)
Vor Markteinführung: Konformitätsbewertung/technische Doku/CE-Kennzeichnung/Konformitätserklärung/Nutzungsanweisungen/Authorised-Rep-Bestellung prüfen; nicht-konforme Systeme nicht in Verkehr bringen; eigenen Namen/Kontakt angeben; Lager-/Transportbedingungen einhalten; Unterlagen 10 Jahre aufbewahren.

### Distributor (Art. 24)
Vor Bereitstellung: CE-Kennzeichnung/Konformitätserklärung/Anweisungen prüfen, prüfen ob Provider/Importeur ihre Pflichten erfüllt haben; nicht-konforme Systeme nicht bereitstellen; bei nachträglich festgestellter Nichtkonformität: Korrekturmaßnahmen/Rückruf; Behörden informieren.

### Art. 25 — Rollenwechsel in der Lieferkette
Ein Distributor/Importeur/Deployer/Dritter wird selbst **Provider** (mit allen Art.-16-Pflichten), wenn er: eine eigene Marke auf ein bereits platziertes High-Risk-System setzt, ein High-Risk-System wesentlich verändert (weiterhin High-Risk), oder ein Nicht-High-Risk-System so umwidmet, dass es High-Risk wird. Schriftliche Vereinbarungen zwischen High-Risk-Providern und Zulieferern integrierter Komponenten sind vorgeschrieben (Ausnahme: freie/Open-Source-Komponenten außer GPAI-Modelle).

### Deployer (Art. 26)
- System gemäß Nutzungsanweisungen einsetzen, geeignete technisch/organisatorische Maßnahmen treffen
- Menschliche Aufsicht durch kompetente, geschulte, befugte Personen sicherstellen
- Eingabedaten-Relevanz/-Repräsentativität sicherstellen, soweit kontrolliert
- Betrieb überwachen; bei Risiko oder ernstem Vorfall: aussetzen, Provider/Distributor/Marktüberwachungsbehörde informieren
- Logs ≥6 Monate aufbewahren
- Arbeitnehmervertretung vor Einsatz am Arbeitsplatz informieren
- Öffentliche-Stelle-Deployer: Registrierungspflicht (Art. 49), keine Nutzung unregistrierter Systeme
- Betroffene Personen informieren, dass sie einer High-Risk-KI-Entscheidung unterliegen (Ausnahme: Strafverfolgung)
- Bei nachträglicher biometrischer Identifizierung: vorherige (oder binnen 48h) richterliche/administrative Genehmigung bei zielgerichteter Suche im Straftatkontext, nie ungezielt, keine allein automatisierte nachteilige Entscheidung, Dokumentation jeder Nutzung, Jahresbericht an Behörden
- Mit zuständigen Behörden kooperieren

### Art. 27 — Grundrechte-Folgenabschätzung (FRIA)
Vor Einsatz erforderlich für öffentlich-rechtliche Stellen, private Anbieter öffentlicher Dienstleistungen, und Deployer der Annex-III-Kategorien 5(b)/(c) (Kreditwürdigkeit, Versicherungsrisiko/-preisgestaltung) — Ausnahme: Annex III Kategorie 2 (kritische Infrastruktur). Muss abdecken: Nutzungsprozess-Beschreibung, Dauer/Häufigkeit der Nutzung, betroffene Personengruppen, spezifische Schadensrisiken, Umsetzung menschlicher Aufsicht, Minderungs-/Beschwerdemechanismen. Kann mit DSGVO-Art.-35-DSFA kombiniert werden. Ergebnis wird der Marktüberwachungsbehörde mitgeteilt.

## Vereinfachungen für KMU/Start-ups (Art. 63)
Kleinstunternehmen (ohne verbundene/Partnerunternehmen) dürfen ein vereinfachtes Qualitätsmanagementsystem (Art. 17) nutzen — **entbindet aber nicht** von Art. 9-15 (Risikomanagement, Daten-Governance, Transparenz, menschliche Aufsicht, Genauigkeit/Robustheit/Cybersicherheit), Art. 72 (Post-Market-Monitoring) oder Art. 73 (Incident-Reporting).
