FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

# Install necessary tools and dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
        libgdiplus \
        libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the original deps.json file and modify it in-place
COPY /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json.orig
RUN jq '.libraries["System.Drawing.Common/4.7.0"] = {"type": "package", "serviceable": false, "sha512": "", "path": "", "hashPath": ""}' /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json.orig > /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json