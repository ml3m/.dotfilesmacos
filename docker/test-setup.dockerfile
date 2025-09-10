# Test Dockerfile for setup script
FROM ubuntu:22.04

# Install basic tools for testing
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for more realistic testing
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy the setup script
COPY scripts/bin/setup.sh /home/testuser/setup.sh
RUN chmod +x /home/testuser/setup.sh

# Create a minimal dotfiles structure for testing
RUN mkdir -p nvim tmux zsh git && \
    echo "# minimal nvim config" > nvim/.vimrc && \
    echo "# minimal tmux config" > tmux/.tmux.conf && \
    echo "# minimal zsh config" > zsh/.zshrc && \
    echo "[user]\n\tname = test\n\temail = test@example.com" > git/.gitconfig

CMD ["/bin/bash"]
