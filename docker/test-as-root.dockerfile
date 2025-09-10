# Test Dockerfile for setup script as root (like your container)
FROM ubuntu:22.04

# Install basic tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /scripts/setup_dir

# Copy the setup script
COPY scripts/bin/setup.sh /scripts/setup_dir/setup.sh
RUN chmod +x /scripts/setup_dir/setup.sh

# Create minimal dotfiles structure for testing
RUN mkdir -p nvim tmux zsh git && \
    echo "# minimal nvim config" > nvim/.vimrc && \
    echo "# minimal tmux config" > tmux/.tmux.conf && \
    echo "# minimal zsh config" > zsh/.zshrc && \
    echo "[user]\n\tname = test\n\temail = test@example.com" > git/.gitconfig

CMD ["/bin/bash"]
