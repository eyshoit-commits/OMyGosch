
# Agents Configuration & Registration

## Begriffe

- **Agent**: Ausführbare LLM-Komponente mit eigener Logik
- **Skill**: Wiederverwendbare Fähigkeit eines Agenten
- **Plugin**: Paket aus Agent + Skills + Konfiguration

Diese Definitionen sorgen für Klarheit und vermeiden Missverständnisse bei neuen Nutzern.

Dieses Dokument beschreibt, wie Agenten für den OpenCode Manager und kompatible Plugin-Systeme in diesem Workspace hinzugefügt, konfiguriert und registriert werden.

## Zweck

Agenten sind modulare Komponenten, die spezifische Fähigkeiten oder Automatisierungen für LLM-basierte Systeme bereitstellen. Für die Funktion von Plugins ist die korrekte Registrierung und Platzierung der Agenten-Dateien erforderlich.

## Allgemeine Schritte

1. **Agenten-Paket/Implementierung beschaffen, das installiert werden soll.**
2. **Den Anweisungen im Plugin- oder Agenten-Repository folgen (siehe unten für Links/Beispiele).**
3. **Erforderliche `skills/`- oder `agents/`-Ordner an die richtige Stelle kopieren.**

**Standardpfade (empfohlen):**

- Agenten: `/bkg/workspace/agents/`
- Skills: `/bkg/workspace/skills/`
- Plugins: `/bkg/workspace/plugins/`

*Hinweis: Diese Pfade können je nach Plugin abweichen.*

1. **Falls der Agent in `opencode.json` oder einer anderen Konfiguration registriert werden muss, den detaillierten Hinweisen im README oder installation.md des Plugins folgen.**

**Minimalbeispiel für Agenten-Registrierung (`opencode.json`):**

```json
{
 "agents": {
  "mem": {
   "path": "./agents/opencode-mem",
   "enabled": true,
   "provider": "nvidia",
   "model": "meta/llama3-8b-instruct"
  }
 }
}
```

## Referenzen & Beispiel-Repositories

- [Oh-My-OpenCode Agent Guide](https://github.com/code-yeongyu/oh-my-opencode/blob/master/docs/guide/installation.md) – Hauptagent-Manager, unterstützt Multi-Provider (z.B. Nvidia, Anthropic, OpenAI), CLI-Installation (`bunx oh-my-opencode install`), zentrale Agenten- und Skills-Registrierung.
- [OpenCode Model Announcer](https://github.com/ramarivera/opencode-model-announcer) – Automatisiert Modell- und Agentenankündigungen im OpenCode-Ökosystem, einfache Installation via Plugin-Registrierung.
- [Opencode Mem](https://github.com/tickernelz/opencode-mem) – Persistente Memory/Notiz-Agenten, benötigt SQLite, Installation via Plugin-Registrierung und ggf. Datenbank-Setup.
- [plannotator](https://github.com/backnotprop/plannotator) – Plantasks- und Annotation-Agent, Integration über OpenCode-Plugins, CLI- und API-Support.
- [opencode-workspace](https://github.com/kdcokenny/opencode-workspace) – Workspace-Management-Agent, Installation via OCX-Registry und Plugin-Registrierung.
- [opencode-worktree](https://github.com/kdcokenny/opencode-worktree) – Worktree/Branch-Management-Agent, OCX-Registry-Integration erforderlich.
- [opencode-scheduler](https://github.com/different-ai/opencode-scheduler) – Zeit- und Task-Scheduler-Agent, Plugin-Installation, unterstützt geplante Agentenaktionen.
- [daytona](https://github.com/jamesmurdza/daytona) – Externer Sandbox/Dev-Umgebungs-Agent, nicht nativ für OpenCode, ggf. externe Integration nötig.

---

## Nvidia NIM Modelle

Dieser Abschnitt beschreibt die Integration und Nutzung der 32 Nvidia NIM Modelle im OpenCode Manager Workspace (Stand: 2026-01-30).

**Provider:** `nvidia`

**Hinweis:** Verfügbarkeit und Modellnamen können sich seitens NVIDIA ändern.

**Authentifizierung:**

- Setze die Umgebungsvariable `NVIDIA_API_KEY` mit deinem Schlüssel (z.B. `nvapi-FAKE-KEY-EXAMPLE-DO-NOT-USE`).

⚠️ **Beispiel-Key – niemals echte API-Keys committen oder veröffentlichen!**

- Füge den Provider `nvidia` in deiner `opencode.json` hinzu:

```json
{
 "providers": {
  "nvidia": {
   "api_key": "${NVIDIA_API_KEY}"
  }
 }
}
```

- Weitere Infos: [Nvidia Model Doku](https://opencode.ai/docs/models/)

**Gesamtanzahl Modelle:** 32

**Letztes Update:** 2026-01-30

### Kategorien & Modelle

- **Meta Llama** (6 Modelle):
  - meta/llama3-70b-instruct
  - meta/llama3-8b-instruct
  - meta/llama2-70b-chat
  - meta/llama2-13b-chat
  - meta/llama2-7b-chat
  - meta/llama-guard-2-8b

- **NVIDIA Nemotron** (6 Modelle):
  - nvidia/nemotron-4-340b-chat
  - nvidia/nemotron-4-340b-4bit
  - nvidia/nemotron-4-340b-fp8
  - nvidia/nemotron-4-340b-instruct
  - nvidia/nemotron-3-8b-base
  - nvidia/nemotron-3-8b-instruct

- **Microsoft Phi** (4 Modelle):
  - microsoft/phi-3-medium-128k-instruct
  - microsoft/phi-3-mini-128k-instruct
  - microsoft/phi-2
  - microsoft/phi-1_5

- **Mistral AI** (5 Modelle):
  - mistralai/mixtral-8x22b-instruct-v0.1
  - mistralai/mixtral-8x7b-instruct-v0.1
  - mistralai/mistral-large-latest
  - mistralai/mistral-medium-latest
  - mistralai/mistral-small-latest

- **Qwen** (4 Modelle):
  - qwen/qwen2-72b-instruct
  - qwen/qwen2-7b-instruct
  - qwen/qwen1.5-72b-chat
  - qwen/qwen1.5-14b-chat

- **Moonshot Kimi** (3 Modelle):
  - moonshot-ai/moonshot-v1-128k
  - moonshot-ai/moonshot-v1-32k
  - moonshot-ai/moonshot-v1-8k

- **DeepSeek** (4 Modelle):
  - deepseek-ai/deepseek-coder-33b-instruct
  - deepseek-ai/deepseek-coder-6.7b-instruct
  - deepseek-ai/deepseek-llm-67b-chat
  - deepseek-ai/deepseek-llm-7b-chat

<details>
<summary>Vollständige Modellliste (Referenz)</summary>

**Meta Llama:**

- meta/llama3-70b-instruct
- meta/llama3-8b-instruct
- meta/llama2-70b-chat
- meta/llama2-13b-chat
- meta/llama2-7b-chat
- meta/llama-guard-2-8b

**NVIDIA Nemotron:**

- nvidia/nemotron-4-340b-chat
- nvidia/nemotron-4-340b-4bit
- nvidia/nemotron-4-340b-fp8
- nvidia/nemotron-4-340b-instruct
- nvidia/nemotron-3-8b-base
- nvidia/nemotron-3-8b-instruct

**Microsoft Phi:**

- microsoft/phi-3-medium-128k-instruct
- microsoft/phi-3-mini-128k-instruct
- microsoft/phi-2
- microsoft/phi-1_5

**Mistral AI:**

- mistralai/mixtral-8x22b-instruct-v0.1
- mistralai/mixtral-8x7b-instruct-v0.1
- mistralai/mistral-large-latest
- mistralai/mistral-medium-latest
- mistralai/mistral-small-latest

**Qwen:**

- qwen/qwen2-72b-instruct
- qwen/qwen2-7b-instruct
- qwen/qwen1.5-72b-chat
- qwen/qwen1.5-14b-chat

**Moonshot Kimi:**

- moonshot-ai/moonshot-v1-128k
- moonshot-ai/moonshot-v1-32k
- moonshot-ai/moonshot-v1-8k

**DeepSeek:**

- deepseek-ai/deepseek-coder-33b-instruct
- deepseek-ai/deepseek-coder-6.7b-instruct
- deepseek-ai/deepseek-llm-67b-chat
- deepseek-ai/deepseek-llm-7b-chat

</details>

### Vollständige Modellliste (nach Kategorie)

**Meta Llama:**

- meta/llama3-70b-instruct
- meta/llama3-8b-instruct
- meta/llama2-70b-chat
- meta/llama2-13b-chat
- meta/llama2-7b-chat
- meta/llama-guard-2-8b

**NVIDIA Nemotron:**

- nvidia/nemotron-4-340b-chat
- nvidia/nemotron-4-340b-4bit
- nvidia/nemotron-4-340b-fp8
- nvidia/nemotron-4-340b-instruct
- nvidia/nemotron-3-8b-base
- nvidia/nemotron-3-8b-instruct

**Microsoft Phi:**

- microsoft/phi-3-medium-128k-instruct
- microsoft/phi-3-mini-128k-instruct
- microsoft/phi-2
- microsoft/phi-1_5

**Mistral AI:**

- mistralai/mixtral-8x22b-instruct-v0.1
- mistralai/mixtral-8x7b-instruct-v0.1
- mistralai/mistral-large-latest
- mistralai/mistral-medium-latest
- mistralai/mistral-small-latest

**Qwen:**

- qwen/qwen2-72b-instruct
- qwen/qwen2-7b-instruct
- qwen/qwen1.5-72b-chat
- qwen/qwen1.5-14b-chat

**Moonshot Kimi:**

- moonshot-ai/moonshot-v1-128k
- moonshot-ai/moonshot-v1-32k
- moonshot-ai/moonshot-v1-8k

**DeepSeek:**

- deepseek-ai/deepseek-coder-33b-instruct
- deepseek-ai/deepseek-coder-6.7b-instruct
- deepseek-ai/deepseek-llm-67b-chat
- deepseek-ai/deepseek-llm-7b-chat

### Empfehlungen

- **Best Overall:** meta/llama3-70b-instruct – Sehr leistungsfähig für allgemeine Aufgaben, hohe Genauigkeit.
- **Best for Coding:** deepseek-ai/deepseek-coder-33b-instruct – Optimiert für Programmieraufgaben und Codeverständnis.
- **Best for Long Context:** moonshot-ai/moonshot-v1-128k – Unterstützt sehr lange Kontexte, ideal für große Dokumente.
- **Best for Vision:** nvidia/nemotron-4-340b-instruct – Unterstützt multimodale Aufgaben (Text+Bild), hohe Kapazität.
- **Best for Speed:** microsoft/phi-3-mini-128k-instruct – Sehr schnelle Inferenz, geeignet für Echtzeitanwendungen.

### Integration in OpenCode

1. Füge den Provider `nvidia` in deiner `opencode.json` hinzu (siehe oben).
2. Setze die Umgebungsvariable `NVIDIA_API_KEY` mit deinem Schlüssel.
3. Modelle können in OpenCode-Plugins und Agenten als Provider ausgewählt werden.
4. Weitere Details und Modelloptionen findest du unter [opencode.ai/docs/models/](https://opencode.ai/docs/models/).

---

## Best Practices

- Immer den vorgesehenen Installer oder CLI-Befehl nutzen, falls vom Agenten/Plugin bereitgestellt (z.B. `bunx ... install`).
- Schritte zum Kopieren von Agenten/Skills nie überspringen.
- Registrierung des Agenten in Konfigurationsdateien immer bestätigen.
- Nach der Installation immer prüfen:
  - `opencode agents list`
  - `opencode doctor`
  - Testlauf mit minimalem Prompt
- Nach der Installation je nach Agentenfunktion per CLI/API/Health-Check oder UI verifizieren.

## Beispielprozess für Agenten mit Oh-My-OpenCode

1. Plugin installieren: `bunx oh-my-opencode install`
2. Installationsabfragen beantworten (Abos, Provider, Agentenpräferenzen).
3. CLI registriert Agenten und Skills (siehe Plugin-Dokumentation für Struktur).
4. Prüfen, ob der Agent in `~/.config/opencode/opencode.json` oder der Projektkonfiguration gelistet ist.
5. Provider ggf. per `opencode auth login` oder ähnlichem CLI-Befehl authentifizieren.
6. Agenten mit Beispielaufruf, Plan oder Health-Check testen.

---

## 🧠 Strategischer Hinweis: Agent Lifecycle Management

Langfristig empfiehlt sich ein Abschnitt zu „Agent Lifecycle Management“:

- Installation
- Registrierung
- Aktivierung
- Update
- Deaktivierung
- Entfernung

Das Dokument kann so zu einem vollständigen Guide für das Management von Agenten ausgebaut werden.

Dieses Dokument sollte aktualisiert werden, wenn Agenten in diesem Workspace hinzugefügt oder entfernt werden.

---
