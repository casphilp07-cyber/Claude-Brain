# Kernbegriffe (Art. 3 EU AI Act)

Referenz für die Rollen-Klärung in Schritt 2 des SKILL.md-Ablaufs. Ein Projekt kann mehrere Rollen gleichzeitig einnehmen (z.B. Provider *und* Deployer für unterschiedliche Systemteile).

## AI-System
Maschinenbasiertes System mit unterschiedlichem Autonomiegrad, das nach der Bereitstellung anpassungsfähig sein kann und aus Eingaben ableitet, wie Ausgaben (Vorhersagen, Inhalte, Empfehlungen, Entscheidungen) erzeugt werden, die physische oder virtuelle Umgebungen beeinflussen können. Sehr weit gefasst — praktisch jede ML/LLM-gestützte Funktion fällt darunter.

## Provider (Anbieter)
Wer ein AI-System oder GPAI-Modell entwickelt (oder entwickeln lässt) und unter eigenem Namen/eigener Marke auf den Markt bringt oder in Betrieb nimmt — entgeltlich oder unentgeltlich. **Wichtig:** Man wird auch dann automatisch zum Provider (Art. 25), wenn man
- ein bereits am Markt befindliches High-Risk-System unter eigener Marke weitervertreibt,
- ein High-Risk-System wesentlich verändert (und es High-Risk bleibt), oder
- ein nicht-High-Risk-System (auch General-Purpose) so umwidmet, dass es High-Risk wird.

## Deployer (Betreiber)
Wer ein AI-System in eigener Verantwortung beruflich nutzt (nicht: rein private, nicht-berufliche Nutzung). Wer z.B. eine fremde API (Claude, OpenAI, etc.) in ein eigenes Produkt einbaut und damit Endnutzern zur Verfügung stellt, ist in Bezug auf das AI-System typischerweise **Deployer** — wird aber zum **Provider**, sobald das eigene Produkt selbst als AI-System vermarktet wird bzw. wesentliche Anpassungen/Fine-Tuning vorgenommen werden.

## Importeur
In der EU niedergelassene Stelle, die ein System mit dem Namen/der Marke eines Nicht-EU-Anbieters auf den EU-Markt bringt.

## Distributor (Händler)
Jede weitere Stelle in der Lieferkette (außer Provider/Importeur), die ein System auf dem Markt bereitstellt.

## Authorised Representative (Bevollmächtigter)
Für Nicht-EU-Provider verpflichtend: EU-ansässige Stelle mit schriftlichem Mandat, die u.a. Konformitätsunterlagen vorhält und mit Behörden kooperiert.

## Operator
Sammelbegriff: Provider, Produkthersteller, Deployer, Authorised Representative, Importeur oder Distributor.

## GPAI-Modell (General-Purpose AI Model)
Modell (auch selbstüberwacht/großskalig trainiert) mit erheblicher Allgemeingültigkeit, das eine breite Palette unterschiedlicher Aufgaben kompetent ausführen kann und in nachgelagerte Systeme integrierbar ist. Ausgenommen: reine Forschungs-/Prototyping-Modelle vor Markteinführung. **Praxis-Hinweis:** Wer nur eine fremde API (z.B. Claude) konsumiert, ist NICHT GPAI-Provider — das ist Anthropic. GPAI-Provider wird man erst, wenn man selbst ein Foundation-Modell trainiert oder ein bestehendes Modell so substanziell fine-tuned, dass ein neues Modell im Sinne des Acts entsteht.

## Systemisches Risiko
Risiko, das an "High-Impact-Fähigkeiten" eines GPAI-Modells hängt, mit erheblicher EU-Marktreichweite oder abschätzbaren negativen Effekten in großem Maßstab. Vermutet ab kumulativem Trainingscompute > 10^25 FLOPs (siehe `gpai-obligations.md`).

## Weitere relevante Begriffe
- **Biometrische Daten / -Kategorisierung / Emotionserkennung**: siehe `prohibited-practices.md` und `transparency-obligations.md`.
- **Remote-biometrische Identifizierung** (Echtzeit / nachträglich): siehe `prohibited-practices.md`.
- **Öffentlich zugänglicher Raum**: physischer Ort, der einer unbestimmten Zahl von Personen zugänglich ist — relevant für RBI-Verbote.
- **Deepfake**: KI-generierter/manipulierter Bild-, Audio- oder Video-Inhalt, der real erscheint.
- **Substanzielle Modifikation**: Änderung nach Markteinführung, die nicht in der ursprünglichen Konformitätsbewertung vorgesehen war und die Konformität beeinflusst oder den Zweck ändert.
