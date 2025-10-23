FROM node:20-slim

# Set Ansible version
ARG ANSIBLE_VERSION=2.15.5

# Install system dependencies and Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible with specific version
RUN pip3 install ansible-core==${ANSIBLE_VERSION}

# Verify installations
RUN node --version && \
    python3 --version && \
    git --version && \
    ansible --version

# Set working directory
WORKDIR /workspace

CMD ["bash"]