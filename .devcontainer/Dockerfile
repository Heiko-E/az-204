#FROM mcr.microsoft.com/azure-cli:2.62.0-cbl-mariner2.0
#FROM mcr.microsoft.com/devcontainers/javascript-node:1-20-bookworm
FROM mcr.microsoft.com/azure-cli

RUN apt-get update && apt-get install -y \
    curl \
    git \
    npm \
    node \
    nodejs

RUN curl -sSL -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# dotnet
RUN apt-get update && apt-get install -y \
    dotnet-runtime-8.0 \
    dotnet-runtime-8.0

RUN dotnet tool install -g Microsoft.dotnet-httprepl \ 
    && dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org

# Node js
RUN npm install && npm run build
RUN curl -Lo https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Azurite Storage Emulator & Function Core Tools v4
RUN nvm install 16.15.0 \
    && nvm use 16.15.0 \
    && npm install -g azure-functions-core-tools@4 --unsafe-perm true --force \
    && npm install -g azurite

# Install Angular
RUN  npx @angular/cli@latest analytics off \
    && npm i -g @angular/cli

# Kubernetes CLI
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Azure CLI Extensions without prompt
RUN az config set extension.use_dynamic_install=yes_without_prompt