FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-labe=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

# Install the required version of System.Drawing.Common without specifying a vulnerable version
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgdiplus \
        libc6-dev \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
    && dotnet add package System.Drawing.Common

# Perform Trivy vulnerability scanning
RUN trivy --quiet filesystem --exit-code 1 --ignore file:/usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json
