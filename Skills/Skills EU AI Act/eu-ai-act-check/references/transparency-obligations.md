# Transparenzpflichten (Art. 50)

Gelten **zusätzlich und unabhängig** vom Risiko-Tier — auch ein minimal-risk System kann hier Pflichten auslösen. Für die meisten Software-/AI-Produkte (Chatbots, Content-Generierung) sind das die praktisch wichtigsten Pflichten.

## Art. 50(1) — Chatbots / direkte Interaktion mit Personen
Systeme, die mit natürlichen Personen interagieren, müssen so gestaltet sein, dass die Person weiß, dass sie mit KI kommuniziert — **außer** es ist einer vernünftig informierten Person offensichtlich (z.B. klar erkennbarer Bot-Kontext). Ausnahme: gesetzlich autorisierte Strafverfolgungssysteme (außer öffentlich zugängliche Meldetools).
- *Praxis:* Klarer Hinweis "Du sprichst mit einem KI-Assistenten" bei Support-Chatbots, Voice-Bots etc.

## Art. 50(2) — Synthetische Inhalte (auch von GPAI-Systemen erzeugt)
Ausgaben (Audio/Bild/Video/Text) müssen in maschinenlesbarem Format markiert und als KI-generiert/manipuliert erkennbar sein. Ausnahme: assistive Bearbeitungsfunktionen, Inhalte die den Nutzer-Input nicht substanziell verändern, Strafverfolgung.
- *Praxis:* Bild-/Video-/Audio-Generatoren brauchen technisches Wasserzeichen/Metadaten (z.B. C2PA), nicht nur ein UI-Label.

## Art. 50(3) — Emotionserkennung / biometrische Kategorisierung
Deployer müssen exponierte Personen über den Systembetrieb informieren und personenbezogene Daten gemäß DSGVO/LED verarbeiten. Ausnahme: rechtmäßige Straftaterkennung/-ermittlung.

## Art. 50(4) — Deepfakes & KI-Text zu Angelegenheiten öffentlichen Interesses
Deployer, die Bild-/Audio-/Video-Deepfakes erzeugen/manipulieren, müssen den künstlichen Ursprung offenlegen. Bei künstlerischen/satirischen Werken reicht eine Offenlegung "in angemessener Weise", die den Genuss des Werks nicht beeinträchtigt. Separat: KI-generierter **Text zu Angelegenheiten von öffentlichem Interesse** muss als solcher offengelegt werden, außer bei menschlicher Redaktionsverantwortung/-prüfung oder Strafverfolgung.
- *Praxis:* Relevant für News-/Content-Plattformen, die KI-Text zu politischen/gesellschaftlichen Themen automatisch veröffentlichen.

## Art. 50(5) — Form der Offenlegung
Muss klar, unterscheidbar, spätestens bei erster Interaktion/Exposition gegeben und barrierefrei zugänglich sein.

## Art. 50(6) — Verhältnis zu Kapitel III
Diese Pflichten gelten zusätzlich zu, nicht anstelle von, High-Risk-Pflichten (falls das System auch High-Risk ist).

## Art. 50(7) — Codes of Practice
Das AI Office fördert EU-weite Codes of Practice zur Erkennung/Kennzeichnung von KI-Inhalten — als freiwillige Orientierungshilfe, nicht als eigene Pflicht.

## Checkliste für den Skill-Ablauf
- Interagiert das System direkt mit Menschen (Chat, Voice, Avatar)? → Art. 50(1) Offenlegungspflicht
- Erzeugt/manipuliert das System Bild, Audio, Video oder Text? → Art. 50(2)/(4) Kennzeichnungspflicht
- Erkennt das System Emotionen oder kategorisiert biometrisch? → Art. 50(3) Informationspflicht (und ggf. bereits Art. 5(f)/(g) Verbot prüfen!)
- Werden Deepfakes oder KI-Text zu öffentlichen Themen erzeugt? → Art. 50(4) Offenlegungspflicht
