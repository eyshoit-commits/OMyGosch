# OpenCode Workspace

A comprehensive development workspace configured with OpenCode AI coding agent and essential plugins.

## 🚀 Overview

This workspace is configured with OpenCode and four powerful plugins to enhance your AI-assisted coding experience:

1. **oh-my-opencode** - Advanced agent orchestrator with multi-model support
2. **plannotator** - Visual plan review and annotation system
3. **opencode-mem** - Persistent memory with local vector database
4. **opencode-model-announcer** - Model awareness and self-identification

## 📋 Prerequisites

- Linux, macOS, or WSL (Windows Subsystem for Linux)
- Bash shell
- Internet connection for downloading dependencies
- API keys for AI providers (Anthropic, OpenAI, Google - optional but recommended)

## 🛠️ Quick Start

### 1. Install Development Tools

Run the environment setup script to install nvm, Rust, Conda, and Docker:

```bash
./setup-environment.sh
```

This script will install:
- **NVM** (Node Version Manager) and Node.js LTS
- **Rust** and Cargo
- **Conda** (Miniconda for Python environments)
- **Docker** (container platform)

After installation, restart your terminal or run:
```bash
source ~/.bashrc  # or ~/.zshrc if using zsh
```

### 2. Install OpenCode

Install OpenCode (requires Node.js from step 1):

```bash
npm install -g opencode
# or
yarn global add opencode
# or
pnpm add -g opencode
```

Verify installation:
```bash
opencode --version
```

### 3. Configure API Keys

Set up your AI provider API keys as environment variables. Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
export ANTHROPIC_API_KEY="your-anthropic-api-key"
export OPENAI_API_KEY="your-openai-api-key"
export GOOGLE_API_KEY="your-google-api-key"
```

Then reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### 4. Install OpenCode Plugins

The plugins are already configured in `.opencode/opencode.json`. OpenCode will automatically install them on first run.

Alternatively, you can manually install each plugin:

#### oh-my-opencode
```bash
bunx oh-my-opencode install
# or
npx oh-my-opencode install
```

#### plannotator
Add to your OpenCode config (already done in this workspace):
```json
{
  "plugin": ["@plannotator/opencode@latest"]
}
```

Then run the installation script:
```bash
# macOS/Linux/WSL
curl -fsSL https://plannotator.ai/install.sh | bash

# Windows PowerShell
irm https://plannotator.ai/install.ps1 | iex
```

#### opencode-mem
The plugin is already configured. It will be installed automatically by OpenCode.

#### opencode-model-announcer
The plugin is already configured. It will be installed automatically by OpenCode.

## 📁 Project Structure

```
.
├── .opencode/
│   ├── opencode.json           # Main OpenCode configuration
│   ├── opencode-mem.jsonc      # Memory plugin configuration
│   └── plugins/                # Local plugin directory
├── setup-environment.sh        # Development tools installer
├── .gitignore                  # Git ignore rules
├── LICENSE                     # License file
└── README.md                   # This file
```

## 🔧 Configuration

### OpenCode Configuration (`.opencode/opencode.json`)

The main configuration file includes:
- Plugin list (all four required plugins)
- Model provider settings (Anthropic, OpenAI, Google)
- Plugin-specific configurations

### Memory Plugin Configuration (`.opencode/opencode-mem.jsonc`)

Configures the persistent memory system:
- Local SQLite database storage
- Embedding model (Xenova/nomic-embed-text-v1)
- Web UI on port 4747
- Memory limits and search settings

## 🎯 Plugin Features

### 1. oh-my-opencode
- **Multi-model orchestration**: Coordinate teams of specialized agents
- **30+ custom tools**: LSP operations, AST-aware refactoring
- **Background agents**: Continuous code analysis
- **Lifecycle hooks**: 22+ extensibility points
- **Claude Code compatibility**: Use existing Claude Code plugins

### 2. plannotator
- **Visual plan review**: Annotate agent-generated plans
- **Inline diff review**: Line-by-line change annotation
- **Collaboration**: Share plans via URL (no backend needed)
- **Obsidian integration**: Auto-save approved plans
- **Privacy-first**: Runs locally in your browser

### 3. opencode-mem
- **Persistent memory**: Retain context across sessions
- **Local vector database**: SQLite-based, privacy-focused
- **Web UI**: Browse memories at http://127.0.0.1:4747
- **User profiling**: Adaptive learning of preferences
- **Multi-provider support**: Works with OpenAI, Anthropic, local models

Usage examples:
```javascript
// Add memory
memory({ mode: "add", content: "Project uses microservices" })

// Search memory
memory({ mode: "search", query: "architecture decisions" })

// View profile
memory({ mode: "profile" })
```

### 4. opencode-model-announcer
- **Model awareness**: Announces active AI model in context
- **Prevents hallucination**: Model knows its own identity
- **Audit trail**: Clear record of which model responded
- **Multi-provider support**: Works with all OpenCode providers

## 🚀 Usage

### Starting OpenCode

```bash
opencode
```

OpenCode will:
1. Load the configuration from `.opencode/opencode.json`
2. Install any missing plugins automatically
3. Start the coding assistant with all plugins active

### Using Memory Plugin Web UI

Access the memory management interface:
```bash
# Memory plugin will start automatically with OpenCode
# Open in browser:
open http://127.0.0.1:4747
```

### Using Plannotator

When OpenCode generates a plan, use:
```
/plannotator-review
```
This opens the visual annotation interface in your browser.

## 🔍 Verification

Check that all plugins are loaded:

```bash
# In OpenCode, you should see messages about loaded plugins
# Check OpenCode status
opencode status

# Verify memory plugin
curl http://127.0.0.1:4747

# Check installed packages
npm list -g opencode oh-my-opencode
```

## 🐛 Troubleshooting

### Plugins not loading
- Ensure OpenCode version is v1.0.150 or later: `opencode --version`
- Check configuration syntax: `cat .opencode/opencode.json`
- Review OpenCode logs for errors

### Memory plugin Web UI not accessible
- Verify the plugin is enabled in configuration
- Check if port 4747 is available: `lsof -i :4747`
- Review memory plugin logs

### Docker installation issues on Mac
- Docker Desktop for Mac requires manual installation
- Download from: https://www.docker.com/products/docker-desktop

### API Key errors
- Verify environment variables are set: `echo $ANTHROPIC_API_KEY`
- Ensure keys are valid and have sufficient credits
- Check that keys are exported in your shell profile

## 📚 Additional Resources

- [OpenCode Documentation](https://opencode.ai/docs)
- [oh-my-opencode GitHub](https://github.com/code-yeongyu/oh-my-opencode)
- [plannotator GitHub](https://github.com/backnotprop/plannotator)
- [opencode-mem GitHub](https://github.com/tickernelz/opencode-mem)
- [opencode-model-announcer GitHub](https://github.com/ramarivera/opencode-model-announcer)

## 📄 License

See [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

---

**Note**: This workspace is configured for OpenCode v1.0.150+. For best results, ensure you have the latest version of OpenCode and all dependencies installed.
