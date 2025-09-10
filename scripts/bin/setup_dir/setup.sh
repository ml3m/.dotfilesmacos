#!/usr/bin/env bash
set -euo pipefail

# =====================================================
# MINIMAL CROSS-PLATFORM DOTFILES SETUP
# =====================================================
# Works on: Ubuntu, macOS, Arch Linux, Fedora, etc.
# Installs: neovim, python, zsh, git, tmux + configs

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Simple logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Error handling
error_exit() {
    log_error "$1"
    exit 1
}

# Detect OS and package manager
detect_system() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        if ! command -v brew &>/dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add to PATH
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        PKG_MANAGER="brew"
    elif command -v apt-get &>/dev/null; then
        OS="ubuntu"
        PKG_MANAGER="apt"
    elif command -v dnf &>/dev/null; then
        OS="fedora"
        PKG_MANAGER="dnf"
    elif command -v pacman &>/dev/null; then
        OS="arch"
        PKG_MANAGER="pacman"
    elif command -v zypper &>/dev/null; then
        OS="opensuse"
        PKG_MANAGER="zypper"
    else
        error_exit "Unsupported system. Please install packages manually."
    fi
    
    log_success "Detected: $OS using $PKG_MANAGER"
}

# Install packages based on system
install_packages() {
    log_info "Installing core packages..."
    
    case "$PKG_MANAGER" in
        "brew")
            brew install neovim python3 zsh git tmux stow fzf ripgrep curl
            ;;
        "apt")
            sudo apt-get update
            sudo apt-get install -y neovim python3 python3-pip python3-venv zsh git tmux stow fzf ripgrep curl build-essential
            ;;
        "dnf")
            sudo dnf install -y neovim python3 python3-pip zsh git tmux stow fzf ripgrep curl gcc gcc-c++ make
            ;;
        "pacman")
            sudo pacman -Syu --noconfirm neovim python python-pip zsh git tmux stow fzf ripgrep curl base-devel
            ;;
        "zypper")
            sudo zypper install -y neovim python3 python3-pip zsh git tmux stow fzf ripgrep curl gcc gcc-c++ make
            ;;
    esac
    
    log_success "Core packages installed"
}

# Setup Python environment management
setup_python() {
    log_info "Setting up Python environment management..."
    
    # Install/upgrade pip
    python3 -m pip install --user --upgrade pip
    
    # Install virtualenv for environment management
    python3 -m pip install --user virtualenv
    
    # Create a default virtual environment
    if [[ ! -d "$HOME/.venvs/default" ]]; then
        log_info "Creating default Python virtual environment..."
        python3 -m venv "$HOME/.venvs/default"
        source "$HOME/.venvs/default/bin/activate"
        pip install --upgrade pip setuptools wheel
        deactivate
        log_success "Default Python environment created at ~/.venvs/default"
    fi
    
    log_success "Python environment management configured"
}

# Install Oh My Zsh and plugins
setup_zsh() {
    log_info "Setting up Zsh with Oh My Zsh..."
    
    # Install Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    fi
    
    # Install zsh-autosuggestions
    local autosuggestions_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if [[ ! -d "$autosuggestions_dir" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$autosuggestions_dir"
        log_success "zsh-autosuggestions installed"
    fi
    
    # Install zsh-syntax-highlighting
    local highlighting_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if [[ ! -d "$highlighting_dir" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$highlighting_dir"
        log_success "zsh-syntax-highlighting installed"
    fi
    
    # Change default shell to zsh
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Changing default shell to zsh..."
        sudo chsh -s $(which zsh) $(whoami)
        log_warning "Please restart your terminal to use zsh"
    fi
}

# Install Neovim package manager
setup_neovim() {
    log_info "Setting up Neovim with Packer..."
    
    local packer_dir="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    
    if [[ ! -d "$packer_dir" ]]; then
        mkdir -p "$(dirname "$packer_dir")"
        git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
        log_success "Packer installed for Neovim"
        log_warning "Run ':PackerSync' in Neovim to install plugins"
    fi
}

# Install Tmux Plugin Manager
setup_tmux() {
    log_info "Setting up Tmux Plugin Manager..."
    
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    
    if [[ ! -d "$tpm_dir" ]]; then
        mkdir -p "$(dirname "$tpm_dir")"
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log_success "Tmux Plugin Manager installed"
        log_warning "Press 'prefix + I' in tmux to install plugins"
    fi
}

# Create necessary directories
create_directories() {
    log_info "Creating necessary directories..."
    
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.venvs"
    
    log_success "Directories created"
}

# Clone dotfiles repository
clone_dotfiles() {
    log_info "Setting up dotfiles repository..."
    
    local dotfiles_dir="$HOME/.dotfilesmacos"
    local repo_url="https://github.com/ml3m/.dotfilesmacos.git"
    
    if [[ -d "$dotfiles_dir" ]]; then
        log_success "Dotfiles directory already exists"
        cd "$dotfiles_dir"
        
        # Update existing repository
        if [[ -d ".git" ]]; then
            log_info "Updating existing dotfiles repository..."
            git pull origin main || log_warning "Could not update repository"
        fi
    else
        log_info "Cloning dotfiles repository..."
        git clone "$repo_url" "$dotfiles_dir"
        
        if [[ $? -eq 0 ]]; then
            log_success "Dotfiles repository cloned successfully"
            cd "$dotfiles_dir"
        else
            error_exit "Failed to clone dotfiles repository"
        fi
    fi
}

# Stow configuration files
stow_configs() {
    log_info "Setting up configuration files with stow..."
    
    # Ensure we're in the dotfiles directory
    local dotfiles_dir="$HOME/.dotfilesmacos"
    if [[ ! -d "$dotfiles_dir" ]]; then
        error_exit "Dotfiles directory not found at $dotfiles_dir"
    fi
    
    cd "$dotfiles_dir"
    
    # Essential configurations only - focus on core development tools
    local configs=("nvim" "tmux" "zsh" "git")
    
    for config in "${configs[@]}"; do
        if [[ -d "$config" ]]; then
            log_info "Stowing $config..."
            stow "$config" 2>/dev/null || log_warning "Some $config files may already exist"
            log_success "$config configuration linked"
        else
            log_warning "$config directory not found, skipping..."
        fi
    done
    
    # Also install tmux-sessionizer script to ~/.local/bin
    if [[ -f "scripts/bin/tmux-sessionizer" ]]; then
        log_info "Installing tmux-sessionizer script..."
        cp "scripts/bin/tmux-sessionizer" "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/tmux-sessionizer"
        log_success "tmux-sessionizer installed to ~/.local/bin"
    fi
}

# Add essential PATH exports
setup_environment() {
    log_info "Setting up environment variables..."
    
    # Add to .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        # Add Python user bin to PATH
        if ! grep -q "python.*bin" "$HOME/.zshrc"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        fi
        
        # Add XDG_CONFIG_HOME
        if ! grep -q "XDG_CONFIG_HOME" "$HOME/.zshrc"; then
            echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> "$HOME/.zshrc"
        fi
        
        log_success "Environment variables added to .zshrc"
    fi
}

# Final instructions
final_instructions() {
    echo
    log_success "🎉 Minimal setup complete!"
    echo
    echo "Next steps:"
    echo "1. Restart your terminal (or run: exec zsh)"
    echo "2. Open neovim and run: :PackerSync"
    echo "3. In tmux, press: Ctrl-b + I (to install tmux plugins)"
    echo "4. To activate default Python env: source ~/.venvs/default/bin/activate"
    echo
    echo "What's configured:"
    echo "✅ Neovim with Packer plugin manager"
    echo "✅ Python with virtual environment support"
    echo "✅ Zsh with Oh My Zsh, autosuggestions, syntax highlighting"
    echo "✅ Git configuration"
    echo "✅ Tmux with plugin manager"
    echo
}

# Main execution
main() {
    echo "🚀 Starting minimal dotfiles setup..."
    echo
    
    detect_system
    install_packages
    create_directories
    clone_dotfiles
    setup_python
    setup_zsh
    setup_neovim
    setup_tmux
    stow_configs
    setup_environment
    final_instructions
}

# Run main function
main "$@"
