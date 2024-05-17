# Use the Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    libc6 \
    libgcc-s1 \
    libgssapi-krb5-2 \
    libicu74 \
    libssl3 \
    libstdc++6 \
    libunwind8 \
    zlib1g \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install the .NET SDK manually
RUN curl -fSL https://dotnetcli.azureedge.net/dotnet/Sdk/8.0.100/dotnet-sdk-8.0.100-linux-x64.tar.gz -o dotnet-sdk.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet-sdk.tar.gz -C /usr/share/dotnet \
    && rm dotnet-sdk.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Verify dotnet installation
RUN dotnet --info