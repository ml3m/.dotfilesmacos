# .dotfilesmacos

This repository contains configuration files for macOS, including settings for various applications and shell environments.

## Contents

- **config/**: Directory for application-specific configurations
- **git/**: Git configuration files
- **tmux/**: tmux configuration files
- **zsh/**: Zsh configuration files

## Setup

To set up these dotfiles on your macOS system using GNU Stow, follow these steps:

1. Clone this repository to your home directory:
    ```sh
    git clone https://github.com/ml3m/.dotfilesmacos.git ~/.dotfilesmacos
    ```

2. Navigate to the cloned directory:
    ```sh
    cd ~/.dotfilesmacos
    ```

3. Use Stow to create symlinks for each set of dotfiles:
    ```sh
    stow config
    stow git
    stow tmux
    stow zsh
    ```

## Customization

Feel free to customize these files according to your needs. Below is a brief overview of what each directory contains:

- **config/**: Application-specific configurations.
- **git/**: Configurations for Git, including user details and aliases.
- **tmux/**: Customizations for the tmux terminal multiplexer.
- **zsh/**: Zsh shell settings, including aliases, functions, and environment variables.

## Contributing

Contributions are welcome! If you have any improvements or suggestions, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
