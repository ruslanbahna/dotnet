FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
        libgdiplus \
        libc6-dev


# Use jq to update the JSON file
RUN jq '.targets[".NETCoreApp,Version=v6.0"]["System.Windows.Extensions/4.7.0"].dependencies."System.Drawing.Common" = "8.0.0"' /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json