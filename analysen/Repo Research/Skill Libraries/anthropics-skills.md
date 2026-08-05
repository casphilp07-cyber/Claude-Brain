---
name: anthropics/skills
url: https://github.com/anthropics/skills
stars: ~165.600
category: Skill Library
tags: [claude-code, skills, official, skill-md]
---

# Anthropics Skills (offizielles Repo)

**Was es ist:** Das offizielle, von Anthropic selbst gepflegte Referenz-Repository für das "Agent Skills"-Format — der Standard, an dem sich praktisch alle anderen Skill-Sammlungen orientieren. ~165,6k Sterne, ~19,7k Forks.

**Kernfunktionen:**
- Definiert das Skill-Format: ein Ordner mit `SKILL.md` (YAML-Frontmatter mit `name` + `description`, darunter Markdown-Anweisungen), optional ergänzt um Scripts/Templates/Assets
- Skills laden "progressiv" — zunächst nur Metadaten, volle Anweisungen erst wenn Claude die Skill als relevant erkennt (spart Kontext)
- Enthält Beispiel-Skills in vier Kategorien: Creative & Design (Kunst, Musik, Design), Development & Technical (Web-App-Testing, MCP-Server-Generierung), Enterprise & Communication (Kommunikation, Branding), Document Skills (PDF/DOCX/PPTX/XLSX erstellen/bearbeiten — Referenzimplementierung)
- Wofür einsetzen: als Ausgangspunkt/Vorlage, um eigene Skills nach dem korrekten Standard-Format zu bauen, plus direkt nutzbare Dokumenten-Skills (PDF-Formularfelder extrahieren etc.)

**Wie man es mit Claude Code nutzt:**
```
/plugin marketplace add anthropics/skills
/plugin install document-skills@anthropic-agent-skills
/plugin install example-skills@anthropic-agent-skills
```
Danach die Skill einfach im Prompt erwähnen (z.B. "Nutze die PDF-Skill um Formularfelder aus X zu extrahieren").

**Einschätzung:** Übernehmen — die maßgebliche Referenz für das Skill-Format selbst; jede eigene Skill-Entwicklung sollte sich hieran orientieren.
