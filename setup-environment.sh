#!/bin/bash
# OpenCode Environment Setup Script
# This script installs nvm, rust, conda, and docker

set -e

echo "======================================"
echo "OpenCode Environment Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check if running on supported OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

print_info "Detected OS: $MACHINE"
echo ""

# Install NVM (Node Version Manager)
install_nvm() {
    echo "Installing NVM (Node Version Manager)..."
    if [ -d "$HOME/.nvm" ]; then
        print_info "NVM already installed"
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        print_success "NVM installed successfully"
    fi
    
    # Install latest LTS Node.js
    print_info "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    print_success "Node.js $(node --version) installed"
}

# Install Rust
install_rust() {
    echo ""
    echo "Installing Rust..."
    if command -v rustc &> /dev/null; then
        print_info "Rust already installed: $(rustc --version)"
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        print_success "Rust installed successfully: $(rustc --version)"
    fi
}

# Install Conda (Miniconda)
install_conda() {
    echo ""
    echo "Installing Conda (Miniconda)..."
    if command -v conda &> /dev/null; then
        print_info "Conda already installed: $(conda --version)"
    else
        if [ "$MACHINE" = "Linux" ]; then
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
        elif [ "$MACHINE" = "Mac" ]; then
            if [ "$(uname -m)" = "arm64" ]; then
                wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O /tmp/miniconda.sh
            else
                wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O /tmp/miniconda.sh
            fi
        fi
        
        bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
        rm /tmp/miniconda.sh
        
        # Initialize conda
        "$HOME/miniconda3/bin/conda" init bash
        print_success "Conda installed successfully"
    fi
}

# Install Docker
install_docker() {
    echo ""
    echo "Installing Docker..."
    if command -v docker &> /dev/null; then
        print_info "Docker already installed: $(docker --version)"
    else
        if [ "$MACHINE" = "Linux" ]; then
            # Install Docker on Linux
            curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
            sudo sh /tmp/get-docker.sh
            sudo usermod -aG docker $USER
            rm /tmp/get-docker.sh
            print_success "Docker installed successfully"
            print_info "You may need to log out and back in for Docker group permissions"
        elif [ "$MACHINE" = "Mac" ]; then
            print_error "Please install Docker Desktop for Mac manually from: https://www.docker.com/products/docker-desktop"
            print_info "Docker Desktop installation requires manual download and installation"
        fi
    fi
}

# Main installation sequence
main() {
    print_info "Starting installation of development tools..."
    echo ""
    
    install_nvm
    install_rust
    install_conda
    install_docker
    
    echo ""
    echo "======================================"
    print_success "Setup Complete!"
    echo "======================================"
    echo ""
    print_info "Please restart your terminal or run:"
    echo "  source ~/.bashrc  # or ~/.zshrc if using zsh"
    echo ""
    print_info "Installed tools:"
    echo "  - NVM (Node Version Manager)"
    echo "  - Rust and Cargo"
    echo "  - Conda (Miniconda)"
    echo "  - Docker"
    echo ""
}

# Run main installation
main
