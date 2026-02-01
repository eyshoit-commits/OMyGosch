# OpenCode Setup Guide

This guide walks you through setting up the OpenCode workspace with all four plugins step-by-step.

## 🎯 Goal

Set up a complete OpenCode development environment with:
- **oh-my-opencode**: Multi-model agent orchestration
- **plannotator**: Visual plan review
- **opencode-mem**: Persistent memory system
- **opencode-model-announcer**: Model self-awareness

Plus development tools: nvm, Rust, Conda, and Docker.

---

## 📋 Prerequisites

- Linux, macOS, or Windows WSL
- Bash shell
- Internet connection
- Approximately 2GB free disk space

---

## 🚀 Installation Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/eyshoit-commits/workspace.git
cd workspace
```

### Step 2: Install Development Tools

Run the automated setup script to install nvm, Rust, Conda, and Docker:

```bash
./setup-environment.sh
```

This will:
- ✓ Install NVM (Node Version Manager)
- ✓ Install Node.js LTS via NVM
- ✓ Install Rust and Cargo
- ✓ Install Miniconda
- ✓ Install Docker (on Linux) or provide instructions (on Mac)

**Expected time**: 5-10 minutes

After installation, **restart your terminal** or run:
```bash
source ~/.bashrc  # or ~/.zshrc if using zsh
```

### Step 3: Verify Installations

Check that everything installed correctly:

```bash
# Check Node.js
node --version
# Should show: v20.x.x or similar

# Check Rust
rustc --version
# Should show: rustc 1.x.x

# Check Conda
conda --version
# Should show: conda x.x.x

# Check Docker
docker --version
# Should show: Docker version x.x.x
```

### Step 4: Configure API Keys

1. Copy the example environment file:
```bash
cp .env.example .env
```

2. Edit `.env` and add your API keys:
```bash
nano .env  # or use your preferred editor
```

3. Update these values:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_API_KEY="AI..."
```

4. Load the environment variables:
```bash
source .env
```

5. Add to your shell profile for persistence:
```bash
# For bash users
echo 'source /path/to/workspace/.env' >> ~/.bashrc

# For zsh users
echo 'source /path/to/workspace/.env' >> ~/.zshrc
```

**Where to get API keys:**
- Anthropic: https://console.anthropic.com/
- OpenAI: https://platform.openai.com/api-keys
- Google: https://makersuite.google.com/app/apikey

### Step 5: Install OpenCode

Install OpenCode globally:

```bash
npm install -g opencode
```

Or using the package.json script:

```bash
npm run install-opencode
```

Verify installation:
```bash
opencode --version
```

**Expected output**: `opencode v1.x.x` (should be v1.0.150 or later)

### Step 6: Run Quick Start

Execute the quick start script to verify everything:

```bash
./quick-start.sh
```

This script will:
- ✓ Check Node.js installation
- ✓ Check OpenCode installation
- ✓ Verify API keys are set
- ✓ Initialize oh-my-opencode
- ✓ Provide instructions for plannotator

### Step 7: Install oh-my-opencode

Install the oh-my-opencode plugin:

```bash
bunx oh-my-opencode install
```

Or if you don't have bun:

```bash
npx oh-my-opencode install
```

Follow the interactive prompts to:
- Select which AI providers you have access to
- Configure model preferences
- Set up custom tools

### Step 8: Install plannotator

Install the plannotator installer script:

**On macOS/Linux/WSL:**
```bash
curl -fsSL https://plannotator.ai/install.sh | bash
```

**On Windows PowerShell:**
```powershell
irm https://plannotator.ai/install.ps1 | iex
```

### Step 9: Verify Plugin Configuration

Check that all plugins are configured:

```bash
cat .opencode/opencode.json
```

You should see all four plugins listed:
```json
{
  "plugin": [
    "oh-my-opencode",
    "@plannotator/opencode@latest",
    "opencode-mem",
    "opencode-model-announcer"
  ]
}
```

### Step 10: Start OpenCode

Launch OpenCode:

```bash
opencode
```

Or using npm:

```bash
npm start
```

OpenCode will:
1. Load the configuration from `.opencode/opencode.json`
2. Automatically install any missing plugins (opencode-mem, opencode-model-announcer)
3. Start the memory plugin web server on port 4747
4. Activate all plugins

---

## ✅ Verification

### Check Plugin Status

Once OpenCode starts, verify all plugins are loaded:

1. **oh-my-opencode**: Should see initialization messages
2. **plannotator**: Run `/plannotator-review` to test
3. **opencode-mem**: Access http://127.0.0.1:4747 in browser
4. **opencode-model-announcer**: Should announce model at session start

### Test Memory Plugin

Open the memory UI:

```bash
open http://127.0.0.1:4747
# or visit manually in your browser
```

Or use npm script:

```bash
npm run memory-ui
```

### Test Commands

In OpenCode, try these commands:

```javascript
// Test memory plugin
memory({ mode: "add", content: "Test memory from setup" })
memory({ mode: "search", query: "setup" })
memory({ mode: "list", limit: 5 })

// Test plannotator
/plannotator-review
```

---

## 🔧 Troubleshooting

### Issue: "opencode: command not found"

**Solution:**
```bash
# Ensure npm global bin is in PATH
npm config get prefix
# Add this to PATH in ~/.bashrc or ~/.zshrc:
export PATH="$(npm config get prefix)/bin:$PATH"
source ~/.bashrc
```

### Issue: "Plugin failed to load"

**Solution:**
```bash
# Check OpenCode version (must be 1.0.150+)
opencode --version

# Clear OpenCode cache
rm -rf ~/.opencode/cache
rm -rf ~/.opencode/.cache

# Reinstall OpenCode
npm uninstall -g opencode
npm install -g opencode
```

### Issue: "Memory plugin web UI not accessible"

**Solution:**
```bash
# Check if port 4747 is in use
lsof -i :4747

# Kill any process using the port
kill -9 <PID>

# Restart OpenCode
opencode
```

### Issue: "API key not found"

**Solution:**
```bash
# Verify environment variables are set
echo $ANTHROPIC_API_KEY
echo $OPENAI_API_KEY
echo $GOOGLE_API_KEY

# Re-source the .env file
source .env

# Or add to shell profile
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.bashrc
source ~/.bashrc
```

### Issue: "oh-my-opencode installation fails"

**Solution:**
```bash
# Clear cache
rm -rf ~/.oh-my-opencode

# Update Node.js
nvm install --lts
nvm use --lts

# Try again
bunx oh-my-opencode install
```

### Issue: "Docker permission denied (Linux)"

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, then verify
docker run hello-world
```

---

## 📚 Next Steps

After successful setup:

1. **Read PLUGINS.md** - Learn about each plugin's features
2. **Explore Memory UI** - Visit http://127.0.0.1:4747
3. **Try oh-my-opencode features** - Multi-model orchestration
4. **Review a plan with plannotator** - Visual annotations
5. **Check out the README.md** - Full documentation

---

## 🎓 Learning Resources

- [OpenCode Documentation](https://opencode.ai/docs)
- [Plugin Guide](./PLUGINS.md)
- [oh-my-opencode Guide](https://github.com/code-yeongyu/oh-my-opencode)
- [plannotator Documentation](https://plannotator.ai/)
- [opencode-mem Repository](https://github.com/tickernelz/opencode-mem)

---

## 🆘 Getting Help

If you encounter issues:

1. Check this troubleshooting section
2. Review [PLUGINS.md](./PLUGINS.md) for plugin-specific help
3. Check the plugin repositories for issues/discussions
4. Join the OpenCode community Discord

---

## ✨ Quick Reference Commands

```bash
# Start OpenCode
opencode
# or
npm start

# Access Memory UI
open http://127.0.0.1:4747
# or
npm run memory-ui

# Run setup script
./setup-environment.sh

# Run quick start
./quick-start.sh

# Check plugin status
npm run check-plugins

# Install oh-my-opencode
npm run install-oh-my-opencode
```

---

**Congratulations!** 🎉

You now have a fully configured OpenCode workspace with all four plugins and development tools installed!

Happy coding with AI! 🚀
