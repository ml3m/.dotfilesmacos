apt-get update -y
apt-get install -y sudo
useradd -m -s /bin/bash dev
echo "dev:dev" | chpasswd
usermod -aG sudo dev
echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
su - dev
