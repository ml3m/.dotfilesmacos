FROM ubuntu:22.04

# Non-interactive for apt
ENV DEBIAN_FRONTEND=noninteractive

# Copy scripts
COPY setup.sh cleanup.sh /scripts/
WORKDIR /scripts
RUN chmod +x setup.sh cleanup.sh

# Start with bash for testing
CMD ["/bin/bash"]
