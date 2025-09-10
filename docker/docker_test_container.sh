apt-get update -y
apt-get install -y sudo

# Create a new user (e.g., dev)
useradd -m -s /bin/bash dev

# Set a password (optional)
echo "dev:dev" | chpasswd

# Give the user sudo privileges without password
usermod -aG sudo dev
echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to new user
su - dev
