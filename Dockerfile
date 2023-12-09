FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
        libgdiplus \
        libc6-dev \
        moreutils


# Use jq to update the JSON file
RUN jq 'del(.libraries["System.Drawing.Common/4.7.0"])' /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json | sponge /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json