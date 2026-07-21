FROM alpine/git AS install

RUN echo "unknow" > /git-version.txt

# If the --dirty flag is left out, only the .git directory has to be copied
COPY . /git/

RUN find . -type d -name .git -exec git describe --always --dirty > /git-version.txt \;

FROM node:25.9.0-trixie-slim

# Install system dependencies and Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip git vim jq bash-completion docker.io openssh-client ssh-askpass && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user with a stable UID/GID (CI-safe)
RUN userdel -r node && \
    groupadd -g 1000 ciuser && \
    useradd -m -u 1000 -g 1000 ciuser

# Copy requirements files
COPY pip-requirements.txt .

# Install Python packages
RUN pip3 install -r pip-requirements.txt --break-system-packages

# Copy git-verion.txt from install step
COPY --from=install /git-version.txt /git-version.txt

# Prepare work directory
WORKDIR /etc/ansible
RUN mkdir -p /etc/ansible && \
    chown -R ciuser:ciuser /etc/ansible

# Enable passwordless root access
# RUN passwd -d root

# Switch to non-root user
USER ciuser

# Add .ssh folder
RUN mkdir /home/ciuser/.ssh

# Copy requirements files
COPY requirements.yml .

# Install Ansible collections
RUN ansible-galaxy collection install -r requirements.yml

RUN node --version && \
    python3 --version && \
    git --version && \
    ansible --version && \
    ansible-galaxy collection list

CMD ["/bin/bash"]
