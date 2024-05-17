# Use the Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    software-properties-common \
    ca-certificates \
    libc6 \
    libgcc-s1 \
    libgssapi-krb5-2 \
    libicu74 \
    liblttng-ust1 \
    libssl3 \
    libstdc++6 \
    libunwind8 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Add the Microsoft package signing key to your list of trusted keys and add the package repository
RUN wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Update the package list and install the .NET 8.0 SDK
RUN apt-get update && apt-get install -y dotnet-sdk-8.0