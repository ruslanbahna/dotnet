FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgdiplus \
        libc6-dev \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Optionally, you can add a reference to System.Drawing.Common in a .csproj file if you have one.
# Alternatively, you can add it directly using dotnet CLI in the image, but this might not be the best practice.
# RUN dotnet add package System.Drawing.Common

# Your other configurations or commands go here