# OpenCode Plugins Guide

This document provides detailed information about the four plugins configured in this workspace.

## Table of Contents
- [oh-my-opencode](#oh-my-opencode)
- [plannotator](#plannotator)
- [opencode-mem](#opencode-mem)
- [opencode-model-announcer](#opencode-model-announcer)

---

## oh-my-opencode

### Description
An advanced agent harness system (Sisyphus) that provides multi-model orchestration and enhanced tooling for OpenCode.

### Repository
https://github.com/code-yeongyu/oh-my-opencode

### Key Features
- **Multi-Model Orchestration**: Coordinate teams of specialized agents (logic, research, frontend, docs)
- **30+ Custom Tools**: LSP operations, AST-aware refactoring, advanced code search
- **Background Agents**: Run agents in the background for continuous analysis
- **22+ Lifecycle Hooks**: Extensive customization and workflow automation
- **Claude Code Compatibility**: Load and use Claude Code plugins directly

### Installation

```bash
# Recommended
bunx oh-my-opencode install

# Alternative
npx oh-my-opencode install

# With specific options
bunx oh-my-opencode install --no-tui --claude=max20 --chatgpt=yes --gemini=yes
```

### Configuration
Located in `.opencode/opencode.json`:
```json
{
  "oh-my-opencode": {
    "enabled": true,
    "features": {
      "multiModelOrchestration": true,
      "backgroundAgents": true,
      "lspTools": true,
      "astRefactoring": true
    }
  }
}
```

### Requirements
- OpenCode v1.0.150 or later
- Node.js 18+
- API access to at least one LLM provider (Anthropic, OpenAI, or Google)

### Advanced Usage
- **Task Orchestration**: Automatically routes tasks to the best model
- **LSP Integration**: Use Language Server Protocol for intelligent code navigation
- **AST Refactoring**: Syntax-aware code transformations
- **Session Management**: Custom session persistence and replay

---

## plannotator

### Description
Interactive visual plan review and annotation tool for coding agent outputs.

### Repository
https://github.com/backnotprop/plannotator

### Key Features
- **Visual Plan Review**: Annotate plans with delete, insert, replace, comment actions
- **Inline Diff Review**: Line-by-line change annotation
- **No Backend Required**: Everything runs in your browser
- **URL Sharing**: Share plans via compressed URLs
- **Obsidian Integration**: Auto-save approved plans to Obsidian
- **Image Annotation**: Attach and annotate screenshots
- **Privacy-First**: All processing happens locally

### Installation

```bash
# Add to opencode.json (already done in this workspace)
# Then run installer:

# macOS/Linux/WSL
curl -fsSL https://plannotator.ai/install.sh | bash

# Windows PowerShell
irm https://plannotator.ai/install.ps1 | iex
```

### Configuration
Located in `.opencode/opencode.json`:
```json
{
  "plugin": ["@plannotator/opencode@latest"],
  "plannotator": {
    "enabled": true,
    "autoSaveToObsidian": false,
    "reviewDiffsVisually": true
  }
}
```

### Usage Workflow

1. **Generate Plan**: Let OpenCode create a coding plan
2. **Review**: Use `/plannotator-review` to open visual interface
3. **Annotate**: Mark sections for deletion, insertion, or modification
4. **Approve/Revise**: Either approve plan or send structured feedback
5. **Save**: Optionally save to Obsidian for documentation

### Example Commands
```
/plannotator-review          # Open plan review UI
submit_plan                  # Submit plan for review
```

---

## opencode-mem

### Description
Persistent memory system using local vector database to retain context across sessions.

### Repository
https://github.com/tickernelz/opencode-mem

### Key Features
- **Local Vector Database**: SQLite-based, privacy-focused storage
- **Persistent Memory**: Remember project decisions, code changes, user preferences
- **User Profile Learning**: Automatically adapt to user patterns
- **Web UI**: Full-featured interface at http://127.0.0.1:4747
- **Multi-Provider Support**: Works with OpenAI, Anthropic, local models
- **12+ Embedding Models**: Choose from various local and cloud embedding models
- **Timeline View**: Visual, searchable timeline of memories

### Installation

```bash
# Automatically installed by OpenCode when configured in opencode.json
# Or manually:
npm install opencode-mem
```

### Configuration
Located in `.opencode/opencode-mem.jsonc`:
```jsonc
{
  "storagePath": "~/.opencode-mem/data",
  "embeddingModel": "Xenova/nomic-embed-text-v1",
  "webServerEnabled": true,
  "webServerPort": 4747,
  "maxMemories": 100,
  "memoryProvider": "openai-chat",
  "enableUserProfile": true
}
```

### Usage Examples

```javascript
// Add a memory
memory({ 
  mode: "add", 
  content: "Project uses microservices architecture with Docker" 
})

// Search memories
memory({ 
  mode: "search", 
  query: "architecture decisions" 
})

// View user profile
memory({ mode: "profile" })

// List recent memories
memory({ mode: "list", limit: 10 })

// Delete a memory
memory({ mode: "delete", id: "memory-id-here" })
```

### Web UI Access
Open http://127.0.0.1:4747 in your browser to:
- Browse all memories
- Search by keywords
- View timeline
- Manage user profile
- Export/import memories

### Embedding Models
Available models (local):
- `Xenova/nomic-embed-text-v1` (default, recommended)
- `Xenova/all-MiniLM-L6-v2`
- `Xenova/bge-small-en-v1.5`
- Many more...

### macOS Apple Silicon Note
May require Homebrew SQLite:
```bash
brew install sqlite3
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
```

---

## opencode-model-announcer

### Description
Automatically injects the current model name into chat context for model self-awareness.

### Repository
https://github.com/ramarivera/opencode-model-announcer

### Key Features
- **Model Self-Awareness**: LLM knows which model it is
- **Prevents Hallucination**: Avoids incorrect model self-identification
- **Audit Trail**: Clear record of which model responded
- **Multi-Provider Support**: Works with all OpenCode providers
- **Automatic Injection**: No manual intervention needed

### Installation

```bash
# Automatically installed by OpenCode when configured in opencode.json
```

### Configuration
Located in `.opencode/opencode.json`:
```json
{
  "plugin": ["opencode-model-announcer"],
  "opencode-model-announcer": {
    "enabled": true,
    "announceAtStartup": true
  }
}
```

### How It Works
When you start a conversation, the plugin automatically injects information like:
```
Current model: anthropic/claude-opus-4-5-thinking
Provider: Anthropic
Session ID: abc-123-def
```

This ensures the model:
- Knows its own identity
- Provides accurate information about its capabilities
- Avoids confusing itself with other models

### Use Cases
- **Debugging**: Track which model generated which response
- **Compliance**: Audit trail for model usage
- **Quality Assurance**: Verify correct model is being used
- **Multi-Model Workflows**: Clear identification when switching models

---

## Integration Example

Here's how all four plugins work together:

1. **oh-my-opencode** orchestrates your coding session with multiple models
2. **opencode-model-announcer** ensures each model knows its identity
3. **opencode-mem** remembers your project context and preferences
4. **plannotator** lets you visually review and refine plans before execution

### Typical Workflow

```
1. Start OpenCode
   ↓
2. oh-my-opencode loads and configures multi-model orchestration
   ↓
3. opencode-model-announcer injects model identity
   ↓
4. opencode-mem retrieves relevant project memories
   ↓
5. You request a feature implementation
   ↓
6. OpenCode generates a plan
   ↓
7. plannotator opens for visual review
   ↓
8. You annotate and approve
   ↓
9. opencode-mem stores the implementation decision
   ↓
10. Code is generated using best model for each task
```

---

## Troubleshooting

### Plugin Not Loading
```bash
# Check OpenCode version
opencode --version  # Should be v1.0.150+

# Verify plugin configuration
cat .opencode/opencode.json

# Check OpenCode logs
tail -f ~/.opencode/logs/opencode.log
```

### Memory Plugin Web UI Not Accessible
```bash
# Check if port is in use
lsof -i :4747

# Verify plugin is enabled
cat .opencode/opencode-mem.jsonc

# Restart OpenCode
pkill opencode
opencode
```

### oh-my-opencode Installation Issues
```bash
# Clear cache and reinstall
rm -rf ~/.oh-my-opencode
bunx oh-my-opencode install

# Check Node.js version
node --version  # Should be 18+
```

---

## Additional Resources

- [OpenCode Official Docs](https://opencode.ai/docs)
- [OpenCode Plugins Guide](https://opencode.ai/docs/plugins)
- [awesome-opencode Community](https://github.com/awesome-opencode/awesome-opencode)
- [OpenCode Discord Community](https://discord.gg/opencode)

---

Last updated: 2026-01-31
