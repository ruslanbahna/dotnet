FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-labe=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgdiplus \
        libc6-dev \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
    && dotnet add package System.Drawing.Common --version 8.0.0