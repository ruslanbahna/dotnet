FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
        libgdiplus \
        libc6-dev \
    && apt-get clean \
RUN sed -i 's/"System.Drawing.Common\/4.7.0": {[^}]*}/"System.Drawing.Common\/4.7.0": {"type": "package", "serviceable": false, "sha512": "", "path": "", "hashPath": ""}/' /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json \
