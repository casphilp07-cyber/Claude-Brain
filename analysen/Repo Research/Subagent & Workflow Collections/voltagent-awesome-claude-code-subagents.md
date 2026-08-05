---
name: awesome-claude-code-subagents (VoltAgent)
url: https://github.com/VoltAgent/awesome-claude-code-subagents
stars: ~23.900
category: Subagent & Workflow Collection
tags: [claude-code, subagents, awesome-list]
---

# Awesome Claude Code Subagents (VoltAgent/awesome-claude-code-subagents)

**Was es ist:** Die größte und am saubersten kategorisierte Sammlung fertiger Claude-Code-Subagenten — inzwischen 154+ Agenten (Repo-Beschreibung nennt "100+"). ~23,9k Sterne, ~2,8k Forks, MIT-Lizenz, sehr aktiv.

**Kernfunktionen:**
- Subagenten laufen in isolierten Kontextfenstern — verhindert, dass sich Spezialaufgaben gegenseitig den Hauptkontext "verschmutzen"
- 10 Kategorien: Core Development, Language Specialists (30+ Sprachen), Infrastructure (DevOps/K8s/Terraform/Cloud/Security), Quality & Security (Testing, Code-Review, Pentesting, Compliance), Data & AI (ML/NLP/LLM-Architektur), Developer Experience (Build-Tools, Doku, Refactoring, Git), Specialized Domains (Blockchain, Healthcare, Fintech, Gaming), Business & Product, Meta & Orchestration (Multi-Agent-Koordination selbst), Research & Analysis
- Wofür einsetzen: schnell einen fertigen Spezial-Agenten für eine konkrete Domäne (z.B. Kubernetes, Pentesting, Fintech-Compliance) einbinden, ohne ihn selbst zu formulieren

**Wie man es mit Claude Code nutzt:**
- Plugin-Methode (empfohlen): `claude plugin install voltagent-core-dev` installiert ganze Kategorie-Pakete
- Manuell: Agenten-Dateien nach `~/.claude/agents/` (global) oder `.claude/agents/` (Projekt) kopieren
- Interaktiv: `./install-agents.sh` zum Durchklicken der Kategorien
- Danach: Claude Code zieht passende Subagenten automatisch heran, oder man fragt gezielt: "Lass den code-reviewer-Subagenten meine Commits prüfen"

**Einschätzung:** Übernehmen als Standard-Bibliothek für Einzel-Subagenten — die mit Abstand umfangreichste und am besten organisierte Sammlung in dieser Kategorie, gute Ergänzung zu wshobson/agents (siehe [[../Claude Code Plugins/wshobson-agents|Claude Code Plugins]]).
