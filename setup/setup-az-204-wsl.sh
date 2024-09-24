#!/bin/bash
# run as sudo on wsl

set -e
set -o pipefail

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl -fsSL https://aka.ms/install-azd.sh | sudo bash
# Install Azure CLI Extensions without prompt
az config set extension.use_dynamic_install=yes_without_prompt

# requires win installation of Azure Data Studio
# https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio?view=sql-server-ver16&tabs=win-install%2Cwin-user-install%2Credhat-install%2Cwindows-uninstall%2Credhat-uninstall#install-azure-data-studio
#"/mnt/c/Users/$(whoami)/AppData/Local/Programs/Azure Data Studio/azuredatastudio.exe"

# Kubernetes CLI
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Node js
sudo apt-get install nodejs
sudo apt-get install npm 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# dotnet
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update
apt-get install -y dotnet-sdk-8.0
sudo apt-get install -y dotnet-runtime-8.0
# Install httprepl
dotnet tool install -g Microsoft.dotnet-httprepl
# Set NuGet Source
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org

# Azurite Storage Emulator & Function Core Tools v4
nvm install 16.15.0
nvm use 16.15.0
npm install -g azure-functions-core-tools@4 --unsafe-perm true --force
npm install -g azurite

# Install Angular
Write-Host "Installing Angular - 6/6" -ForegroundColor yellow
npx @angular/cli@latest analytics off
npm i -g @angular/cli


env=dev
loc=eastus
grp=thisgrps
acct=food-cosmos-$env
dbname=fooddb-$env

az group create --name $grp --location $loc
az cosmosdb create --name $acct --kind GlobalDocumentDB -g $grp
 