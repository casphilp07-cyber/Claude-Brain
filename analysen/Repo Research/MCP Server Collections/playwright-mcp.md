---
name: Playwright MCP
url: https://github.com/microsoft/playwright-mcp
stars: ~35.700
category: MCP Server Collection
tags: [mcp, browser-automation, microsoft, testing]
---

# Playwright MCP (microsoft/playwright-mcp)

**Was es ist:** Microsofts offizieller MCP-Server für Browser-Automatisierung auf Basis von Playwright. Besonderheit: steuert Browser über strukturierte Accessibility-Snapshots statt über Screenshots — funktioniert deshalb deterministisch, auch ohne Bildverständnis des Modells. ~35,7k Sterne, ~3k Forks, Apache-2.0.

**Kernfunktionen:**
- Kern-Automatisierung: Navigation, Klicks, Tippen, Formulare ausfüllen, Element-Interaktion, Seiten-Snapshots/Screenshots, Tastatur/Maus-Steuerung, Tab-Verwaltung, Dialog-Handling
- Erweitert: Netzwerk-Request-Inspektion/-Mocking, Cookie-/Storage-Verwaltung, Video-/Trace-Aufzeichnung, PDF-Generierung, Element-Hervorhebung, JavaScript-Ausführung auf der Seite
- Optional: vision-basierte Koordinaten-Interaktion, DevTools-Integration, Test-Assertion-Tools
- Wofür einsetzen: jede Aufgabe, bei der Claude Code selbst im Browser klicken/navigieren/testen soll (E2E-Tests schreiben und ausführen, UI-Bugs live nachvollziehen, Formulare automatisiert ausfüllen) — deckt sich mit den bereits vorhandenen `claude-in-chrome`-Fähigkeiten, ist aber headless/CI-tauglich statt an eine echte Chrome-Session gebunden

**Wie man es mit Claude Code nutzt:**
```bash
claude mcp add playwright npx @playwright/mcp@latest
```

**Einschätzung:** Übernehmen für alles, was headless/CI-taugliche Browser-Automatisierung braucht (z.B. automatisierte E2E-Tests) — für interaktive Sessions im eigenen Chrome-Fenster bleibt `claude-in-chrome` die praktischere Wahl, beide ergänzen sich.
