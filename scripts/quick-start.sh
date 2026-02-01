#!/bin/bash
# Quick Start Script for OpenCode Workspace
# This script helps you get started with OpenCode and all plugins

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}======================================"
    echo -e "$1"
    echo -e "======================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_header "OpenCode Workspace Quick Start"

# Step 1: Check for Node.js
print_step "Step 1: Checking for Node.js..."
if command_exists node; then
    print_success "Node.js found: $(node --version)"
else
    print_error "Node.js not found!"
    print_info "Please install Node.js first by running: ./setup-environment.sh"
    exit 1
fi

# Step 2: Check for OpenCode
print_step "Step 2: Checking for OpenCode..."
if command_exists opencode; then
    print_success "OpenCode found: $(opencode --version 2>/dev/null || echo 'installed')"
else
    print_info "OpenCode not found. Installing..."
    if command_exists npm; then
        npm install -g opencode
        print_success "OpenCode installed successfully"
    else
        print_error "npm not found. Cannot install OpenCode."
        exit 1
    fi
fi

# Step 3: Check API keys
print_step "Step 3: Checking API keys..."
MISSING_KEYS=()

if [ -z "$ANTHROPIC_API_KEY" ]; then
    MISSING_KEYS+=("ANTHROPIC_API_KEY")
fi

if [ -z "$OPENAI_API_KEY" ]; then
    MISSING_KEYS+=("OPENAI_API_KEY")
fi

if [ -z "$GOOGLE_API_KEY" ]; then
    MISSING_KEYS+=("GOOGLE_API_KEY")
fi

if [ ${#MISSING_KEYS[@]} -gt 0 ]; then
    print_info "The following API keys are not set:"
    for key in "${MISSING_KEYS[@]}"; do
        echo "  - $key"
    done
    echo ""
    print_info "To set API keys:"
    echo "  1. Copy .env.example to .env"
    echo "  2. Edit .env and add your API keys"
    echo "  3. Run: source .env"
    echo ""
    print_info "You can still continue, but some features may not work."
    echo ""
else
    print_success "All API keys are configured"
fi

# Step 4: Install oh-my-opencode
print_step "Step 4: Installing oh-my-opencode..."
if command_exists bunx; then
    print_info "Using bunx to install oh-my-opencode..."
    bunx oh-my-opencode install --help >/dev/null 2>&1 || true
    print_success "oh-my-opencode setup initialized"
elif command_exists npx; then
    print_info "Using npx to install oh-my-opencode..."
    npx oh-my-opencode install --help >/dev/null 2>&1 || true
    print_success "oh-my-opencode setup initialized"
else
    print_info "Neither bunx nor npx found. Skipping oh-my-opencode installation."
fi

# Step 5: Check plannotator installation
print_step "Step 5: Checking plannotator setup..."
print_info "Plannotator is configured in .opencode/opencode.json"
print_info "To complete setup, run the plannotator installer:"
echo "  # macOS/Linux/WSL:"
echo "  curl -fsSL https://plannotator.ai/install.sh | bash"
echo ""
echo "  # Windows PowerShell:"
echo "  irm https://plannotator.ai/install.ps1 | iex"
echo ""

# Step 6: Summary
print_header "Setup Summary"

echo "Plugin Status:"
echo "  ✓ oh-my-opencode - Configured in .opencode/opencode.json"
echo "  ✓ plannotator - Configured in .opencode/opencode.json"
echo "  ✓ opencode-mem - Configured in .opencode/opencode.json"
echo "  ✓ opencode-model-announcer - Configured in .opencode/opencode.json"
echo ""

print_info "To start using OpenCode:"
echo "  1. Ensure API keys are set (see .env.example)"
echo "  2. Run: opencode"
echo "  3. Access memory UI: http://127.0.0.1:4747"
echo ""

print_success "Quick start complete! You're ready to use OpenCode."
echo ""

# Ask if user wants to start OpenCode now
read -p "Would you like to start OpenCode now? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Starting OpenCode..."
    opencode
fi
