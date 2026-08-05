# High-Risk-Klassifikation (Art. 6, Annex I, Annex III)

## Zwei Wege zu "High-Risk"

**Weg 1 — Annex I (Produktsicherheit):** Das AI-System ist Sicherheitskomponente eines Produkts, das unter EU-Harmonisierungsrecht fällt (Maschinen, Spielzeug, Aufzüge, Funkanlagen, Druckgeräte, Seilbahnen, PSA, Gasgeräte, Medizinprodukte, In-vitro-Diagnostika, Kfz, Luftfahrt, Schifffahrt, Bahn etc.) UND das Produkt benötigt eine Konformitätsbewertung durch Dritte. Relevant vor allem für Hardware-nahe/eingebettete Systeme, selten für reine Software-/SaaS-Projekte.

**Weg 2 — Annex III (Anwendungsfall-Liste):** Das System fällt unter eine der 8 folgenden Kategorien → automatisch High-Risk, sofern keine Art.-6(3)-Ausnahme greift:

1. **Biometrie** (soweit rechtlich zulässig): Remote-biometrische Identifizierung (reine 1:1-Verifikation ausgenommen), biometrische Kategorisierung nach sensiblen Merkmalen, Emotionserkennungssysteme.
2. **Kritische Infrastruktur**: Sicherheitskomponenten zum Betrieb/Management kritischer digitaler Infrastruktur, Straßenverkehr, Wasser-/Gas-/Wärme-/Stromversorgung.
3. **Bildung/Berufsausbildung**: Zulassungs-/Zugangsentscheidungen, Bewertung von Lernergebnissen/Steuerung des Lernens, Einstufung des Bildungsniveaus, Erkennung von Prüfungsverstößen.
4. **Beschäftigung/Personalmanagement**: Recruiting/Bewerber-Filterung/gezielte Stellenanzeigen, Entscheidungen zu Beförderung, Kündigung, Aufgabenverteilung, Leistungs-/Verhaltensmonitoring.
5. **Wesentliche private/öffentliche Dienstleistungen**: Zugang zu Sozialleistungen/Gesundheitsversorgung, Kreditwürdigkeitsprüfung/Scoring (Betrugserkennung ausgenommen), Risikobewertung/Preisgestaltung bei Lebens-/Krankenversicherung, Notruf-Bewertung/Priorisierung.
6. **Strafverfolgung** (soweit rechtlich zulässig): Risikobewertung, Opfer-/Täterprofile, Polygraphen, Beweismittel-Zuverlässigkeitsbewertung, Rückfallrisiko (nicht allein Profiling-basiert).
7. **Migration/Asyl/Grenzkontrolle** (soweit rechtlich zulässig): Polygraphen, Risikobewertung (Sicherheit/irreguläre Migration/Gesundheit), Prüfung von Asyl-/Visa-/Aufenthaltsanträgen, Personenidentifizierung im Migrationskontext.
8. **Justiz und demokratische Prozesse**: Unterstützung von Gerichten bei Rechtsauslegung/Sachverhaltsermittlung, Systeme zur Beeinflussung von Wahlen/Abstimmungen (reine Wahlkampf-Logistik-Tools ausgenommen).

## Art. 6(3) — Rück-Ausnahmen ("Nicht doch High-Risk")

Ein Annex-III-System ist **nicht** High-Risk, wenn es kein signifikantes Risiko für Gesundheit/Sicherheit/Grundrechte darstellt, weil es:
- eine eng umgrenzte prozedurale Aufgabe erfüllt,
- das Ergebnis einer bereits abgeschlossenen menschlichen Tätigkeit verbessert,
- Abweichungen von früheren menschlichen Entscheidungsmustern erkennt, ohne die menschliche Prüfung zu ersetzen/beeinflussen, oder
- eine rein vorbereitende Aufgabe ausführt.

**Ausnahme von der Ausnahme:** Sobald das System **Profiling natürlicher Personen** durchführt (automatisierte Verarbeitung personenbezogener Daten zur Bewertung von Arbeitsleistung, Kreditwürdigkeit, Gesundheit, Verhalten, Standort etc.), ist es **immer** High-Risk — unabhängig von den obigen Ausnahmen.

**Dokumentationspflicht:** Wenn sich ein Provider auf Art. 6(3) beruft und sein System selbst als nicht-High-Risk einstuft, muss diese Selbsteinschätzung vor Markteinführung dokumentiert werden — und unterliegt trotzdem der Registrierungspflicht (Art. 49(2)).

## Einordnung im Skill-Ablauf

1. Prüfen: Fällt der Use-Case unter eine der 8 Annex-III-Kategorien (oder Annex I bei Hardware-Bezug)?
2. Falls ja: Art.-6(3)-Ausnahmen prüfen — greift eine davon UND liegt kein Profiling vor → nicht High-Risk (aber Dokumentationspflicht der Selbsteinschätzung erwähnen).
3. Falls nein zu 1 oder Ausnahme in 2 greift ohne Profiling: **nicht High-Risk** → weiter mit Transparenz- und GPAI-Check (`transparency-obligations.md`, `gpai-obligations.md`).
4. Falls High-Risk: `high-risk-obligations.md` laden und vollständige Pflichten-Checkliste je Rolle ausgeben.

Annex I und III sind dynamisch — die Kommission kann per delegiertem Rechtsakt Kategorien ergänzen/ändern (Art. 7), Kriterien dafür u.a.: Verwendungszweck, Nutzungsumfang, Datensensibilität, Autonomiegrad, historische Schadensfälle, Schweregrad, Abhängigkeit Betroffener, Machtungleichgewicht, Reversibilität des Schadens, Rechtsschutzmöglichkeiten. Bei Grenzfällen im Zweifel konservativ (als High-Risk) einstufen.
