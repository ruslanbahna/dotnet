FROM ubuntu:latest
LABEL my-label=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         jq \
#         moreutils


# # Use jq to update the JSON file
# RUN jq 'del(.libraries["System.Drawing.Common/4.7.0"])' /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json | sponge /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json
RUN apt-get update && \
    apt-get install -y lsb-release wget jq && \
    repo_version=$(lsb_release -r -s) && \
    wget --no-check-certificate https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y libc6 libgcc1 libgcc-s1 libgssapi-krb5-2 libicu70 liblttng-ust1 libssl3 libstdc++6 libunwind8 zlib1g && \
    apt-get install -y dotnet-sdk-8.0

RUN apt-get remove -y libgdiplus
