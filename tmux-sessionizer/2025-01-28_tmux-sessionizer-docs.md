---
date: 2025-01-28
time: 23:50:00
tags:
    - TMUX
hubs:
    - "[[TMUX]]"
urls:
    -
---

# tmux sessionizer docs

# Step-by-Step Tutorial: Setting Up `tmux-sessionizer` and Scripts on macOS

This tutorial will guide you through updating and configuring your `.dotfilesmacos` setup, stowing the necessary files, and binding `tmux-sessionizer` to `Ctrl+F` in your terminal.

---

## Step 1: Update Files in `.dotfilesmacos`

1. Remove the existing `tmux-sessionizer` and `scripts` directories from `.dotfilesmacos`:
   ```bash
   rm -rf ~/.dotfilesmacos/tmux-sessionizer ~/.dotfilesmacos/scripts
   ```

2. Move the updated `tmux-sessionizer` and `scripts` directories to `.dotfilesmacos`:
   ```bash
   mv ~/tmux-sessionizer ~/.dotfilesmacos
   mv ~/scripts ~/.dotfilesmacos
   ```

---

## Step 2: Configure `tmux-sessionizer`

1. Open the `directories` file located in:
   ```bash
   ~/.dotfilesmacos/tmux-sessionizer/.config/tmux-sessionizer/directories
   ```

2. Add the paths to the directories where `fzf` should search. For example:
   ```
   /path/to/your/projects
   /path/to/your/files
   ```

   `fzf` searches with a maximum depth of 2. (this can be modified in the tmux-sessionizer file)

---

## Step 3: Stow `tmux-sessionizer` and `scripts`

1. Use `stow` to symlink the `tmux-sessionizer` and `scripts` directories from `.dotfilesmacos`:
   ```bash
   cd ~/.dotfilesmacos
   stow tmux-sessionizer
   stow scripts
   ```

---

## Step 4: Add `scripts` to Your PATH

1. Create a `bin` directory in your home directory:
   ```bash
   mkdir ~/bin
   ```

2. Move the `scripts` directory to `~/bin`:
   ```bash
   mv ~/.dotfilesmacos/scripts ~/bin
   ```

3. Add `~/bin` to your `PATH` by editing your `.zshrc` file. Add the following line:
   ```bash
   export PATH="$HOME/bin:$PATH"
   ```

4. Reload your `.zshrc` file to apply the changes:
   ```bash
   source ~/.zshrc
   ```

---

## Step 5: Bind `tmux-sessionizer` to `Ctrl+F`

1. Open your `.zshrc` file and add the following line **before** the `export PATH` line:
   ```bash
   bindkey -s ^f "tmux-sessionizer\n"
   ```

   This binds the `Ctrl+F` key combination to the `tmux-sessionizer` command.

2. Save the file and reload your `.zshrc`:
   ```bash
   source ~/.zshrc
   ```

Enjoy your streamlined workflow!
