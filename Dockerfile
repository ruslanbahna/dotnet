# FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# # Install necessary tools
# RUN apt-get update && apt-get install -y nuget

# # Create a temporary project to force an update of the package
# WORKDIR /tmp/update-project
# RUN dotnet new console
# RUN dotnet add package System.Data.SqlClient --version 4.8.6

# # Copy the updated packages to the .NET SDK directory
# RUN cp -r /tmp/update-project/bin/Debug/net6.0/* /usr/share/dotnet/sdk/8.0.101/

# # Clean up
# WORKDIR /
# RUN rm -rf /tmp/update-project


# Use a base image, for example:
# FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# # Install necessary tools
# RUN apt-get update && apt-get install -y nuget
# RUN apt-get update && apt-get dist-upgrade -y

# # Create a temporary project to force an update of the package
# WORKDIR /tmp/update-project
# RUN dotnet new console

# # Update the System.Data.SqlClient package
# # (Note: Since you don't have a project file, you can't use dotnet add package)
# # Manually remove the vulnerable DLL file from your image
# RUN find / -name "System.Data.SqlClient.dll" -delete

# # Publish the project to resolve and include all dependencies
# RUN dotnet publish -c Release -o /published-app

# # Final image
# FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
# COPY --from=0 /published-app /app

# Use a base image as the starting point
# Use a specific version of Ubuntu as the base image
# Use Ubuntu 22.04 as the base image
# Use Ubuntu 22.04 as the base image



# FROM ubuntu:latest

# # Set frontend to noninteractive to avoid timezone prompt
# ENV DEBIAN_FRONTEND=noninteractive \
#     TERM=xterm

# # Add Microsoft package signing key and package repository
# RUN \
#     --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
#     apt-get update ; \
#     apt-get --no-install-recommends --quiet --yes -o=Dpkg::Use-Pty=0 upgrade ; \
#     apt-get --no-install-recommends install -y wget apt-transport-https software-properties-common ; \
#     wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb ; \
#     dpkg -i packages-microsoft-prod.deb ; \
#     rm packages-microsoft-prod.deb ; \
#     apt-get update ; \
#     apt-get --no-install-recommends --quiet --yes -o=Dpkg::Use-Pty=0 upgrade ; \
#     apt-get --no-install-recommends install --yes dotnet-sdk-8.0 jq moreutils nuget ; \
#     jq 'del(.libraries["System.Drawing.Common/4.7.0"])' /usr/share/dotnet/sdk/*/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json | sponge /usr/share/dotnet/sdk/*/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json ; \
#     apt-get purge --yes wget apt-transport-https software-properties-common  jq moreutils ; \
#     apt --yes autoremove ; \
#     apt-get clean ; \
#     rm -rf /var/lib/apt/lists/*



# # Use the latest Ubuntu image as base working verison 
# FROM ubuntu:latest

# # Replace shell with bash to ensure compatibility with NVM scripts
# SHELL ["/bin/bash", "-c"]

# # Install dependencies required for NVM and Node.js
# RUN apt-get update && apt-get install -y curl git ca-certificates && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# # Install NVM
# ENV NVM_DIR /root/.nvm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# # Install Node.js using NVM and set it as the default version
# RUN . "$NVM_DIR/nvm.sh" && nvm install node && nvm use node && nvm alias default node

# # Update PATH to include the NVM Node.js bin directory
# ENV PATH "$NVM_DIR/versions/node/$(nvm current)/bin:$PATH"

# # Confirm installation
# RUN node -v && npm -v

# Use the latest Ubuntu image as base
FROM ubuntu:latest

# Set environment variables for NVM installation
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION stable

# Install dependencies required for NVM and Node.js
RUN apt-get update && \
    apt-get install -y curl build-essential libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Install Node.js LTS and NPM
RUN . "$NVM_DIR/nvm.sh" && nvm install --lts && nvm use --lts
RUN apt-get purge curl build-essential libssl-dev -y

# Add NVM binaries to PATH
ENV PATH $NVM_DIR/versions/node/$(nvm version --lts)/bin:$PATH













