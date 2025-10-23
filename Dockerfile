FROM node:25.0.0-slim

# Set Ansible version
ARG ANSIBLE_VERSION=2.19.3

# Image description (can be overridden via build arg if you want)
ARG IMAGE_DESCRIPTION="Docker image with Node, Git, Python and Ansible (ansible-core=${ANSIBLE_VERSION})"

# Install system dependencies and Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible with specific version
RUN pip3 install ansible-core==${ANSIBLE_VERSION} --break-system-packages

# OCI label: description (recommended for registry UI and multi-arch manifests)
LABEL org.opencontainers.image.description="${IMAGE_DESCRIPTION}"

# Verify installations
RUN node --version && \
    python3 --version && \
    git --version && \
    ansible --version

# Set working directory
WORKDIR /workspace

CMD ["bash"]
