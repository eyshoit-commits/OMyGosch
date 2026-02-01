# GitHub Copilot Integration Guide

Diese Anleitung beschreibt die vollständige Einrichtung und optimale Nutzung von GitHub Copilot im Kontext dieses Workspaces, insbesondere für den Einsatz mit OpenCode Manager, Plugins und Agenten.

---

## 1. Voraussetzungen

- Aktives GitHub-Konto mit Copilot-Abonnement
- Visual Studio Code oder kompatibler Editor
- Zugang zu `/bkg/workspace` im Container/Devcontainer

---

## 2. Copilot in VS Code installieren & aktivieren

1. Öffne den Extensions-Bereich in VS Code (`Ctrl+Shift+X`)
2. Suche nach `GitHub Copilot`
3. Klicke auf **Installieren**
4. Melde dich mit deinem GitHub-Account an und prüfe, ob die Copilot-Extension aktiviert ist
5. Die Extension sollte automatisch deinen Lizenzstatus erkennen

---

## 3. Konfigurationsempfehlungen

Öffne die Settings (z.B. per `Ctrl+,` oder Command Palette > "Open Settings (JSON)") und ergänze für bestmögliche Zusammenarbeit:

```json
{
  "github.copilot.enable": true,
  "github.copilot.inlineSuggest.enable": true,
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.suggestionDelayMs": 0,
  "github.copilot.advanced": {
      "debug": false,
      "panel.logLevel": "warn"
  }
}
```

**Tipp**: Kombiniere Copilot mit diesen Extensions für OpenCode-Umgebungen:
- ms-python.python
- rust-lang.rust-analyzer
- dbaeumer.vscode-eslint
- esbenp.prettier-vscode

---

## 4. Copilot in Devcontainer nutzen

Sicherstellen, dass:

- Die GitHub-Authentifizierung erfolgt im Container
- Der Copilot-Server Zugriff auf notwendige Umgebungen (wie Node.js/Bun) hat

Falls Copilot im Container nicht automatisch funktioniert:
- Kopiere deinen Auth-Token mit `gh auth login` (CLI)
- Starte VS Code einmal mit Remote-Verbindung neu

---

## 5. Copilot als Provider für OpenCode Agents

**Wichtig**:  
Plugins wie `oh-my-opencode` können Copilot als Fallback/Provider nutzen.

So aktivierst du Copilot als Modell-Provider:
1. Führe den Installer aus (z.B. `bunx oh-my-opencode install`) und beantworte "Copilot subscription vorhanden?" → `Ja`
2. Authentifiziere bei Bedarf explizit mit:
   ```
   opencode auth login
   # Provider auswählen: GitHub  > dann OAuth-Flow abschließen
   ```
3. Nach erfolgreicher Authentifizierung sind Copilot-Modelle als Fallback in deinem opencode-Setup verfügbar.

Mehr Infos:
- [OhMyOpenCode Installation & Auth (README)](https://github.com/code-yeongyu/oh-my-opencode/blob/master/docs/guide/installation.md)
- [OpenCode Model Provider Guide](https://opencode.ai/docs/providers/)

---

## 6. Troubleshooting

- **Fehler „Copilot authentication failed“:**  
  → VS Code neustarten und Auth in Remote/Container sicherstellen

- **Keine Inline-Vorschläge?**  
  → Prüfe Einstellungen, Linter/Formatter-Plugins und dass du mit dem richtigen GitHub-Account im Container angemeldet bist.

---

## 7. Weitere Quellen & Links

- [Copilot Docs (GitHub)](https://docs.github.com/en/copilot)
- [OpenCode Provider Doku](https://opencode.ai/docs/providers/)
- [opencode.ai Model-Übersicht](https://opencode.ai/docs/models/)

---

## 8. Best Practices

- Nutze Copilot für Code- und Prompt-Completionen, Test-Vorschläge, Agentenskripte etc.
- Im LLM-Agent-Umfeld: Initialisiere Plugins/Addons zuerst, Copilot fungiert als Backup-Provider

---

Diese Datei gerne erweitern, sobald neue Copilot-Features oder Provider-Integrationen hinzukommen!
