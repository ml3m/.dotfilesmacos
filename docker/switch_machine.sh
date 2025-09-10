#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Variables
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"  # Get the directory of the script
BREWFILE="$DOTFILES_DIR/Brewfile"

echo "Starting macOS setup using dotfiles..."

# 1. Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# 2. Install packages from Brewfile
if [ -f "$BREWFILE" ]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$BREWFILE"
else
    echo "Brewfile not found. Skipping Homebrew package installation."
fi

# 3. Install GNU Stow
if ! command -v stow &>/dev/null; then
    echo "Installing GNU Stow..."
    brew install stow
else
    echo "GNU Stow is already installed."
fi

# 4. Prompt user to select packages to stow
echo "Available dotfile packages:"
DOTFILE_PACKAGES=($(ls -d "$DOTFILES_DIR"/*/ | xargs -n 1 basename))  # List all subdirectories
for i in "${!DOTFILE_PACKAGES[@]}"; do
    echo "$((i + 1)). ${DOTFILE_PACKAGES[$i]}"
done

echo "Enter the numbers of the packages you want to stow (e.g., 1 3 5):"
read -r SELECTED_PACKAGES

# Validate user input and stow selected packages
for i in $SELECTED_PACKAGES; do
    if [[ $i -gt 0 && $i -le ${#DOTFILE_PACKAGES[@]} ]]; then
        PACKAGE="${DOTFILE_PACKAGES[$((i - 1))]}"
        echo "Stowing $PACKAGE..."
        stow -d "$DOTFILES_DIR" -t "$HOME" "$PACKAGE"
    else
        echo "Invalid selection: $i. Skipping..."
    fi
done

# 5. Run custom scripts
SCRIPTS_DIR="$DOTFILES_DIR/scripts/bin"
if [ -d "$SCRIPTS_DIR" ]; then
    echo "Running custom scripts..."
    for script in "$SCRIPTS_DIR/"*; do
        chmod +x "$script"
        "$script"
    done
else
    echo "Scripts directory not found. Skipping custom script execution."
fi

# 6. Apply macOS preferences
echo "Applying macOS preferences..."
# instant dock animation.
defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock

echo "Setup complete!"
