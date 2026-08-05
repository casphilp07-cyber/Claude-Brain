---
name: awesome-claude-skills (Composio)
url: https://github.com/ComposioHQ/awesome-claude-skills
stars: ~71.500
category: Skill Library
tags: [claude-code, skills, awesome-list, composio]
---

# Awesome Claude Skills — Composio (ComposioHQ/awesome-claude-skills)

**Was es ist:** Die größte kuratierte Community-Sammlung von Claude Skills — über 1.000 produktionsreife Skills. ~71,5k Sterne, ~8k Forks — deutlich größer als vergleichbare Awesome-Listen.

**Kernfunktionen:**
- 10+ Hauptkategorien: Dokumentenverarbeitung, Development & Code-Tools (30+), Daten & Analyse, Business & Marketing, Kommunikation & Schreiben, Kreativ & Medien, Produktivität & Organisation, Zusammenarbeit/Projektmanagement, Security & Systeme
- Besonderheit: **78 vorgefertigte SaaS-Skills über Composio-App-Automatisierung** — direkte Anbindung an externe Dienste als Skill statt als separates MCP-Plugin
- Wofür einsetzen: breite Abdeckung über reines Coding hinaus (Marketing, Business, Kreativ-Aufgaben) — gut geeignet, wenn Claude Code auch für nicht-technische Workflows genutzt werden soll

**Wie man es mit Claude Code nutzt:**
```bash
mkdir -p ~/.config/claude-code/skills/
cp -r skill-name ~/.config/claude-code/skills/
claude
```
Skill-Metadaten (`SKILL.md`-Frontmatter) werden automatisch erkannt, die Skill aktiviert sich, sobald sie zur Aufgabe passt ("progressive loading").

**Einschätzung:** Übernehmen als Haupt-Fundgrube für Skills jenseits von reinem Coding — bei über 1.000 Skills lohnt sich aber gezielte Auswahl statt Komplettinstallation.
