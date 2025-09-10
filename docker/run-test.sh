#!/bin/bash

# Create a container with a user that has sudo access
docker run -it --rm -v $(pwd):/scripts ubuntu:22.04 bash -c "
# Update package list and install sudo
apt-get update && apt-get install -y sudo

# Create a user with sudo access
useradd -m -s /bin/bash testuser
echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the user and start bash
su - testuser -c 'cd /scripts && bash'
"
