ARG DockerimageInheritFrom
FROM $DockerimageInheritFrom as base_container

ARG DockerUSER=${CONTAINER_USER}
ARG DockerUID=${CONTAINER_UID}
ARG DockerGID=${CONTAINER_GID}
ARG DockerPW=docker

# pre configure tzdata
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone
# To support cntlm proxy add following lines to ~/.docker/config.json
# proxies": {
#     "default": {
#         "httpProxy": "http://127.0.0.1:3128",
#         "httpsProxy": "http://127.0.0.1:3128",
#         "noProxy": "localhost,127.0.0.1"
#     }
# }

RUN apt-get update && apt-get install -y\
    curl \
    zip \
    tree \
    wget \
    git \
    make \
    musl-dev \
    libffi-dev \
    openssl \
    gnupg \
    lsb-release \
    libssl-dev \
    ca-certificates \
    apt-transport-https \
    cargo \
    python3-pip \
    python3-dev \
    npm \
    node.js 

# Download and install the Microsoft signing key
# RUN curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
#     gpg --dearmor | \
#     tee /usr/share/keyrings/microsoft.gpg > /dev/null \
#     chmod go+r /usr/share/keyrings/microsoft.gpg

# Add Linux Software Repository for Microsoft Products
RUN curl -sSL -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az config set extension.use_dynamic_install=yes_without_prompt
# Setting REQUESTS_CA_BUNDLE environment variable for az login command behind a proxy
RUN export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# .NET
RUN apt-get update && apt-get install -y --fix-missing \
    dotnet-runtime-8.0 \
    dotnet-sdk-6.0

RUN dotnet tool install -g Microsoft.dotnet-httprepl
#&& dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org

# NVM
ENV NODE_VERSION=16.15.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Node js
# RUN nvm install 16.15.0
# RUN nvm use 16.15.0

# Install Angular
RUN npm install -g @angular/cli

# Azurite Storage Emulator & Function Core Tools v4
RUN npm install -g azure-functions-core-tools@4 --unsafe-perm true --force \
    && npm install -g azurite

# Installing K3D for local Kubernetes development
RUN curl -s "https://raw.githubusercontent.com/rancher/k3d/main/install.sh" | bash

# Kubernetes CLI
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# setup container user equal to host user
RUN groupadd --gid ${DockerGID} ${DockerUSER} && \ 
    # Remark: it is important to use '--no-log-init'.
    # without, long user-ids (e.g. in osd) will cause docker crash and to fill up all disk space
    useradd --no-log-init --create-home ${DockerUSER} --uid ${DockerUID} --gid ${DockerGID} && \
    echo "${DockerUSER}:${DockerPW}" | chpasswd && \
    usermod -aG sudo ${DockerUSER}

USER ${DockerUID}:${DockerGID}
WORKDIR /home/$DockerUSER